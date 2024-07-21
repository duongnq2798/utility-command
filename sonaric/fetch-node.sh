#!/bin/bash

keys=("fast-capri-starfish" "glowing-smoke-urchin" "adventurous-storm-dolphin")


api_url="https://api.sonaric.xyz/telemetry/v1/nodes?query="


fetch_data() {
    local key=$1
    local url="${api_url}${key}"
    local response=$(curl -s "$url")
    
    echo "$response" | jq -r '
        .items[] |
        [
            .rank,
            .uptime,
            .points,
            .info.host_info.os,
            .info.cpu.cores,
            .info.cpu.threads,
            .info.cpu.model,
            .info.disk.total,
            if (.info.gpus | length > 0) then .info.gpus[0].name else "not have gpu" end
    ] | @csv' | while IFS=, read -r rank uptime points os cores threads model disk gpus; do
        
        rank=$(echo "$rank" | tr -d '"')
        uptime=$(echo "$uptime" | tr -d '"')
        points=$(echo "$points" | tr -d '"')
        os=$(echo "$os" | tr -d '"')
        cores=$(echo "$cores" | tr -d '"')
        threads=$(echo "$threads" | tr -d '"')
        model=$(echo "$model" | tr -d '"')
        disk=$(echo "$disk" | tr -d '"')
        gpus=$(echo "$gpus" | tr -d '"')
        
        
        echo "Rank: $rank, Uptime: $uptime, Points: $points, OS: $os, Cores: $cores, Threads: $threads, Model: $model, Disk: $disk, GPUs: $gpus"
    done
}


while true; do
    
    echo "Fetching data at $(date '+%Y-%m-%d %H:%M:%S')"
    
    
    for key in "${keys[@]}"; do
        fetch_data "$key"
    done
    
    sleep 60
done