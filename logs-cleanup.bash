#!/bin/bash

CONTAINERID='namenode.singlenode'
docker exec $CONTAINERID du -h /var/log
gcs=`docker exec $CONTAINERID find /var/log/hbase/ -name "gc.log*"`
docker exec $CONTAINERID rm -f $gcs
docker exec $CONTAINERID rm /var/log/hbase/SecurityAuth.audit
docker exec $CONTAINERID rm /var/log/hbase/hbase-hbase-master-namenode.log
docker exec $CONTAINERID rm /var/log/hbase/hbase-hbase-regionserver-namenode.log
docker exec $CONTAINERID rm -rf /hadoop/yarn/log/
gcs=`docker exec $CONTAINERID find /var/log/hadoop/hdfs/ -name "*"`
echo $gcs
docker exec $CONTAINERID rm -f $gcs
docker exec $CONTAINERID du -h /var/log
