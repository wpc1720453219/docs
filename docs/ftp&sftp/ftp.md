## ftp
FTP，即：文件传输协议（File Transfer Protocol），  
基于客户端/服务器模式，默认使用20、21端口号，其中端口20（数据端口）用于进行数据传输，端口21（命令端口）用于接受客户端发出的相关FTP命令与参数。  
FTP服务器普遍部署于局域网中，具有容易搭建、方便管理的特点。而且有些FTP客户端工具还可以支持文件的多点下载以及断点续传技术，因此FTP服务得到了广大用户的青睐。
### FTP协议有以下两种工作模式:
* 主动模式（PORT）：FTP服务器主动向客户端发起连接请求。  
* 被动模式（PASV）：FTP服务器等待客户端发起连接请求（FTP的默认工作模式）。 

vsftpd是一款运行在Linux操作系统上的FTP服务程序，具有很高的安全性和传输速度。
### vsftpd有以下三种认证模式：  
* 匿名开放模式：是一种最不安全的认证模式，任何人都可以无需密码验证而直接登陆。  
* 本地用户模式：是通过Linux系统本地的账户密码信息进行认证的模式，相较于匿名开放模式更安全，而且配置起来简单。  
* 虚拟用户模式：是这三种模式中最安全的一种认证模式，它需要为FTP服务单独建立用户数据库文件，虚拟出用来进行口令验证的账户信息，而这些账户信息在服务器系统中实际上是不存在的，仅供FTP服务程序进行认证使用。  
虚拟用户比本地用户更安全
使用rpm 二进制安装：  
具体可看：[Centos 7使用vsftpd搭建FTP服务器](https://blog.51cto.com/andyxu/2168875)
  
使用编译安装：  
因为编译安装无法改变配置地址 需与环境打交道   
[make&& make install的意思](https://blog.csdn.net/ainivip/article/details/109225062)  

  

非容器部署：  
部署流程可看avatar-cd或者sftp.sh文件  

容器部署：  
[stilliard/pure-ftpd - Docker Image | Docker Hub](https://hub.docker.com/r/stilliard/pure-ftpd)
```shell
docker pull stilliard/pure-ftpd:latest

docker rm -f ftpd_server
docker run -d --name ftpd_server \
    -p 21:21 \
    -p 30000-30099:30000-30099 \
    -e FTP_USER_NAME=luna \
    -e FTP_USER_PASS=luna \
    -e FTP_USER_HOME=/home/luna \
    -e FTP_MAX_CLIENTS=50 \
    -e FTP_MAX_CONNECTIONS=50 \
    -e FTP_PASSIVE_PORTS=30000:30099 \
    -e "PUBLICHOST=10.60.44.54" \
    -v /data/vsftpd/data:/home \
    -e TZ=Asia/Shanghai \
    --restart=always \
    stilliard/pure-ftpd:latest
docker logs -f ftpd_server
```


```shell
docker rm -f essen-stastic-server
docker run --name essen-stastic-server \
    -v /data/vsftpd/data/luna/essen:/usr/share/nginx/html:ro \
    -p 18186:80 \
    -e TZ=Asia/Shanghai \
    --restart=always \
    -d \
    nginx:1.14-alpine
docker logs -f essen-stastic-server
```














