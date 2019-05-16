#!/bin/bash
# chkconfig: 2345 10 90 
# description: myservice ....

# start hadoop service
start-dfs.sh
start-yarn.sh

# start hbase service
start-hbase.sh

# start kafka service
kafka-server-start.sh -daemon /opt/kafka_2.12-2.2.0/config/server.properties
kafka-manager -Dhttp.port=8080 -Dconfig.file=/opt/kafka-manager-2.0.0.2/conf/application.conf
