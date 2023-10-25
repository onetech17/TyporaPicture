#!/bin/bash

# github上的私人令牌
token="Bearer "
# 注册仓库后仓库地址中的用户名
owner=
# 注册仓库后仓库地址中的仓库名
repo=
# 生成日期格式的文件目录
path=test/$(date +%Y/%m/%d)
# 提交文件的消息
message='"message":"Github shell upload pic. Time='$(date +%Y-%m-%d)" "$(date +%H:%M:%S)'"'
# 备注调用脚本
committer='"committer":{"name":"Github.sh","email":"Typora@github.com"}'

function upload() {
  filename=$2
  # base64 太长时会报错参数列表太长，这里使用 @- 从标准输入中获取数据。利用echo输出到标准输入，再利用管道重定向输入到curl的-d参数中。
  res=$(echo '{'$message,$committer',"content":"'$1'"}' \  |
    curl \
      -o /dev/null -s -w %{http_code} \
      -X PUT \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: $token" \
      https://api.github.com/repos/$owner/$repo/contents/$path/$filename \
      -d @-)
  if [ 201 -eq "$res" ]; then
    echo https://raw.githubusercontent.com/$owner/$repo/main/$path/$filename
    #    echo https://cdn.jsdelivr.net/gh/$owner/$repo@main/$path/$filename
    #    echo 'D:\File\markdown\TyporaPicture\'$(echo $path/$filename | sed 's/\//\\/g')
  else
    echo "status code $res. Github upload failure"
  fi
}

for var in "$@"; do
  fileName=$(echo $var | sed 's/\\/\n/g' | sed 's/\//\n/g' | sed -n '$p')
  # 读取上传图片转为base64
  upload $( base64 -w 0 $var) $fileName
done
