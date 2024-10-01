#!/bin/bash

# Load options from the config.yaml file
CONFIG_PATH=/data/options.json
CF_API_TOKEN=$(jq --raw-output '.cf_api_token' $CONFIG_PATH)
ZONE_ID=$(jq --raw-output '.zone_id' $CONFIG_PATH)
RECORD_NAME=$(jq --raw-output '.record_name' $CONFIG_PATH)
UPDATE_INTERVAL=$(jq --raw-output '.update_interval' $CONFIG_PATH)

# Function to get the current public IP
get_public_ip() {
  curl -s https://api.ipify.org
}

# Function to update the Cloudflare DNS record
update_dns_record() {
  local current_ip="$1"

  record_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${RECORD_NAME}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')

  update_response=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${record_id}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"${RECORD_NAME}\",\"content\":\"${current_ip}\",\"ttl\":120,\"proxied\":false}")

  if [[ $(echo "$update_response" | jq -r '.success') == "true" ]]; then
    echo "DNS record updated successfully."
  else
    echo "Failed to update DNS record: $(echo "$update_response" | jq -r '.errors')"
  fi
}

# Infinite loop to check and update IP if changed
while true; do
  public_ip=$(get_public_ip)
  
  # Get current IP from Cloudflare
  cloudflare_ip=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${RECORD_NAME}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" | jq -r '.result[0].content')

  if [[ "$public_ip" != "$cloudflare_ip" ]]; then
    echo "IP has changed. Updating DNS record..."
    update_dns_record "$public_ip"
  else
    echo "IP has not changed. No update needed."
  fi

  # Wait for the configured interval before next check
  sleep "$UPDATE_INTERVAL"
done
