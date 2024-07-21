#!/bin/bash

URL="https://allora-api.testnet.allora.network/cosmos/base/tendermint/v1beta1/blocks/latest"

print_color() {
    local color_code=$1
    shift
    echo -e "\e[${color_code}m$@\e[0m"
}

execute_curl() {
    local topic=$1
    local height=$2
    
    echo "Calling topic $topic..."
    
    response=$(curl -s --location 'http://localhost:6000/api/v1/functions/execute' \
        --header 'Content-Type: application/json' \
        --data '{
        "function_id": "bafybeigpiwl3o73zvvl6dxdqu7zqcub5mhg65jiky2xqb4rdhfmikswzqm",
        "method": "allora-inference-function.wasm",
        "parameters": null,
        "topic": "'"$topic"'",
        "config": {
            "env_vars": [
                {
                    "name": "ALLORA_BLOCK_HEIGHT_CURRENT",
                    "value": "'"$height"'"
                },
                {
                    "name": "BLS_REQUEST_PATH",
                    "value": "/api"
                },
                {
                    "name": "ALLORA_ARG_PARAMS",
                    "value": "ETH"
                }
            ],
            "number_of_nodes": -1,
            "timeout": 2
        }
    }')
    
    print_color "34" "Response from topic $topic: $response"
}

while true; do
    height=$(curl -s $URL | jq -r '.block.header.height')
    
    print_color "32" "Height: $height"
    
    # Array of specific topics to call
    topics=(1 2 3 7 10 11)
    
    for topic in "${topics[@]}"; do
        execute_curl $topic $height
        sleep 1
    done
    
    sleep 15
done
