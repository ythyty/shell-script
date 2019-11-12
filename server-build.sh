#!/bin/bash

BUILD_DIR=$1
BUILD_NUMBER=$2
RUN_BASE_DIR=$3
export PROJECT=$4
export SPRING_PROFILES_ACTIVE=$5
export JAVA_MEM_OPTS=$6

DATE=$(date +%F)
HOME_DIR=${RUN_BASE_DIR}/${PROJECT}
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
	echo "备份运行目录中的JARFILE：${JARFILE}"
    JARNAME=${JARFILE##*/}
    cp -f ${JARFILE} ${BACKUP_DIR}/${JARNAME%.*}-${DATE}-${BUILD_NUMBER}.jar
fi

rsync -var --delete ${BUILD_DIR}/${PROJECT}/target/ ${BIN_DIR}/

export JARFILE=`find ${BIN_DIR}/ -name "*.jar"`
echo "将要运行JARFILE:${JARFILE}"

echo "脚本目录：$(dirname $0)"
cd $(dirname $0)
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