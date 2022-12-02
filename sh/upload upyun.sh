 #!/bin/bash

 # 各类配置信息
 # 云存储服务的名称
 bucket=""
 # 上传默认的路径
 remote_path=""
 # 操作员名和操作员密码按照operator:password拼接Base64编码
 auth=""
 # 对象存储绑定的域名
 base_url=""

 # 上传图片
 for i in "$@"; do
     curl https://v0.api.upyun.com/"$bucket"/"$remote_path" -H "Authorization: Basic ""$auth" --upload-file "$i"
 done

 # 输出结果
 echo "Upload Success:"
 for file in "$@"; do
     IFS='/' read -r -a array <<< "$file"
     id="${#array[@]}"
     echo "$base_url""$remote_path""${array[$id-1]}"
 done