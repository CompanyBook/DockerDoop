#!/bin/bash

if [[ -z $1 ]]; then
  echo "Usage: $0 <configuration.ini> "
  exit -1
fi

iniFile=$1

clusterName=$(awk -F "=" '/clusterName/ {print $2}' $iniFile)
cont=$(docker ps -a | grep ".*.$clusterName$CONTAINER_POSTFIX" | cut -f1 -d" ")
docker start $cont
docker exec $cont sudo service ambari start
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start HDFS via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/HDFS
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start YARN via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/YARN
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start MAPREDUCE2 via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/MAPREDUCE2
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start ZOOKEEPER via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/ZOOKEEPER
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start HBASE via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/HBASE
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start KAFKA via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/KAFKA
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start HIVE via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/HIVE
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start SPARK via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/SPARK
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start STORM via REST"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' http://namenode:58080/api/v1/clusters/$clusterName/services/STORM
