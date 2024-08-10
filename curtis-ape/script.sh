#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Checking and installing necessary packages...${NC}"
if ! command -v curl &> /dev/null; then
    echo -e "${GREEN}Installing curl...${NC}"
    sudo apt-get install -y curl
fi

if ! command -v bc &> /dev/null; then
    echo -e "${GREEN}Installing bc...${NC}"
    sudo apt-get install -y bc
fi

echo -e "${GREEN}Enter the URL of the RPC provider:${NC}"
read RPC_PROVIDER

echo -e "${GREEN}Enter the Explorer URL (e.g., https://binance.llamarpc.com):${NC}"
read EXPLORER_URL

echo -e "${GREEN}Enter the Chain ID:${NC}"
read CHAIN_ID

echo -e "${GREEN}Enter the number of repetitions:${NC}"
read REPEAT_TIMES

echo -e "${GREEN}Enter the interval between repetitions (in milliseconds):${NC}"
read INTERVAL

echo -e "${GREEN}Enter the path to the file containing private keys:${NC}"
read PRIVATE_KEY_FILE

echo -e "${GREEN}Enter the path to the file containing wallet addresses:${NC}"
read WALLET_ADDRESS_FILE

IFS=$'\r\n' GLOBIGNORE='*' command eval 'privateKeys=($(cat $PRIVATE_KEY_FILE | sed "s/\r//g" | sed "/^$/d"))'

IFS=$'\r\n' GLOBIGNORE='*' command eval 'walletAddresses=($(cat $WALLET_ADDRESS_FILE | sed "s/\r//g" | sed "/^$/d"))'

# Send ApeCoin from one wallet
sendApeCoin() {
    local senderPrivateKey=$1
    local recipient=${walletAddresses[$RANDOM % ${#walletAddresses[@]}]}
    local amount=$(printf "%.8f" $(echo "scale=8; $RANDOM/32768*0.00009 + 0.00001" | bc))

    echo -e "${GREEN}Sending from wallet: $(echo $senderPrivateKey | sed 's/\(.\{5\}\).*/\1**********/')${NC}"
    echo -e "${GREEN}To wallet: $recipient${NC}"
    echo -e "${GREEN}Amount: $amount ETH${NC}"

    local tx=$(cat <<EOF
{
  "jsonrpc": "2.0",
  "method": "eth_sendTransaction",
  "params": [{
    "from": "$(echo $senderPrivateKey | xxd -r -p | keccak-256sum | awk '{print "0x" substr($1,27)}')",
    "to": "$recipient",
    "value": "$(printf '%x\n' $(echo $amount*1000000000000000000 | bc | awk '{print int($1)}'))",
    "chainId": $CHAIN_ID
  }],
  "id": 1
}
EOF
)
    curl -X POST --data "$tx" -H "Content-Type: application/json" $RPC_PROVIDER
    echo -e "${GREEN}Transaction sent.${NC}"
}

main() {
    for ((i=0; i<$REPEAT_TIMES; i++)); do
        echo -e "${GREEN}Iteration $((i + 1))${NC}"
        for privateKey in "${privateKeys[@]}"; do
            sendApeCoin $privateKey
        done

        if [ $i -lt $((REPEAT_TIMES - 1)) ]; then
            sleep $(($INTERVAL / 1000))
        fi
    done

    echo -e "${GREEN}Finished repeating $REPEAT_TIMES times.${NC}"
}

main
