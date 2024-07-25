#!/bin/bash

input_file="redpill-question.txt"

# URL API & Header Authorization
api_url="https://api.red-pill.ai/v1/chat/completions"
authorization_header="Authorization: Bearer YOUR_API_KEY"


while IFS= read -r question; do
  # Payload JSON
  payload=$(cat <<EOF
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {
      "role": "user",
      "content": "$question"
    }
  ],
  "temperature": 1
}
EOF
  )
  
  curl "$api_url" \
    -H "Content-Type: application/json" \
    -H "$authorization_header" \
    -d "$payload"


  echo -e "\n"
done < "$input_file"