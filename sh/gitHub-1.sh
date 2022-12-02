#!/bin/bash

# github上的私人令牌
token=
# 提交文件的消息
msg="commit pic Time:$(date +%Y-%m-%d) $(date +%H:%M:%S)"
# 注册仓库后仓库地址中的用户名
owner=
# 注册仓库后仓库地址中的仓库名
repo_name=

declare -a result=()

# 生成随机字符串的方法
function rand(){
    filename= openssl rand -hex 16
    echo $filename
}

function upload(){
    res=""
    # 生成日期格式的文件夹和16位的随机字符串
    filepath=test/$(date +%Y-%m-%d)/$(rand).jpeg
    # base64 太长时会报错参数列表太长，这里使用 使用 @- 从标准输入中获取数据。利用echo输出到标准输入，再利用管道重定向输入到curl的-d参数中。
    res=`echo '{"access_token":"'$token'","message":"'$msg'","content":"'$1'"}' \ |
    curl -o /dev/null -s -w %{http_code} -X POST -H 'Content-type':'application/json' -d @- https://gitee.com/api/v5/repos/$owner/$repo_name/contents/$filepath`
    # 判断返回状态码是否为201 是返回地址，不是提示上传失败
    if [ 201 -eq "$res" ];then
    result+=(https://gitee.com/$owner/$repo_name/raw/master/$filepath)
    else
    echo "上传失败！"
    fi
}
for var in "$@"
do
   # 读取上传图片转为base64
   in=$( base64 -w 0 $var)
   upload "$in"
done
for res in "${result[@]}"
do
    echo "$res"
done

curl \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: wan174376: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" \
  https://api.github.com/repos/OWNER/REPO/contents/PATH \
  -d '{"message":"my commit message","committer":{"name":"xinyuxinyuan","email":"octocat@github.com"},"content":"bXkgbmV3IGZpbGUgY29udGVudHM="}'