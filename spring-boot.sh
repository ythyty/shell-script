#!/bin/bash

START () {
    PIDS=`ps -ef | grep java | grep ${PROJECT} | grep -v grep | awk '{print $2}'`
    if [ -n "${PIDS}" ];then
        echo "${PROJECT} is running!"
    else
        echo "Starting the ${PROJECT} ..."
        echo "JAVA_MEM_OPTS: ${JAVA_MEM_OPTS}"
        echo "LOG_DIR: ${LOG_DIR}"

        cd ${JARFILE%/*}
        rm -rf ${LOG_DIR}/stdout.log
        source /etc/profile
        BUILD_ID=dontKillMe nohup java -jar -server ${JARFILE##*/} --spring.profiles.active=${SPRING_PROFILES_ACTIVE} ${JAVA_MEM_OPTS} > ${LOG_DIR}/stdout.log 2>&1 &

        sleep 15

        PIDA=`ps -ef | grep java | grep ${PROJECT} | grep -v grep | awk '{print $2}'`

        if [ -z "${PIDA}" ];then
            echo "${PROJECT} start err!"
        fi
    fi
}

STOP () {
    PIDS=`ps -ef | grep java | grep ${PROJECT} | grep -v grep | awk '{print $2}'`
    if [ -z "${PIDS}" ];then
        echo "ERROR: The ${PROJECT} does not started!"
    else
        echo "Stopping the ${PROJECT} ..."

        for PID in ${PIDS};do
            kill ${PID} > /dev/null 2>&1
        done

        sleep 3

        PIDSA=`ps -ef | grep java | grep ${PROJECT} | grep -v grep | awk '{print $2}'`
        if [ -n "${PIDSA}" ];then
            for PID in ${PIDSA} ; do
                kill -9 ${PID} > /dev/null 2>&1
            done
        fi
    fi
}

STATUS () {
    PIDS=`ps -ef | grep java | grep "${PROJECT}" | grep -v grep | awk '{print $2}'`
      if [ -z "${PIDS}" ]; then
         echo "${PROJECT} does not started!"
      else
         echo "${PROJECT} is running!"
      fi
}


case "$1" in
    start|START)
    START
    ;;
    stop|STOP)
    STOP
    ;;
    restart|RESTART)
    STOP
    sleep 5
    START
    ;;
    status|STATUS)
    STATUS
    ;;
    *)
    echo 'Please input start|stop|status|restart'
    ;;
esac
