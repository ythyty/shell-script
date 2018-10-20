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

JARFILE=`find ${BIN_DIR}/ -name "*.jar"`

if [ -f ${JARFILE} ];then
    JARNAME=${JARFILE##*/}
    cp -f ${JARFILE} ${BACKUP_DIR}/${JARNAME%.*}-${DATE}-${BUILD_NUMBER}.jar
fi

rsync -var --delete ${WORKSPACE}/${PROJECT}/target/ ${BIN_DIR}/

export JARFILE=`find ${BIN_DIR}/ -name "*.jar"`

rm -rf ${LOG_DIR}/stdout.log

cd /rwda/jenkins_ci_sh/
sh spring-boot.sh restart

sleep 5
echo "获取日志"
cat ${LOG_DIR}/stdout.log

echo "查看端口号："
ps -ef | grep java | grep ${PROJECT} | grep -v grep | awk '{print $2}'
PID=`ps -ef | grep java | grep ${PROJECT} | grep -v grep | awk '{print $2}'`
if [ -z "${PID}" ];then
	echo "${PROJECT} 启动失败"
else
	echo "${PROJECT} 启动完成"
fi

cd ${BACKUP_DIR}
ls -lt|awk 'NR>5{print $NF}'|xargs rm -rf