#!groovy

STACK_NAME = "performance-testing-load-generators"
MONITORING_STACK_NAME = "monitoring-performance-testing"

def createStack(ctx){
    withCredentials([string(credentialsId: 'perf_redis_password_u51', variable: 'redisPassword')]) {

        sh(script: "aws cloudformation create-stack --stack-name ${STACK_NAME} \
            --region ${targetRegion} \
            --template-body file://${WORKSPACE}/carrier-io/scripts/cloudformation/load_generator.yml \
            --parameters ParameterKey=InstanceType,ParameterValue=${ctx.instanceType} \
            ParameterKey=SpotPrice,ParameterValue=${ctx.spotPrice} \
            ParameterKey=LoadGeneratorsCount,ParameterValue=${ctx.loadGeneratorsCount} \
            ParameterKey=ReportingInstanceHost,ParameterValue=${ctx.reportingInstanceUrl} \
            ParameterKey=LoadGeneratorMemory,ParameterValue=${ctx.lgMemory} \
            ParameterKey=RedisPassword,ParameterValue=${redisPassword}")
        sh(script: "aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME} --region ${ctx.targetRegion}")
    
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
    sh(script: "aws cloudformation delete-stack --stack-name ${stackName} --region ${ctx.targetRegion}")
    sh(script: "aws cloudformation wait stack-delete-complete --stack-name ${stackName} --region ${ctx.targetRegion}")
}

def executePerformanceTest(ctx){
    def usersCount = Math.round((ctx.users.toInteger() / ctx.loadGeneratorsCount.toInteger()).floatValue())
    final files = findFiles(glob: 'workflows-scripts/**/*.jmx')
    for (def i=0; i<files.length; i++) {
        
        def testName        = "${files[i].name.minus('.jmx')}"
        def pathAndName     = "${files[i].path.minus('.jmx')}"
        def parentFolder    = "${files[i].path.minus(files[i].name)}"
        def artifact        = "${testName}.zip"

        zip zipFile: "${artifact}", archive: false, dir: "${parentFolder}"

        // Read properties
        def props = readProperties interpolate: true, defaults: ctx, file: '${pathAndName}.properties'

        withCredentials([string(credentialsId: 'perf_carrier_io_token_u51', variable: 'carrierToken')]) {
            //httpRequest httpMode: 'POST', uploadFile: "${pathAndName}.zip", customHeaders: [[name: 'Authorization', value: 'bearer ${carrierToken}']], url: "http://${reportingInstanceUrl}/api/v1/artifacts/${projectId}/${bucket}/${test_Name}.zip"
            sh "curl -L -w '\n' -X POST -D - http://${props.reportingInstanceUrl}/api/v1/artifacts/${props.projectId}/${props.bucket}/${props.artifact} \
                -H 'Authorization: bearer ${carrierToken}' \
                -F 'file=@${artifact}'"

            withCredentials([string(credentialsId: 'perf_redis_password_u51', variable: 'redisPassword')]) {
                sh "docker pull getcarrier/control_tower:latest && docker run -t --rm \
                    -e REDIS_HOST=${props.reportingInstanceUrl} \
                    -e REDIS_PASSWORD=${redisPassword} \
                    -e loki_host=http://${props.reportingInstanceUrl} \
                    -e loki_port=3100 \
                    -e build_id=build_${JOB_NAME}_${BUILD_ID} \
                    -e galloper_url=http://${props.reportingInstanceUrl} \
                    -e token=${props.carrierToken} \
                    -e bucket=${props.bucket} \
                    -e JVM_ARGS='-Xmx${props.lgMemory}g' \
                    -e duration=${props.duration} \
                    -e artifact=${artifact} \
                    getcarrier/control_tower:latest \
                        -c getcarrier/perfmeter:latest \
                        -e '{\"cmd\": \"-n -t /mnt/jmeter/${testName}.jmx\", \
                            \"distribution\": \"${props.distribution}\", \
                            \"tenant\": \"${props.tenant}\", \
                            \"test_name\": \"${testName}\", \
                            \"test.type\": \"${props.testType}\", \
                            \"vusers\": \"${usersCount}\", \
                            \"HOSTNAME\": \"${props.targetUrl}\", \
                            \"RAMP_UP\": \"${props.rampUp}\", \
                            \"duration\": \"${props.duration}\", \
                            \"influx.host\": \"${props.reportingInstanceUrl}\"}' \
                        -r 1 -t perfmeter -q ${loadGeneratorsCount} -n performance_test_job"
            }
        }
        break; // remove to run all tests
    }
}

def getInstancesCount(String targetCluster){
    def allInstances = sh([
        script: "aws ecs list-container-instances --cluster ${targetCluster} | jq [.containerInstanceArns[]]",
        returnStdout: true
    ]);
    allInstances = Eval.me(allInstances)
    return allInstances;
}

def installTelegrafAgent(ctx){
    def allInstances = getInstancesCount(ctx.targetCluster)
    for(i=1; i <= allInstances.size(); i++){
        def nodeName = targetCluster + '-node-' + i;
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

//def sendNotification(String testName, String testType, int users, String reportingInstanceUrl, String emailsList, String galloperTaskIdForNotifications){
//    sh(script: """curl -XPOST -H "Content-Type: application/json" -d '{"notification_type": "api","test": "${testName}", "test_type": "${testType}", "users": ${users}, "influx_host": "${reportingInstanceUrl}", "smpt_user": "folio.email.notifications@gmail.com","smpt_password": "dPwbI9CYw5M5bjU6", "user_list": [${emailsList}]}' http://${reportingInstanceUrl}/task/${galloperTaskIdForNotifications}""")
//}

def getContext() {
  
    def ctx = readProperties file: 'carrier-io/system.properties'
    
    return ctx

}

return this
