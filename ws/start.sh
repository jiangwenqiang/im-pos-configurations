#!/bin/bash
# chkconfig: 2345 85 85
# description: ssg-service is a micro-service component for lige short message service
# processname: ssg-service
# Created By: jiangwenqiang

port=8180
appname="$2"
applications=(
	"im-pos-service-registeration"
	"im-pos-service-gate"
	"im-pos-service-entrance"
	"im-pos-service-commod"
	"im-pos-service-promotion"
	"im-pos-service-order"
	"im-pos-service-common"
	"im-pos-service-management"
	"im-pos-service-parameter"
)

case "$1" in
	start)
		for application in ${applications[@]}
		do
			if [ $appname ]; then
		   		if [ $appname == $application ]; then
		   			echo "starting application:"$application":port:"$port
		   			nohup java -server -Xms256m -Xmx512m -jar $application".war" --server.port=$port > $application".log" 2>&1 &
		   			break   
		   		fi	
		   	else
		   		echo "starting application:"$application":port:"$port
		   		nohup java -server -Xms256m -Xmx512m -jar $application".war" --server.port=$port > $application".log" 2>&1 &
		   		sleep 3;
		   	fi
		   ((port++));
		done
		;;
	stop)
	    for application in ${applications[@]}
		do
		   pid=$(ps x |grep java| grep $application|grep $port | grep -v grep | awk '{print $1}')
	       if [ $pid ]; then
	       	   if [ $appname ]; then
		       	   	if [ $appname == $application ]; then
		       	   		kill -9 $pid
		       	   		RETVAL=$?
					   	if [ $RETVAL -eq 0 ]; then
					      	echo "stopping $application success"
					   	else
					      	echo "stopping $application failed"
					   	fi
			   			break   
			   		fi		
	       	   else
		       	   echo "stopping application:"$application":port:"$port":"$pid
		       	   kill -9 $pid
			       RETVAL=$?
				   if [ $RETVAL -eq 0 ]; then
				      echo "stopping $application success"
				   else
				      echo "stopping $application failed"
				   fi
				fi
		   fi
		   ((port++));
		done
		;;
	log)
	    logfile=""
		for application in ${applications[@]}
		do
		   if [ ! $appname ]; then
		   		logfile=$logfile" "$application".log"
		   else
		   		logfile=$appname".log"
		   		break
		   fi
		done	
		tail -f $logfile
		;;
    *)
	    echo "Usage:{start|stop|log} [appname]"
	    ;;
esac	