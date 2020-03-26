# Introduction

Carrier is an open source continuous testing toolkit.

It consists of tools and practices to integrate non-functional tests into delivery pipeline and organize effective feedback loop. 

### Installation

Carrier installer you can find [here](https://github.com/carrier-io/carrier-io/blob/master/README.md)

Quick and guided installation of Carrier you can find [here](https://getcarrier.io/#how)

If you use the installer, it will automatically create the necessary databases in InfluxDB and dashboards in Grafana.

After installation you will only need to add the JVM profiling dashboard.

You can also install all components manually

Manual installation is described in p.1.1 Performance framework guide.

You can find the description of the Grafana dashboards in p.1.2 Performance framework guide

### Perfmeter
*Carrier customized JMeter container*

**Extensions made:**
1. InfluxDB Listener automatically added to test for reporting
2. Failed requests automatically reported to Loki and displayed in Grafana dashboard
3. Post processing of execution metrics automatically logs aggregated states for build-to-build comparison
4. Support of masterless distributed tests execution using control-tower and interceptor
5. Post processing and Email notifications

### Local execution:

Example docker invocation:

``` 
	docker run --rm -u 0:0 \
	       -e galloper_url=http://${reportingInstanceUrl} \
	       -e bucket=${bucketName} -e artifact=${artifactFile}.zip \ 
	       -e loki_host=http://${reportingInstanceUrl} \
	       -e loki_port=3100 \
	       -e JVM_ARGS='-Xms1g -Xmx2g' \
	       -e additional_files='{"tests/InfluxBackendListenerClient-1.1.jar": "/jmeter/apache-jmeter-5.0/lib/ext/InfluxBackendListenerClient.jar"}' \
	       getcarrier/perfmeter:1.5 \
       -n -t /mnt/jmeter/${testName}.jmx \
	       -JDISTRIBUTION=${distribution} \
	       -Jtest_name=${testName} \
	       -Jtest.type=${testType} \   
	       -Jenv.type=${targetEnv} \
	       -JVUSERS=${usersCount} \
	       -JHOSTNAME=${targetUrl} \
	       -JRAMP_UP=${rampUp} \
           -JDURATION=${duration} \
	       -Jinflux.host=${reportingInstanceUrl}
```

`test.type` - optional tag, used to filter test results

`env.type` - optional tag, used to filter test results

`loki_host` - loki host or IP, used to report failed requests to Loki

`loki_port` - optional, default 3100

`test_name` - name of the JMeter test file that will be run

`JVM_ARGS` - Java heap params, like `-Xms1g -Xmx1g`

`artifactFile.zip` - Name of .zip file with tests, see p.2.2 in Performance framework guide

`bucketName` - Galloper bucket name, see p.2.3 in Performance framework guide


### Post processing

After the end of the test, each load generator sends artifacts and the necessary information for post-processing to the minio bucket. 

So you need to pass environment variable `galloper_url=http://{{ galloper_url }}` to control tower.

For post-processing, a bucket is created by the name of the control tower job.

Also you may specify a prefix to the files to be saved in minio. To do this, pass the variable `PREFIX` to control tower.

Post processing is used for aggregation of test results. The summary result is written in the comparison table.

To run the post processing, you need to create a task in the Galloper with post processing lambda.

To do this, you need to go to the main page (port 80) of the instance with the carrier installed.
 
On the left side there is a menu, you need to click on the tasks section. And then click on the “Add Task” button.

When you create a task, you need to specify a lambda handler in it – “lambda_function.lambda_handler”.

The Lambda functions for notifications are written in python 3.7, so you need to specify this in the "Runtime" field when creating the task.

You also need to upload a zip file with the packed function [function](https://github.com/folio-org/ci-perf/blob/master/galloper-tasks/post_processing.zip).

Click “Create Task” button and you will be redirected to the page with created function details. You need to copy a webhook to the function.

Then you need to pass an environment variable `GALLOPER_WEB_HOOK=http://{{ galloper_url }}/task/{{ web_hook }}` to control tower.


### Email notifications

At the end of the test, you can receive an email notification with the test results.
 
In addition to the results of the current test, the email also contains a comparison of the last five tests in the form of a table and several charts.

To use email notifications, you need to create a task in Galloper.

To do this, you need to go to the main page (port 80) of the instance with the carrier installed.

On the left side there is a menu, you need to click on the tasks section. And then click on the “Add Task” button.

When you create a task, you need to specify a lambda handler in it – “lambda_function.lambda_handler”.
  
The Lambda functions for notifications are written in python 3.7, so you need to specify this in the "Runtime" field when creating the task.
 
You also need to upload a zip file with the packed function. You can find lambda function that provide email notifications [here](https://github.com/folio-org/ci-perf/blob/master/galloper-tasks/email_notifications.zip)

Click “Create Task” button and you will be redirected to the page with created function details.
 
You need to copy a webhook to the function.

You can run a task with an email notification using CURL. Example how to invoke a task using CURL:

```
curl -XPOST -H "Content-Type: application/json"
    -d '{"param1": "value1", "param2": "value2", ...}' http://<reportingInstanceUrl>/<webhook>
```

<host> - Galloper host DNS or IP
<webhook> - POST Hook to call your task

A list of all valid parameters that can be passed to the function is provided below:

•	'test': '<test_name>' – test name, e.g. “Folio”

•	'test_type': '<test_type>' – e.g capacity, fixed_load

•	'users': '<count_of_vUsers>' - vUsers count for test execution

•	'influx_host': '<influx_host_DNS_or_IP>' –“ec2-3-83-89-118.compute-1.amazonaws.com”

•	'smpt_user': '<email>' – smpt user who will send an email

•	'smpt_password': '<password>'

•	'user_list': 'list of recipients' – [“email.gmail.com”, “email.gmai2.com”]

•	'notification_type': 'api'

Additional params you can find on the carrier [wiki page](https://github.com/carrier-io/carrier-io/wiki/Performance-Testing.-Notification-and-Alerting)

### Jenkins pipeline

Carrier Perfmeter can be started inside Jenkins CI/CD pipeline.

Here is an example pipeline that will run JMeter test in distributed mode.

```
	docker pull getcarrier/control_tower:1.5 && docker run -t --rm \
	        -e REDIS_HOST=${reportingInstanceUrl} \
	        -e loki_host=http://${reportingInstanceUrl} \
	        -e loki_port=3100 \
	        -e GALLOPER_WEB_HOOK=http://${reportingInstanceUrl}/task/${galloperTaskId} \
            -e galloper_url=http://${reportingInstanceUrl} \
	        -e bucket=${bucketName}\
            -e JVM_ARGS='-Xmx${lgMemory}g' \
	        -e DURATION=${duration} \
	        -e additional_files='{\"tests/InfluxBackendListenerClient-1.1.jar\": \"/jmeter/apache-jmeter-5.0/lib/ext/InfluxBackendListenerClient.jar\"}' \
            -e artifact=${artifactFile}.zip getcarrier/control_tower:1.5 \     
            -c getcarrier/perfmeter:1.5 -e '{\"cmd\": \"-n -t /mnt/jmeter/${testName}.jmx -JDISTRIBUTION=${distribution} -Jtest_name=${testName} -Jtest.type=${testType} -Jenv.type=${targetEnv} -JVUSERS=${usersCount} -JHOSTNAME=${targetUrl} -JRAMP_UP=${rampUp} -JDURATION=${duration} -Jinflux.host=${reportingInstanceUrl} \"}' -r 1 -t perfmeter -q ${loadGeneratorsCount} \     
            -n supertestjob    
```

### Getting tests from object storage

You can upload your JMeter tests with all the necessary files (csv files, scripts) in ".zip" format to the Galloper artifacts.

Precondition for uploading tests is bucket availability in object storage

To create a bucket you should:

1. Open a galloper url in the browser e.g. `http://{{ galloper_url }}`
2. Click on  Artifacts in the side menu
3. Click on the Bucket icon in right side of the page and choose `Create New Bucket`
4. Name your bucket e.g. jmeter

Now you can upload your tests with all dependencies in ".zip" format.

In order to run the tests you can use the following command

```
docker run --rm -t -u 0:0 \
        -e galloper_url="http://{{ galloper_url }}" \
        -e bucket="jmeter" -e artifact="{{ file_with_your_tests.zip }}" \
        getcarrier/perfmeter:1.5 \
        -n -t /mnt/jmeter/{{ test_name }}.jmx \
        -Jinflux.host={{ influx_dns_or_ip }}
```

What it will do is copy saved artifact to `/mnt/jmeter/` folder and execute JMeter test `{{ test_name }}.jmx`

Also you can upload additional plugins/extensions to JMeter container using env variable `additional_files`

To do that you should upload your files to the Galloper artifacts and add env variable to the docker run command like this:

```
docker run --rm -t -u 0:0 \
       -e galloper_url="http://{{ galloper_url }}" \
       -e additional_files='{"jmeter/InfluxBackendListenerClient.jar": "/jmeter/apache-jmeter-5.0/lib/ext/InfluxBackendListenerClient.jar"}',
       getcarrier/perfmeter:1.5 \
       -n -t /mnt/jmeter/{{ test_name }}.jmx \
       -Jinflux.host={{ influx_dns_or_ip }}
```

It will copy `InfluxBackendListenerClient.jar` from `jmeter` bucket to container path `/jmeter/apache-jmeter-5.0/lib/ext/InfluxBackendListenerClient.jar`