# Linux相关

#### 批量杀进程
传入一批进程中间包含的唯一字符串即可，一般是严格匹配的文件夹路径

```bash
function stop_process() {
  if [ -z $2 ]; then
    kill_arg=''
    cmd_contain=$1
  else
    kill_arg=$1
    cmd_contain=$2
  fi
  appid=$(ps -ef |grep "$cmd_contain" |grep -v grep | awk '{print $2}')
  echo appid=$appid
  if [ -n "$appid" ];
  then
    echo stopping $kill_arg $cmd_contain
    kill $kill_arg $appid
  fi
}
```

### 判断文件是否存在的shell脚本代码
[判断文件是否存在的shell脚本代码](https://www.jb51.net/article/34330.htm)

### 将top命令的输出，写入到文件中
https://blog.csdn.net/ice_beauty1/article/details/82919944

top -b -n 1 -d 3 >>file.txt



### [Linux查看物理CPU个数、核数、逻辑CPU个数](https://www.cnblogs.com/emanlee/p/3587571.html)

```bash
# 总核数 = 物理CPU个数 X 每颗物理CPU的核数 
# 总逻辑CPU数 = 物理CPU个数 X 每颗物理CPU的核数 X 超线程数

# 查看物理CPU个数
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l

# 查看每个物理CPU中core的个数(即核数)
cat /proc/cpuinfo| grep "cpu cores"| uniq

# 查看逻辑CPU的个数
cat /proc/cpuinfo| grep "processor"| wc -l
```

### 简单dns服务器dnsmasq
- [jpillora/dnsmasq 一个docker镜像，介绍页有教程](https://hub.docker.com/r/jpillora/dnsmasq)
- [高效搭建基于dnsmasq通过webui管理的dns服务器](https://blog.csdn.net/firehadoop/article/details/83860191)

### centos 7 配置dns
[CentOS 7 下，如何设置DNS服务器](https://www.cnblogs.com/dadadechengzi/p/6670530.html)

[linux中nmcli命令使用及网络配置](https://www.cnblogs.com/djlsunshine/p/9733182.html)


```bash
nmcli connection show
export net_if=em1
# 显示网卡详情
#nmcli connection show $net_if
# 设置网卡的dns
nmcli connection modify $net_if ipv4.dns 10.60.44.251
# 更新网络，需要重启kube-router
nmcli connection up $net_if
# 局域网主机
ping -c 2 rdc-devops-14
# 公网ip
ping -c 2 www.baidu.com
# k8s内网ip
ping -c 2 10.96.0.10
```

