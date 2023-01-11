#!/bin/bash

# 生成日期格式的文件目录和16位的随机字符串文件名
path=smms.app/$(date +%Y/%m/%d)
# 提交文件的消息
message='"message":"smms shell upload pic. Time='$(date +%Y-%m-%d)" "$(date +%H:%M:%S)'"'
# 主要是为了方便日后明白
committer='"committer":{"name":"smms.sh","email":"Typora@github.com"}'
function upload(){
  # github上的私人令牌
  token="Bearer "
  # 注册仓库后仓库地址中的用户名
  owner=
  # 注册仓库后仓库地址中的仓库名
  repo=
  # 生成随机字符串的方法
  filename=$2

  # base64 太长时会报错参数列表太长，这里使用 使用 @- 从标准输入中获取数据。
  # 利用echo输出到标准输入，再利用管道重定向输入到curl的-d参数中。
  res=`echo '{'$message,$committer',"content":"'$1'"}' \ |
    curl \
    -o /dev/null -s -w %{http_code} \
    -X PUT \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: $token" \
    https://api.github.com/repos/$owner/$repo/contents/$path/$filename \
    -d @-`
  if [ 201 -ne "$res" ]; then
    echo "github fail upload"
  else
    echo "success"
  fi
}

# onetech token
token=""
function smms() {
  res=`curl --location -g -s --request POST https://smms.app/api/v2/upload \
  --header "Authorization: $token" \
  --form "smfile=@$1"`

  smmsUrl=$(echo $res | sed 's/"/\n/g' | grep "s2.loli.net" | sed 's/\\//g')
  code=$(echo $res | sed 's/,/\n/g' | grep "code" | sed 's/"//g' | sed 's/:/\n/g' | sed '1d')
  if [[ "success" = $code ]]; then
    echo $smmsUrl
    fileName=$(echo $smmsUrl | sed 's/\//\n/g' | sed -n '$p')
    result=$( upload $( base64 -w 0 $1) $fileName)
    if [[ "success" = $result ]]; then
      rm $1
    fi
  else
    echo "smms fail upload"
  fi
}

for var in "$@"
do
  smms $var
done
