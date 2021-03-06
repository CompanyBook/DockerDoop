#!/bin/bash

if [[ -z $3 ]]; then
  echo "Usage: $0 <node name> <ambariServerHostName> <clusterName>  [<externalIP>]"
  exit -1
fi

nodeName="$1"
ambariServerHostName="$2"
clusterName="$3"

portParams=""


if [[ -n $4 ]]; then
    externalIP="$4"

    ports=("9092:9092" "9096:9096" "9095:9095" "16000:16000" "16010:16010" "16020:16020" "16030:16030"
        "2223:22" "2181:2181" "3372:3372" 
        "3373:3373" "6627:6627" "6667:6667" "6700:6700" "6701:6701" "6702:6702" 
        "6703:6703" "8000:8000" "8010:8010" "8020:8020" "8025:8025" "8030:8030" 
        "8032:8032" "8050:8050" "58080:8080" "8081:8081" "8088:8088" "8141:8141" 
        "8744:8744" "9000:9000" "9080:9080" "9081:9081" "9082:9082" "9083:9083" 
        "9084:9084" "9085:9085" "9086:9086" "9087:9087" "9999:9999" "9933:9933" 
        "10000:10000" "10020:10020" "11000:11000" "19888:19888" "45454:45454" 
        "50010:50010" "50020:50020" "50060:50060" "50070:50070" "50075:50075" "50090:50090" "50111:50111")
    for i in ${ports[@]}; do
        portParams="$portParams -p $externalIP:$i"
    done
fi
echo "portParams=$portParams"

docker network ls | grep -q $clusterName
if [ $? -ne 0 ]; then
    docker network create $clusterName
    echo "Created network for $clusterName"
fi

containerName="$nodeName.$clusterName$CONTAINER_POSTFIX"

if [ $nodeName != $ambariServerHostName ]; then
    echo "Creating Ambari agent node: $nodeName. Ambari server: $ambariServerHostName"

    docker run --privileged=true \
                -d \
                --dns 8.8.8.8 \
                $portParams \
                -e AMBARI_SERVER=$ambariServerHostName \
                --name $containerName \
                -h $nodeName \
                --net $clusterName \
                --dns-search=$clusterName \
                --restart unless-stopped \
                -i \
                -t ${AGENT_NODE_IMAGE:-hwxu/ambari_2.2_agent_node}
else
    echo "Creating Ambari server node: $nodeName"

    docker run --privileged=true \
                -d \
                --dns 8.8.8.8 \
                $portParams \
                -e AMBARI_SERVER=$ambariServerHostName \
                --name $containerName \
                -h $nodeName \
                --net $clusterName \
                --dns-search=$clusterName \
                --restart unless-stopped \
                -i \
                -t ${SERVER_NODE_IMAGE:-hwxu/ambari_2.2_server_node}
fi

internalIP=$(docker inspect --format "{{ .NetworkSettings.Networks.$clusterName.IPAddress }}" $containerName)


if [[ -n $4 ]]; then
    echo "$nodeName started. Internal IP = $internalIP, External IP = $4, Cluster = $clusterName"
else
    echo "$nodeName started. Internal IP = $internalIP, Cluster = $clusterName"
fi
