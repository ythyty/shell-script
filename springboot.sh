#!/bin/bash

DATE=$(date +%F)
WORKSPACE=$1
APP_NAME=$2
BUILD_NUMBER=$3
DIR=/rwda/runtime/$APP_NAME
JARFILE=$APP_NAME-0.0.1-SNAPSHOT.jar
LOG_PATH=$DIR/logs

if [ ! -d $DIR/backup ];then
 mkdir -p $DIR/backup
fi

if [ ! -d $LOG_PATH ];then
 mkdir -p $LOG_PATH
fi

cd $DIR

PID=$(ps -ef | grep $JARFILE | grep -v grep | awk '{ print $2 }')
if [ -z "$PID" ]
then
    echo -----------Application is already stopped-----------
else
    echo -----------kill $PID-------------
    kill -9 $PID
    echo ------------Application is starting--------------
fi

if [ -f $JARFILE ];then
    mv $JARFILE backup/$JARFILE-$DATE-$BUILD_NUMBER.jar
fi

cp -f $WORKSPACE/$APP_NAME/target/$JARFILE .

BUILD_ID=dontKillMe nohup java -jar $JARFILE 1>>$LOG_PATH/stdout.log 2>>$LOG_PATH/error.log &

if [ $? = 0 ];then
    sleep 2
    tail -n 50 $LOG_PATH/stdout.log
fi

cd backup/
ls -lt|awk 'NR>5{print $NF}'|xargs rm -rf