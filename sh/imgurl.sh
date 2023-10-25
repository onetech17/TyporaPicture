#!/bin/bash

function upload(){
  # github上的私人令牌
  token="Bearer "
  # 注册仓库后仓库地址中的用户名
  owner=onetech17
  # 注册仓库后仓库地址中的仓库名
  repo=TyporaPicture
  # 生成日期格式的文件目录和16位的随机字符串文件名
  path=version-imgurl/$(date +%Y-%m-%d)
  # 提交文件的消息
  message='"message":"Test Typora shell. Time='$(date +%Y-%m-%d)" "$(date +%H:%M:%S)'"'
  # 主要是为了方便日后明白
  committer='"committer":{"name":"Test","email":"Typora@github.com"}'
  # 生成随机字符串的方法
  filename=`openssl rand -hex 16`.png

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
}

function imgUrlUpload(){
  token="3f2ea36fbfae66ae384bfb5fdd496cb6"
  uid="2d9951f41d5bf540c81cf9c34fcc3b9b"
  res=`curl -c -L -s -X POST -F "file=@$1" -F "uid=$uid" -F "token=$token" https://www.imgurl.org/api/v2/upload`
  if [[ "" = $res ]]; then
    echo empty
  else
    url=$(echo $res | sed 's/"/\n/g' | grep "s3" | sed -n '1p' | sed 's/\\//g')
    echo $url
    cd /D/File/markdown/assets/log
    echo $res > $(echo $url | sed 's/\//\n/g' | sed -n '$p' | sed 's/.png//g').txt
    code=$(echo $res | sed 's/,/\n/g' | grep "code" | sed 's/:/\n/g' | sed '1d')
    if [ "200" == "$code" ]; then
      upload $( base64 -w 0 $1)
    fi
  fi
}

for var in "$@"
do
  imgUrlUpload $var
done
