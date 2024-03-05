## dns
### DNS 是什么？
DNS （Domain Name System 的缩写）的作用非常简单，就是根据域名查出IP地址。你可以把它想象成一本巨大的电话本。    
举例来说，如果你要访问域名math.stackexchange.com，首先要通过DNS查出它的IP地址是151.101.129.69

[DNS域名解析过程](https://huaweicloud.csdn.net/635604a0d3efff3090b58b54.html)  
检查浏览器缓存-> 操作系统缓存(在内存里)--> 读取hosts文件-->本地dns服务器--> 根服务器-->1级域名服务器-->2级域名服务器-->3级域名服务器
![img_1.png](./images/img_21.png)
![img.png](./images/img66.png)

   
搭建内网dns服务器  
```shell
mkdir -p /data/dnsmasq/
# 初始化配置文件
cat > /data/dnsmasq/dnsmasq.conf <<EOF
#dnsmasq config, for a complete example, see:
#  http://oss.segetech.com/intra/srv/dnsmasq.conf
#log all dns queries
log-queries
#dont use hosts nameservers
no-resolv
#use cloudflare as default nameservers, prefer 1^4
# 公司内dns地址
server=192.168.0.54
# 国内dns
server=114.114.114.114
# 微软dns
server=4.2.2.2
strict-order
#serve all .company queries using a specific nameserver
server=/company/10.0.0.1
#explicitly define host-ip mappings
address=/myhost.company/10.0.0.2
 
# 一些自定义配置
address=/.pc.xyyweb.cn/192.168.10.104
 
EOF
 
cat /data/dnsmasq/dnsmasq.conf
 
# 启动dns服务
docker rm -f dnsmasq
docker run \
    -u root \
    --name dnsmasq \
    -d \
    -p 53:53/udp \
    -p 5380:8080\
    -v /data/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf \
    --log-opt "max-size=100m" \
    -e "HTTP_USER=admin" \
    -e "HTTP_PASS=1" \
    -e TZ=Asia/Shanghai \
    --restart always \
    jpillora/dnsmasq:1.1
docker logs -f dnsmasq
 
# 可以访问地址：http://192.168.10.104:5380/ 用户：admin/1
```

### win主机 配置创建好的dns服务器
修改自己电脑dns  
这里提供winddows11的修改方式，首选dns改成192.168.0.54  
![img_2.png](./images/img_32.png)
```shell
#验证
#windows启动cmd命令行
# 指定域名验证
nslookup pc.xyyweb.vm
ping pc.xyyweb.vm
# 通配域名验证
nslookup aaa.pc.xyyweb.vm
ping aaa.pc.xyyweb.vm
```

### linux主机 配置创建好的dns服务器
在 /etc/resolv.conf 里配置
[/etc/resolv.conf配置文件详解](https://blog.csdn.net/liujinwei2005/article/details/119922678)
[CentOS 7 下，如何设置DNS服务器](https://www.cnblogs.com/dadadechengzi/p/6670530.html)  
```shell
domain  51osos.com
search  www.51osos.com  51osos.com
nameserver 202.102.192.68
nameserver 202.102.192.69
```
domain: 这个用来指定本地的域名，在没有设置search的情况下，search默认为domain的值。这个值可以随便配，
        目前在我看来，domain除了当search的默认值外，没有其它用途。也就说一旦配置search，那domain就没用了
search：当访问的域名不能被DNS解析时，resolver会将该域名加上search指定的参数，重新请求DNS，
        直到被正确解析或试完search指定的列表为止




### nslookup 命令  
![img_7.png](./images/img_27.png)  
Server： 指的是192.168.0.54对应的主机名  
Address:  dns服务器ip  192.168.0.54#53
[nslookup](https://www.cnblogs.com/machangwei-8/p/10353137.html)

dnsmasq
- [jpillora/dnsmasq 一个docker镜像，介绍页有教程](https://hub.docker.com/r/jpillora/dnsmasq)
- [高效搭建基于dnsmasq通过webui管理的dns服务器](https://blog.csdn.net/firehadoop/article/details/83860191)
- 维护地址： [http://192.168.0.54:5380](http://192.168.0.54:5380/)
- 用户名：admin
- 密码：xyyweb@2

```shell
docker rm -f dnsmasq
docker run \
    -u root \
    --name dnsmasq \
    -d \
    -p 53:53/udp \
    -p 5380:8080\
    -v /data/dnsmasq/dnsmasq.conf:/etc/dnsmasq.conf \
    --log-opt "max-size=100m" \
    -e "HTTP_USER=admin" \
    -e "HTTP_PASS=xyyweb@2" \
    -e TZ=Asia/Shanghai \
    --restart always \
    jpillora/dnsmasq:1.1
docker logs -f dnsmasq
```



可以配置域名通配符

[如何使用dnsmasq配置静态通配符子域](https://qastack.cn/server/122631/how-to-configure-a-static-wildcard-subdomain-with-dnsmasq)

```shell
address=/.server.mydomain.com/192.168.0.3
```

/data/dnsmasq/dnsmasq.conf  配置文件备份，可以在页面修改。

```shell
#dnsmasq config, for a complete example, see:
#  http://oss.segetech.com/intra/srv/dnsmasq.conf
#log all dns queries
log-queries
#dont use hosts nameservers
no-resolv
#use cloudflare as default nameservers, prefer 1^4
server=114.114.114.114
server=4.2.2.2
strict-order
#serve all .company queries using a specific nameserver
#server=/company/10.0.0.1
#explicitly define host-ip mappings
#address=/myhost.company/10.0.0.2
 
address=/k8s-test/192.168.0.54
address=/kube-master-vip/192.168.0.219
address=/kube-master1/192.168.0.214
address=/kube-master2/192.168.0.216
address=/kube-box1/192.168.0.243
address=/kube-box2/192.168.0.251
address=/kube-box3/192.168.0.252
address=/hadoop3/192.168.0.54
address=/hadoop2/192.168.0.55
address=/rdc-test-57/192.168.0.57
address=/rdc-test-58/192.168.0.58
address=/rdc-test-59/192.168.0.59
address=/rdc-devops-14/192.168.0.14
address=/rdc-devops-15/192.168.0.15
address=/rdc-devops-16/192.168.0.16
address=/james.local/192.168.0.16
address=/mirrors.jenkins-ci.org/192.168.0.54
```





