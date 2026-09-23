#!/usr/bin/env bash

GATEWAY_URL=''
AWS_REGION=$(aws configure get region)
SIGV4_USER=$(aws configure get aws_access_key_id):$(aws configure get aws_secret_access_key)

function call(){
    TARGET_URL=${GATEWAY_URL}/$1/invocations

    curl -X POST "$TARGET_URL" \
        --silent \
        --aws-sigv4 "aws:amz:${AWS_REGION}:bedrock-agentcore" \
        --user "${SIGV4_USER}" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json, text/event-stream" \
        -d "$2"
}

call GatewayMcpRuntimeTarget \
    '{
        "jsonrpc":"2.0",
        "id":2,
        "method":"tools/list"
    }' \
    | sed -n 's/^data: //p' | jq

call GatewayMcpRuntimeTarget \
    '{
        "jsonrpc":"2.0",
        "id":2,
        "method":"tools/call",
        "params": {
            "name":"add_numbers",
            "arguments":{
                "a":3,
                "b":4
            }
        }
    }' \
    | sed -n 's/^data: //p' | jq

call GatewayA2aRuntimeTarget \
    '{
        "jsonrpc":"2.0",
        "id":1,
        "method":"message/send",
        "params": {
            "message": {
                "role": "user",
                "parts": [
                    {
                        "kind": "text",
                        "text":"what is 101 * 11?"
                    }
                ],
                "messageId":"111111-11111-111-1111"
            }
        }
    }' \
    | jq
