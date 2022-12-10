#!/bin/bash

# github上的私人令牌
token="Bearer "
# 注册仓库后仓库地址中的用户名
owner=
# 注册仓库后仓库地址中的仓库名
repo=
# 生成日期格式的文件目录和16位的随机字符串文件名
path=version_1.0/$(date +%Y-%m-%d)
# 提交文件的消息
message='"message":""'
# 主要是为了方便日后明白
committer='"committer":{"name":"","email":""}'

function upload(){
  # 生成随机字符串的方法
  filename=`openssl rand -hex 16`.jpg
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
  # 判断返回状态码是否为201. 是:返回地址;不是:提示上传失败
  if [ 201 -eq "$res" ];then
    echo https://raw.githubusercontent.com/$owner/$repo/main/$path/$filename
  else
    echo "status code $res. upload failure"
  fi
}

for var in "$@"
do
  # 读取上传图片转为base64
  upload $( base64 -w 0 $var)
done
