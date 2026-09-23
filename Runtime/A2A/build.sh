#!/usr/bin/env bash

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

BUILD_DIR=${SOURCE_DIR}/build

rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
cp -r ${SOURCE_DIR}/runtime/* ${BUILD_DIR}

uv pip install \
    --python-platform aarch64-manylinux2014 \
    --python-version 3.14 \
    --target="${BUILD_DIR}" \
    --only-binary=:all: \
    -r "${SOURCE_DIR}/runtime/requirements.txt"


cd ${BUILD_DIR}
OUTPUT_FILE=agent_core_runtime-$(date +%Y%m%d%H%M%S).zip
zip -r ${OUTPUT_FILE} *

RUNTIME_CODE_S3_BUCKET=''
RUNTIME_CODE_S3_PREFIX=${OUTPUT_FILE}

aws s3 cp ${OUTPUT_FILE} s3://${RUNTIME_CODE_S3_BUCKET}/${RUNTIME_CODE_S3_PREFIX}
cd ${SOURCE_DIR}
