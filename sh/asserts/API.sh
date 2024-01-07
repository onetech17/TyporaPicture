#!/bin/bash

# Gitee
res=$(echo '{"access_token":"","message":"","content":""}' \ |
    curl -o /dev/null -s -w %{http_code} -X POST \
    -H 'Content-type':'application/json' \
    -d @- https://gitee.com/api/v5/repos/$owner/$repo/contents/$filepath)

# imgurl
res=$(echo '{'$message,$committer',"content":"'$1'"}' \ |
curl -o /dev/null -s -w %{http_code}  -X PUT \
-H "Accept: application/vnd.github+json" \
-H "Authorization: $token" \
https://api.github.com/repos/$owner/$repo/contents/$path/$filename \
-d @-)

# upyun
curl https://v0.api.upyun.com/"$bucket"/"$remote_path" \
  -H "Authorization: Basic ""$auth" --upload-file "$i"

# 生成随机字符串的方法
function rand(){
  filename= openssl rand -hex 16
  echo $filename
}
