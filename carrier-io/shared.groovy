#!groovy

def createStack(ctx){
    
    if (stackExists(ctx)) {
        echo "Skip creating ${ctx.stackName}"
        return;
    }

    withCredentials([string(credentialsId: 'perf_redis_password_u51', variable: 'redisPassword')]) {

        sh(script: "aws cloudformation create-stack --stack-name ${ctx.stackName} \
            --region ${ctx.targetRegion} \
            --template-body file://${WORKSPACE}/carrier-io/scripts/cloudformation/load_generator.yml \
            --parameters ParameterKey=InstanceType,ParameterValue=${ctx.instanceType} \
            ParameterKey=ECSCluster,ParameterValue=${ctx.targetCluster} \
            ParameterKey=SpotPrice,ParameterValue=${ctx.spotPrice} \
            ParameterKey=LoadGeneratorsCount,ParameterValue=${ctx.loadGeneratorsCount} \
            ParameterKey=ReportingInstanceHost,ParameterValue=${ctx.reportingInstanceUrl} \
            ParameterKey=LoadGeneratorMemory,ParameterValue=${ctx.lgMemory} \
            ParameterKey=RedisPassword,ParameterValue=${redisPassword}")
        sh(script: "aws cloudformation wait stack-create-complete --stack-name ${ctx.stackName} --region ${ctx.targetRegion}")
    }
} 

def populateData(String tenant){
    sh(script: "unzip [TBD - dataset zip]")
    sh(script: "apt-get install uuid-runtime")
    sh(script: "apt-get install -y postgresql postgresql-contrib")
    sh(script: "apt-get install -y jq")
    sh(script: "[TBD]")
}

def deleteStack(ctx){
    sh(script: "aws cloudformation delete-stack --stack-name ${ctx.stackName} --region ${ctx.targetRegion}")
    sh(script: "aws cloudformation wait stack-delete-complete --stack-name ${ctx.stackName} --region ${ctx.targetRegion}")
}

def executePerformanceTest(ctx, excludeTestsList, sendReports){
    
    final files = findFiles(glob: 'workflows-scripts/**/*.jmx', excludes: excludeTestsList)
    for (def i=0; i<files.length; i++) {
        
        def testName        = "${files[i].name.minus('.jmx')}"
        def pathAndName     = "${files[i].path.minus('.jmx')}"
        def parentFolder    = "${files[i].path.minus(files[i].name)}"
        def artifact        = "${testName}.zip"
        def propertiesFile  = "${parentFolder}/test.properties"

        // Read properties
        def props = readProperties defaults: ctx, file: propertiesFile
        def usersCount = Math.round((props.users.toInteger() / props.loadGeneratorsCount.toInteger()).floatValue())

        withCredentials([string(credentialsId: 'perf_carrier_io_token_u51', variable: 'carrierToken')]) {
            if (props.uploadArtifact) {
                withCredentials([file(credentialsId: 'perf_tests_credentials', variable: 'FILE')]) {
                    sh(script: "mv ${FILE} ${parentFolder}/jmeter-supported-data")
                    zip zipFile: "${artifact}", archive: false, dir: "${parentFolder}"
                    //httpRequest httpMode: 'POST', uploadFile: "${pathAndName}.zip", customHeaders: [[name: 'Authorization', value: 'bearer ${carrierToken}']], url: "http://${reportingInstanceUrl}/api/v1/artifacts/${projectId}/${bucket}/${testName}.zip"
                    sh "curl -sSL -X POST -D - http://${props.reportingInstanceUrl}/api/v1/artifacts/${props.projectId}/${props.bucket}/${artifact} \
                        -H 'Authorization: bearer ${carrierToken}' \
                        -F 'file=@${artifact}'"
                }
            }

            withCredentials([string(credentialsId: 'perf_redis_password_u51', variable: 'redisPassword')]) {
                sh "docker pull getcarrier/control_tower:latest && docker run -t --rm \
                    -e REDIS_HOST=${props.reportingInstanceUrl} \
                    -e REDIS_PASSWORD=${redisPassword} \
                    -e loki_host=http://${props.reportingInstanceUrl} \
                    -e loki_port=3100 \
                    -e build_id=build_${props.envType}_${BUILD_ID} \
                    -e galloper_url=http://${props.reportingInstanceUrl} \
                    -e token=${carrierToken} \
                    -e bucket=${props.bucket} \
                    -e project_id=${props.projectId} \
                    -e JVM_ARGS='-Xmx${props.lgMemory}g' \
                    -e DURATION=${props.duration} \
                    -e artifact=${artifact} \
                    getcarrier/control_tower:latest \
                        -c getcarrier/perfmeter:latest \
                        -e '{\"cmd\": \"-n -t /mnt/jmeter/${testName}.jmx -Jtest_name=${testName} -JDISTRIBUTION=${props.distribution} -Jtenant=${props.tenant} -Jtest.type=${props.testType} -Jenv.type=${props.envType} -JVUSERS=${usersCount} -JHOSTNAME=${props.targetUrl} -JRAMP_UP=${props.rampUp} -JDURATION=${props.duration} -Jinflux.host=${props.reportingInstanceUrl} \"}' \
                        -r 1 -t perfmeter -q ${props.loadGeneratorsCount} -n performance_test_job"
            }
        }
        
        if (sendReports) {
            echo 'Sending report ...'
            sendNotification(props, testName, usersCount)
        }

        break; // remove to run all tests
    }
}

def getInstancesCount(targetCluster, targetRegion){
    def allInstances = sh(
        script: "aws ecs list-container-instances --cluster ${targetCluster} --region ${targetRegion}  --output json | jq [.containerInstanceArns[]]",
        returnStdout: true
    );
    allInstances = Eval.me(allInstances)
    return allInstances;
}

def installTelegrafAgent(ctx){
    def allInstances = getInstancesCount(ctx.targetCluster, ctx.targetRegion)
    for(i=1; i <= allInstances.size(); i++){
        def nodeName = ctx.targetCluster + '-node-' + i;
        sh(script: "aws ecs register-task-definition --cli-input-json file://${WORKSPACE}/carrier-io/scripts/cloudformation/telegraf.json")
        sh(script: """aws ecs start-task --cluster ${ctx.targetCluster} \
            --overrides '{ "containerOverrides": [ { "name": "busybox", "environment": [ { "name": "INFLUX_HOST", "value": "http://${ctx.reportingInstanceUrl}:8086" }, { "name": "TELEGRAF_NODE_HOSTNAME", "value": "${nodeName}" } ] } ] }' \
            --task-definition telegraf-monitoring --container-instances ${allInstances[i-1]}""")
    }
}

def stopMonitoringTask(ctx){
    def taskArns = sh([
        script: "aws ecs list-tasks --cluster ${ctx.targetCluster} --family telegraf-monitoring | jq [.taskArns[]]",
        returnStdout: true
    ]);
    taskArns = Eval.me(taskArns)
    if(taskArns != null){
        for(int i=0; i<taskArns.size(); i++){
            sh(script: "aws ecs stop-task --cluster ${ctx.targetCluster} --task ${taskArns[i]}")
        }
    }
}

def stopAllInstances(ctx){
    def allInstances = getInstancesCount(ctx.targetCluster, ctx.targetRegion)
    for(i=0; i<allInstances.size(); i++){
        sh(script: "aws ecs deregister-container-instance --cluster ${ctx.targetCluster} --region ${ctx.targetRegion} --container-instance ${allInstances[i]} --force")
    }
}

def stopAllServices(ctx){
    def allServices = sh(
        script: "aws ecs list-services --cluster ${ctx.targetCluster} --region ${ctx.targetRegion}  --output json | jq [.serviceArns[]]",
        returnStdout: true
    );
    allServices = Eval.me(allServices)
    for(i=0; i<allServices.size(); i++){
        sh(script: "aws ecs delete-service --cluster ${ctx.targetCluster} --region ${ctx.targetRegion} --service ${allServices[i]} --force")
    }
}

def sendNotification(ctx, testName, usersCount){
    withCredentials([string(credentialsId: 'perf_slack_token_u51', variable: 'slackToken')]) {
        sh(script: """curl -sSL -X POST -H "Content-Type: application/json" -d '{"notification_type": "api","test": "${testName}", "test_type": "${ctx.testType}", "users": "${usersCount}", "slack_channel": "#ptf_reports","slack_token": "${slackToken}", "influx_host": "${ctx.reportingInstanceUrl}"}' ${ctx.notificationsWebHook}""")
    }
}

def getContext() {
  
    def ctx = readProperties file: 'carrier-io/system.properties'
    
    return ctx

}

// test if stack exists
def stackExists(ctx) {
    try {
        sh("aws --output json cloudformation describe-stacks --stack-name ${ctx.stackName} > aws.output")
        return true;
    } catch (e) {
        return false;
    }
}

return this
