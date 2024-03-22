#! /bin/bash

ARCH=${1}
VERSION=${2}

TMP_DIR=/data/local/tmp/

adb push frp/bin/upx/${ARCH}_frpc ${TMP_DIR}
RESULT=`adb shell ${TMP_DIR}${ARCH}_frpc -v | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//'`
if [[ ${RESULT} != ${VERSION} ]]; then
    echo "${RESULT}"
    echo "${ARCH}_frpc test failed"
fi
adb push frp/bin/upx/${ARCH}_frps ${TMP_DIR}
RESULT=`adb shell ${TMP_DIR}${ARCH}_frps -v | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//'`
if [[ ${RESULT} != ${VERSION} ]]; then
    echo "${RESULT}"
    echo "${ARCH}_frps test failed"
fi

echo "success"
