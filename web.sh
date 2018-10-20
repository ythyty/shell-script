#!/bin/bash

WORKSPACE=$1
BUILD_NUMBER=$2
export PROJECT=$3

DATE=$(date +%F)
BASE_DIR=/rwda/runtime
HOME_DIR=${BASE_DIR}/${PROJECT}

if [ ! -d ${HOME_DIR} ];then
 mkdir -p ${HOME_DIR}
fi

rsync -var --delete ${WORKSPACE}/ ${HOME_DIR}/

echo "发布完成"