## minio  
[minio 官网中文文档](https://docs.min.io/cn/)  
### 旧版本部署
```shell
## 老版本
mkdir -p /home/data/minio
chmod 777 /home/data/minio
docker rm -f minio-9000
docker run -d --name minio-9000 \
-p 9000:9000 \
-p 9001:9001 \
-v /home/data/minio/:/data \
-e "MINIO_ACCESS_KEY=avatar" \
-e "MINIO_SECRET_KEY=Fingard123" \
-e TZ=Asia/Shanghai \
--restart=always \
minio/minio server /data --console-address ":9001"

## 新版本
使用docker的话，需要添加--network=host，两个address一定要指定具体的ip、端口，并且必须是宿主机的ip端口

docker pull minio/minio:RELEASE.2022-10-24T18-35-07Z.hotfix.ce525fdaf
docker rm -f minio-8000
docker run -d --name minio-8000 \
  --network=host \
  -p 8000:8000 \
  -p 8305:8305 \
  -v /data/minio-8000/data:/data \
  -e "MINIO_ACCESS_KEY=tfp" \
  -e "MINIO_SECRET_KEY=*" \
  -e "MINIO_ROOT_USER=tfp" \
  -e "MINIO_ROOT_PASSWORD=*" \
  -e TZ=Asia/Shanghai \
  --restart=always \
  minio/minio:RELEASE.2022-10-24T18-35-07Z.hotfix.ce525fdaf \
  server /data --console-address "10.60.44.54:8305" --address "10.60.44.54:8000"
docker logs -f minio-8000

# ldap配置
# ldap配置完成之后不能登录，root号不能登ui，此时必须用root号登命令行，添加ldap用户到 consoleAdmin 策略，才能用这个ldap用户登录ui
# 并且ldap用户、组、策略不能在ui界面配置
cd /usr/local/bin/
curl --output mc http://10.60.52.141:3000/mc
chmod +x mc
mc config host add myminio http://10.60.44.54:8000 tfp fingard@2 --api S3v4
mc admin policy list myminio
mc admin policy set myminio consoleAdmin user="cn=sunht,ou=user,dc=fingard,dc=com"
mc admin policy set myminio consoleAdmin group="cn=HX,ou=group,dc=fingard,dc=com"
mc admin policy set myminio consoleAdmin group="cn=Fingard,ou=group,dc=fingard,dc=com"
mc admin policy set myminio consoleAdmin group="cn=Fingard,ou=crowd,ou=group,dc=fingard,dc=com"

# openid配置，对接keycloak
mc admin config set myminio identity_openid \
   config_url="http://keycloak.main-data-prod.avatar.fingard.cn/auth/realms/MainData/.well-known/openid-configuration" \
   client_id="minio" \
   client_secret="g4O5gjRm7IoU4nOhAp9of4yeboVMyDQw" \
   claim_name="policies" \
   claim_prefix="" \
   role_policy="" \
   scopes="openid email profile" \
   redirect_uri="http://minio.avatar.fingard.cn/oauth_callback" \
   comment="Keycloak"
mc admin service restart myminio 
 
# 直接手动改配置文件
cd /data/minio-8000/data/.minio.sys/config
cat config.json  | jq .identity_openid
```

### minio api  
基于okhttp  
[适用于与Amazon S3兼容的云存储的MinIO Java SDK](https://docs.min.io/cn/java-client-quickstart-guide.html)  
[minio](https://github.com/minio)/[minio-java](https://github.com/minio/minio-java)  
[GitHub - jlefebure/spring-boot-starter-minio: Minio starter for Spring Boot](https://github.com/jlefebure/spring-boot-starter-minio)  

### 新版minio案例
```shell
mkdir -p /data/avatar-dev-minio/data
chmod 777 /data/avatar-dev-minio/data
  
docker pull minio/minio:RELEASE.2022-05-04T07-45-27Z
docker rm -f avatar-dev-minio
docker run -d --name avatar-dev-minio \
  --network=host \
  -p 8303:8303 \
  -p 8304:8304 \
  -v /data/avatar-dev-minio/data:/data \
  -e "MINIO_ACCESS_KEY=avatar" \
  -e "MINIO_SECRET_KEY=fingard1" \
  -e TZ=Asia/Shanghai \
  --restart=always \
  minio/minio:RELEASE.2022-05-04T07-45-27Z \
  server /data --console-address ":8304" --address "10.60.44.15:8303"
docker logs -f avatar-dev-minio
```

### 新版minio共享链接
![alt 属性文本](.\img\image2022-5-18_9-53-8.png)
设置成public或者readonly，直接拼接这样的地址也能正常下载  
<http://10.60.44.15:8303/asiatrip/MinioDemo.kt>  
匿名访问的ui界面不行了，curl、直接访问public、readonly文件路径还是可以的  

### docker版Minio接入LDAP
[docker版Minio接入LDAP-阿里云开发者社区 (aliyun.com)](https://developer.aliyun.com/article/830326)  
**简介：** 因为官网的LDAP文档接入写的过于分散，实在不利于新手部署，所以重新整理了一版，方便用户能一次部署完成  
 
docker 运行一个minio 服务端  
1.首先我们使用docker运行一个新版本的minio。主要是设置minio的root用户名密码(以前叫AccessKey和secrestKey)，LDAP服务端信息  
2.注意下面运行命令中${}的替换成你自己的LDAP服务信息
```
docker run --rm -p 7000:9000 -p 7001:7001 --name minio1 \
  -e "MINIO_ROOT_USER=minio" \
  -e "MINIO_ROOT_PASSWORD=minio123" \
  -e "MINIO_IDENTITY_LDAP_TLS_SKIP_VERIFY=on" \
  -e "MINIO_IDENTITY_LDAP_SERVER_INSECURE=on" \
  -e "MINIO_IDENTITY_LDAP_STS_EXPIRY=24h" \
  -e "MINIO_IDENTITY_LDAP_SERVER_ADDR=${LDAP域名}" \
  -e "MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN=${LDAP只读账户}" \
  -e "MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD=${LDAP只读账户的密码}" \
  -e "MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN=${LDAP用户搜索域}" \
  -e "MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER=(&(objectClass=inetOrgPerson)(uid=%s))" \
  -e "MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN=${LDAP组搜索域}" \
  -e "MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER=(&(objectclass=groupOfUniqueNames)(uniquemember=%d))" \
  minio/minio:RELEASE.2021-11-24T23-19-33Z server /data --console-address ":7001"
```

docker 运行一个minio 客户端，添加第一个用户  
1.运行minio客户端，并进入容器内
```
docker run -it --entrypoint=/bin/sh minio/mc
```  
2.设置客户端到服务端的连接信息
```
mc config host add minio http://${服务器IP}:7000 minio minio123 --api S3v4
```
3.检查minio服务端的权限列表
```
mc config host add minio http://${服务器IP}:7000 minio minio123 --api S3v4
```
4.设置用户权限或者组权限
```
mc admin policy set minio consoleAdmin user=cn=李镇伟,ou=XXX,ou=XXX,ou=XXX,dc=XXX
mc admin policy set minio consoleAdmin group=cn=南京测试部,dc=XXX
```
打开浏览器，使用ldap账户登录  
这里我设置的是超管用户，所以可以看到所有的功能

### minio可作为天然的静态页面容器  
![alt 属性文本](.\img\Snipaste_2022-09-05_11-08-15.png) 

### minio跨主机备份
confluence备份文件的跨主机备份，也可作为通用备份方案。
参考链接：  
[使用MinIO Client客户端实时数据同步备份文件](https://www.moewah.com/archives/2886.html)  
<https://hub.docker.com/r/minio/mc>  

官方文档：[mirror命令 - 存储桶镜像](https://docs.min.io/cn/minio-client-complete-guide.html#mirror)

minio客户端进程由docker管理，挂掉自动重启、开机自启。

```shell 
docker pull minio/mc
 
cat << EOF > /data/minio-confluence-bak/shell.sh
set -ex
mc config host add hadoop3 http://10.60.44.54:8000/ tfp 【密码】 --api S3v4
mc mirror -w /bak hadoop3/confluence-bak
EOF
 
docker run --restart=always  -d \
  --name minio-confluence-bak \
  -e "TZ=Asia/Shanghai" \
  -v /data/confluence/home/backups:/bak \
  -v /data/minio-confluence-bak/shell.sh:/shell.sh \
  --entrypoint "" \
  minio/mc /bin/sh /shell.sh
docker logs -f minio-confluence-bak
```

