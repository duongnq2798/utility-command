#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
LIGHT_GREEN='\033[0;92m'
ORANGE='\033[0;33m'
NC='\033[0m'

line_number=0

echo "Enter keys, one key per line. Press enter on an empty line to finish:"
keys=()
while true; do
  read -p "Enter key: " key
  if [ -z "$key" ]; then
    break
  fi
  keys+=("$key")
done

while IFS= read -r question; do
  line_number=$((line_number + 1))
  
  echo -e "${LIGHT_GREEN}Starting to read line $line_number${NC}"
  
  echo -e "${ORANGE}Question: $question${NC}"
  
  for key in "${keys[@]}"; do
    (
      echo -e "${LIGHT_GREEN}Using key: $key${NC}"
      
      response=$(curl -s -X POST https://$key.us.gaianet.network/v1/chat/completions \
        -H 'accept: application/json' \
        -H 'Content-Type: application/json' \
        -d "{\"messages\":[{\"role\":\"system\", \"content\": \"You are a helpful assistant.\"}, {\"role\":\"user\", \"content\": \"$question\"}]}")
      
      echo -e "${GREEN}Response for key $key:${NC}"
      echo "$response"
      echo ""
    ) &
  done

  wait

  echo -e "${YELLOW}Finished reading line $line_number${NC}"
  echo "-----------------------------------"
done < "data-ai-3000.txt"

echo -e "${RED}All lines have been processed.${NC}"
