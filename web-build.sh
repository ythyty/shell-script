#!/bin/bash

BUILD_DIR=$1
BUILD_NUMBER=$2
RUN_BASE_DIR=$3
PROJECT=$4

DATE=$(date +%F)
HOME_DIR=${RUN_BASE_DIR}/${PROJECT}

if [ ! -d ${HOME_DIR} ];then
 mkdir -p ${HOME_DIR}
fi

echo "BUILD_DIR=${BUILD_DIR}"
echo "BUILD_NUMBER=${BUILD_NUMBER}"
echo "RUN_BASE_DIR=${RUN_BASE_DIR}"
echo "PROJECT=${PROJECT}"
echo "rsync -var --delete ${BUILD_DIR}/ ${HOME_DIR}/"

rsync -var --delete ${BUILD_DIR}/ ${HOME_DIR}/

echo "发布完成"