#!/bin/bash

# github上的私人令牌
token=
# 注册仓库后仓库地址中的用户名
owner=
# 注册仓库后仓库地址中的仓库名
repo=
# 生成日期格式的文件目录和16位的随机字符串文件名
path=test/$(date +%Y-%m-%d)/`openssl rand -hex 16`.jpg
# 提交文件的消息
message='"message":"picture_bed git Time:'$(date +%Y-%m-%d)" "$(date +%H:%M:%S)'"'
# 主要是为了方便日后明白
committer='"committer":{"name":"Custom Commands","email":"wan174376/'$repo'@github.com"}'

echo '{'$message,$committer',"content":"'$token'"}'
echo https://api.github.com/repos/$owner/$repo/contents/$path



#echo $(echo $result | sed 's/},/\n/g' | grep "content"| sed 's/:/\n/g' | sed '3d')

#content=$(echo $result | sed 's/,/\n/g' | grep "bizDesc" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g'| sed 's/"//g')

# sed 's/旧字符串/新字符串/g' 文件名
#echo $(echo $result | sed 's/,/\n/g')

