#!/bin/bash

WORKSPACE=$1
BUILD_NUMBER=$2
export PROJECT=$3
export SPRING_PROFILES_ACTIVE=$4
export JAVA_MEM_OPTS=$5

DATE=$(date +%F)
BASE_DIR=/rwda/runtime
HOME_DIR=${BASE_DIR}/${PROJECT}
BIN_DIR=${HOME_DIR}/bin
BACKUP_DIR=${HOME_DIR}/backup
export LOG_DIR=${HOME_DIR}/logs

if [ ! -d ${HOME_DIR} ];then
 mkdir -p ${HOME_DIR}
fi

if [ ! -d ${BIN_DIR} ];then
 mkdir -p ${BIN_DIR}
fi

if [ ! -d ${BACKUP_DIR} ];then
 mkdir -p ${BACKUP_DIR}
fi

if [ ! -d ${LOG_DIR} ];then
 mkdir -p ${LOG_DIR}
fi

cd ${BIN_DIR}

export JARFILE=`find ${BIN_DIR} -name "*.jar"`
JARNAME=${JARFILE##*/}

if [ -f ${JARFILE} ];then
    cp -f ${JARFILE} ${BACKUP_DIR}/${JARNAME%.*}-${DATE}-${BUILD_NUMBER}.jar
fi

rsync -var --delete ${WORKSPACE}/${PROJECT}/target/${JARNAME} ${BIN_DIR}/${JARNAME}

rm -rf $LOG_PATH/stdout.log

sh spring-boot restart

echo "获取日志"
cat ../logs/stdout.log 
echo "查看端口号"
netstat -ntlp |grep `ps aux |grep $item |awk '{print $2}'`
echo "重启完成"

cd ../backup/
ls -lt|awk 'NR>5{print $NF}'|xargs rm -rf

