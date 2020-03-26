#!/bin/bash

# add the following to an existing docker-entrypoint file.
# merge the exec line to the existing docker-entrypoint file's exec command

wget https://raw.githubusercontent.com/carrier-io/jvm-profiler/master/jvm-profiler-1.0.0.jar
echo """reporter: com.uber.profiling.reporters.InfluxDBOutputReporter
tag: ${SERVICE}
metricInterval: 100000
durationProfiling: [com.fasterxml.*, org.*]
sampleInterval: 10000
influxdb.host: [TBD]
influxdb.port: 8086
influxdb.database: profiling
influxdb.username:
influxdb.password:
""" > config.yaml
chmod 777 jvm-profiler-1.0.0.jar
chmod 777 config.yaml
exec java -noverify -javaagent:"/usr/ms/jvm-profiler-1.0.0.jar"=configProvider=com.uber.profiling.YamlConfigProvider,configFile="/usr/ms/config.yaml" -cp "/usr/ms/jvm-profiler-1.0.0.jar"
