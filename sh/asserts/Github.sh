#!/bin/bash

owner=onetech17
repo=TyporaPicture
path=version-1.0
if [[ "yes" = "$1" ]]; then
  path="test"
fi
path=$path/$(date +%Y/%m/%d)
message='"message" : "Github shell upload pic. Time='$(date)\"
committer='"committer" : {"name" : "Github.sh", "email" : "Typora@github.com"}'
content=$( base64 -w 0 "$2")

res=$(echo \{"$message", "$committer"', "content" : "'$content'"}' \  |
  curl \
    -o /dev/null -k -s -w %{http_code} \
    -X PUT \
    -H "Authorization: $4" \
    -H "Accept: application/vnd.github+json" \
    https://api.github.com/repos/$owner/$repo/contents/"$path"/"$3" \
    -d @-)
if [ 201 -eq "$res" ]; then
  echo https://raw.githubusercontent.com/$owner/$repo/main/"$path"/"$3"
else
  echo "status code $res, file is $3. Github upload failure"
fi
