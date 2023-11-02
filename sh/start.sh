#!/bin/bash

isCheck=yes
smms_token=
github_token="Bearer "

for var in "$@"; do
  path=/d/markdown
  smmsUrl=$(source "$path/assets/smms.sh" "$var" "$smms_token")
  if [[ "error" = "$smmsUrl" ]]; then
    echo "$(date) $var" >>"$path/assets/upload_history.log"
  else
    fileName=$(echo "$smmsUrl" | sed 's/\//\n/g' | sed -n '$p')
    source "$path/assets/Github.sh" "$isCheck" "$var" "$fileName" "$github_token" >/dev/null
    echo "$smmsUrl"
  fi
done
