#!/usr/bin/env bash

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

. build.sh

aws cloudformation deploy \
    --template-file template.yml \
    --stack-name AgentCore-Runtime-A2A \
    --parameter-overrides \
        RuntimeCodeS3Bucket=${RUNTIME_CODE_S3_BUCKET} \
        RuntimeCodeS3Prefix=${RUNTIME_CODE_S3_PREFIX} \
    --capabilities CAPABILITY_NAMED_IAM
