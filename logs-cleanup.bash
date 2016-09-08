#!/bin/bash

CONTAINERID='2ef9290c69d2'
docker exec $CONTAINERID du -h /var/log/hbase
docker exec $CONTAINERID rm /var/log/hbase/gc.log-201607190854
docker exec $CONTAINERID rm /var/log/hbase/SecurityAuth.audit
docker exec $CONTAINERID rm /var/log/hbase/hbase-hbase-master-namenode.log
docker exec $CONTAINERID rm /var/log/hbase/hbase-hbase-regionserver-namenode.log
docker exec $CONTAINERID du -h /var/log/hbase
