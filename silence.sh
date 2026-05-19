#!/bin/bash

ILO_HOST="127.0.0.1"
ILO_USER="Administrator"
ILO_PASS="Password"
FAN_ADJUST=0

TOKEN=$(curl -sk -X POST "https://${ILO_HOST}/redfish/v1/SessionService/Sessions/" \
  -H 'content-type: application/json' \
  -d "{\"UserName\":\"${ILO_USER}\",\"Password\":\"${ILO_PASS}\"}" \
  -D - | grep -i x-auth-token | awk '{print $2}' | tr -d '\r')

[ -z "$TOKEN" ] && exit 1

curl -sk -X PATCH "https://${ILO_HOST}/redfish/v1/Chassis/1/Thermal/" \
  -H 'content-type: application/json' \
  -H "X-Auth-Token: $TOKEN" \
  --data "{\"Oem\": {\"Hpe\": {\"FanPercentAdjust\": ${FAN_ADJUST}}}}"
