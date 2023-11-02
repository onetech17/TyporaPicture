#!/bin/bash

res=$(curl -s -k -X POST https://smms.app/api/v2/upload \
  -H "Content-Type: multipart/form-data" \
  -H "Authorization: $1" \
  --trace-ascii /d/markdown/assets/serverInfo.log \
  -F "smfile=@$2")

code=$(echo "$res" | sed 's/,/\n/g' | grep "code" | sed 's/"//g' | sed 's/:/\n/g' | sed '1d')

if [[ "success" = $code ]]; then
  smmsUrl=$(echo $res | sed 's/"/\n/g' | grep "s2.loli.net" | sed 's/\\//g')
  echo "$smmsUrl"
else
  echo error
fi
