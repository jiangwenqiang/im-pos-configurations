#!/bin/bash
# chkconfig: 2345 85 85
# description: ssg-service is a micro-service component for lige short message service
# processname: ssg-service
# Created By: jiangwenqiang
port=8180
applications=(
	"im-pos-service-registeration"
	"im-pos-service-configuration"
)

for application in ${applications[@]}
do
   echo "starting application:"$application "port:"$port
   nohup java -server -Xms256m -Xmx512m -jar $application".war" --server.port=$port > $application".log" 2>&1 &
   port=8888
   sleep 3;
done	

port=8180
logfile=""
for application in ${applications[@]}
do
   logfile=$logfile" "$application".log"
done	

tail -f $logfile