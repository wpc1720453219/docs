# Linux相关

## 链接

### 外链
1. sed
    1. [Sed正则表达式](https://www.yiibai.com/sed/sed_regular_expressions.html)
        - 和普通的正则不太一样
1. gcc
    1. [gcc编译时对’xxxx’未定义的引用问题](https://www.cnblogs.com/oloroso/p/4688426.html)
1. man page
    1. [ManKier Linux man pages](https://www.mankier.com/)

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

## Linux桌面
一些好用的Linux桌面。
1. [Pop!_OS 20.04](https://zhuanlan.zhihu.com/p/137831893) 
   
    > 基于ubuntu美化
1. [windows wsl](https://docs.microsoft.com/zh-cn/windows/wsl)
   
    > windows桌面+linux命令行，并且idea、vscode都对这个做了部分支持

[xrdp完美实现Windows远程访问Ubuntu 16.04](https://www.cnblogs.com/xuliangxing/p/7560723.html)

[如何在Ubuntu 20.04 上安装 Xrdp 服务器（远程桌面） ](https://yq.aliyun.com/articles/762186?type=2)

## FAQ

### CentOS 7
[CentOS7 使用光盘镜像作为yum源](https://blog.csdn.net/ross1206/article/details/81333907)

[Centos 7 镜像下载](http://isoredirect.centos.org/centos/7/isos/x86_64/)


### CentOS 6
> [VMware安装CentOS 6.9时出现：The centos disc was not found in any of your drives.Please insert the centos disc and press OK to retry](https://www.cnblogs.com/EasonJim/p/7198450.html)

> [CentOS Linux解决Device eth0 does not seem to be present](https://www.linuxidc.com/Linux/2012-12/76248.htm)

> [如何修改CentOS系统的主机名称](https://blog.51cto.com/14463906/2424146)

### RedHat RHEL 6
> [RedHat配置光盘源](https://blog.csdn.net/LiangZiBoy/article/details/50704772)

> [Linux - 设置光盘，开机自动挂载](https://www.cnblogs.com/jiqing9006/p/8183753.html)

> [sudo：抱歉，您必须拥有一个终端来执行 sudo 解决](https://www.cnblogs.com/shengulong/p/6551363.html)
```bash
sudo sed -i 's/Defaults *requiretty/#Defaults requiretty/g' /etc/sudoers
sudo cat /etc/sudoers | grep requiretty
```

[error: "net.bridge.bridge-nf-call-ip6tables" is an unknown key 解决](https://www.cnblogs.com/wallis0922/archive/2013/05/23/3094062.html)

关防火墙：
sudo service iptables stop
sudo chkconfig iptables off

### RedHat RHEL 7
[Linux RedHat 7 配置本地 YUM源](https://www.cnblogs.com/chling/p/11495739.html)

[CentOS 7开机出现welcome to emergency mode! 解决方法](https://www.cnblogs.com/rb258/p/9370137.html)

### suse 12
[suse 12、15下载地址](https://www.suse.com/products/server/download/)

[suse12安装详解](https://www.cnblogs.com/yaohong/p/7460557.html)

suse 12用vmware装好之后，会自动添加一个指向光盘的源，不需要再手动添加。
[suse zypper源配置](https://blog.csdn.net/lk_db/article/details/78417811)
```bash
# zypper的帮助，还是比较详细的
zypper --help
# 列出可用包，可以看源是否成功应用
zypper pa

zypper -n install pcre
```

[在SUSE Linux环境下，如何处理启动NTP服务时提示"NTP key id not defined"的错误？](https://support.huawei.com/enterprise/zh/doc/EDOC1100011869/c898eaf7)
suse12下ntp key文件位置与centos不一样，在`/etc/ntp.keys`


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

