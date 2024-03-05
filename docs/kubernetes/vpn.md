# 连接k8s内网vpn教程

由于项目向zookeeper等注册中心注册的ip是k8s虚拟内网ip，比如`10.244.x.x`，开发主机识别不了这个ip地址， 
连接不到通过注册中心注册的服务，所以采用vpn的方式将特定ip地址的解析映射进k8s内网。 

## ~~旧版l2tp教程~~
[文档链接](./old/vpn.md)

使用步骤过于复杂，不再推荐，服务端挂掉不再维护！

## openvpn

1. [openvpn key 文件（右键另存为）](./client.ovpn)
2. [openvpn windows 客户端下载，里面的`openvpn-install-2.4.8-I602-WinXXX.exe`](http://10.60.44.54:8000/minio/public/kubernetes/openvpn/)
    - [其他操作系统客户端到官网下载](https://openvpn.net/community-downloads/)

### 使用说明
1. 下载客户端、key文件，
1. 一路下一步安装好客户端，
1. 启动后，右键任务栏托盘区小图标，导入配置，选中那个key文件，
1. 右键连接。
    - [一个验证地址：kibana](http://kibana-efk.default.svc.cluster.local:5601/)


## faq
### 使用不了其他网络
使用openvpn，访问不了百度之类的网站。

解决：
客户端配置注释掉这样的一行
```
# block-outside-dns
```
## 同时连两个openvpn
已管理员身份执行以下文件：
```
C:\Program Files\TAP-Windows\bin\addtap.bat
```
效果是添加一块虚拟网卡。
执行之后就可以同时连两个openvpn，多个应该同理。
