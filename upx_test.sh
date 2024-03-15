#! /bin/bash

ARCH=${1}
VERSION=${2}

TMP_DIR=/data/local/tmp/

adb push frp/bin/upx/${ARCH}_frpc ${TMP_DIR}
RESULT=`adb shell ${TMP_DIR}${ARCH}_frpc -v`
if [[ ${RESULT} != ${VERSION} ]]; then
    echo "${RESULT}"
    echo "${ARCH}_frpc test failed"
    exit 1
fi
adb push frp/bin/upx/${ARCH}_frps ${TMP_DIR}
RESULT=`adb shell ${TMP_DIR}${ARCH}_frps -v`
if [[ ${RESULT} != ${VERSION} ]]; then
    echo "${RESULT}"
    echo "${ARCH}_frps test failed"
    exit 1
fi

echo "success"