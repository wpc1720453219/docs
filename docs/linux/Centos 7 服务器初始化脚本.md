## 服务器初始化脚本
1. 设置主机名
2. 配置dns，服务器：http://192.168.0.54:5380
3. 禁用防火墙、selinux
4. 换ssh端口/密码
5. 改内核参数
6. 改iptables规则
7. 添加yum源
8. 安装常用软件
9. 设置ntp


## 操作系统安装要求
1. 操作系统安装centos 7.9
   - 或者比7.9更新的版本，小于8；
2. 硬盘分区：
  - 如果有固态硬盘：
    - 固态硬盘是主分区，装操作系统，全部挂在/，不要默认的大部分挂/home；
    - 机械硬盘到挂在在/data。
  - 如果无固态硬盘：
    - 机械硬盘全部挂在/，不要默认的大部分挂/home
3. 文件系统
   - 可以默认选ext4文件系统，不会出任何问题
   - 如果选xfs文件系统，需要设置ftype=1
      - 否则docker不支持overlay2文件系统


## 设置主机名

```shell
# 【注意】输入主机名，更改这个变量
env_hostname="主机名"
hostnamectl set-hostname $env_hostname
```



## 配置dns

```shell
# 查看自己的网卡信息
ip a
# 填有服务器内网ip的网卡名
export env_ifname="em1"
cat /etc/sysconfig/network-scripts/ifcfg-$env_ifname
#清空dns
sed -i '/DNS1=.*/d' /etc/sysconfig/network-scripts/ifcfg-$env_ifname
#配置内网dns
sed -i '$a\DNS1=192.168.0.54' /etc/sysconfig/network-scripts/ifcfg-$env_ifname
cat /etc/sysconfig/network-scripts/ifcfg-$env_ifname
# 【注意】确认输出无误，才重启网卡，否则ssh连不上网，需要到机房
systemctl restart network
ping -c 1 kube-master1
```



## 禁用防火墙、selinux

备注：尽量禁用吧，不然到时候哪个端口不通你开哪个，再花时间排查哪个报错是因为哪个端口不通

```shell
echo '禁用防火墙'
systemctl stop firewalld
systemctl disable firewalld
 
# SELinux 主要作用就是最大限度地减小系统中服务进程可访问的资源 
# 例如：黑客发现以root身份运行的redis漏洞，植入root身份的redis里的脚本，以redis进程形式操作整个主机
# selinux作用: 控制现在redis进程只获取主机一部分资源，就算你redis进程是以root用户起来的也没办法操作整个主机
echo '禁用 SELinux'
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
cat /etc/selinux/config


# swap禁用
# Linux中Swap（即：交换分区），类似于Windows的虚拟内存，就是当内存不足的时候，把一部分硬盘空间虚拟成内存使用,从而解决内存容量不足的情况
# 在内存不够的情况下，操作系统先把内存中暂时不用的数据，存到硬盘的交换空间，腾出内存来让别的程序运行，和 Windows的虚拟内存（pagefile.sys）的作用是一样的
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```



## 改ssh端口

ssh不能用22，容易中病毒

```shell
#
vi /etc/ssh/sshd_config
systemctl restart sshd.service
```



## 配置内网yum源

```shell
env_date=`date +"%Y-%m-%d"`
mv /etc/yum.repos.d /etc/yum.repos.d.$env_date.bak
mkdir /etc/yum.repos.d
 
cat > /etc/yum.repos.d/fingard.repo <<EOF
[base]
name=base
baseurl=http://192.168.0.54:8081/repository/TsingYumProxy/centos/\$releasever/os/\$basearch/
enabled=1  ## 当某个软件仓库被配置成 enabled=0 时，yum 在安装或升级软件包时不会将该仓库做为软件包提供源。使用这个选项，可以启用或禁用软件仓库 默认是1;设置enabled = 0，这样就可以禁用priorities插件。从而能够安装任意源上的包。
gpgcheck=0 ##/ 有1和0两个选择，分别代表是否进行gpg(GNU Private Guard) 校验，以确定rpm 包的来源是有效和安全的。这个选项如果设置在[main]部分，则对每个repository 都有效。默认值为0。
priority=0  ## priority=N   # N的值为1-99；数字越低优先级越高，数字越大优先级越低，安装包选择优先级高的开始安装。
 
[updates]
name=updates
baseurl=http://192.168.0.54:8081/repository/TsingYumProxy/centos/\$releasever/updates/\$basearch/
enabled=1
gpgcheck=0
priority=0
 
[extras]
name=extras
baseurl=http://192.168.0.54:8081/repository/TsingYumProxy/centos/\$releasever/extras/\$basearch/
enabled=1
gpgcheck=0
priority=0
 
[epel]
name=epel
baseurl=http://192.168.0.54:8081/repository/TsingYumProxy/epel/7/\$basearch
enabled=1
gpgcheck=0
priority=0
 
[docker-ce]
name=docker-ce
baseurl=http://192.168.0.54:8081/repository/TsingYumProxy/docker-ce/linux/centos/\$releasever/\$basearch/stable
enabled=1
gpgcheck=0
priority=0
gpgkey=http://192.168.0.54:8081/repository/TsingYumProxy/docker-ce/linux/centos/gpg
 
[kubernetes]
name=kubernetes
baseurl=http://192.168.0.54:8081/repository/TsingYumProxy/kubernetes/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
 
[elrepo]
name=ELRepo.org Community Enterprise Linux Repository - el7
baseurl=http://192.168.0.54:8081/repository/TsingYumProxy/elrepo/elrepo/el7/\$basearch/
mirrorlist=http://mirrors.elrepo.org/mirrors-elrepo.el7
enabled=1
gpgcheck=0
protect=0
 
[elrepo-kernel]
name=ELRepo.org Community Enterprise Linux Kernel Repository - el7
baseurl=http://192.168.0.54:8081/repository/TsingYumProxy/elrepo/kernel/el7/\$basearch/
mirrorlist=http://mirrors.elrepo.org/mirrors-elrepo-kernel.el7
enabled=0
gpgcheck=0
protect=0
 
EOF
 
cat /etc/yum.repos.d/fingard.repo
yum makecache fast
```

## 配置外网yum源
```shell

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
# yum源配置
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum makecache
```

## 配置外网docker源
```shell
echo '配置docker源'
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#不再改动docker的默认源，现在镜像很慢
sed -i "s/download.docker.com/mirror.azure.cn\/docker-ce/g" /etc/yum.repos.d/docker-ce.repo
```





## 安装常用软件

```shell
# 升级系统，推荐执行，新版会修复已公布的漏洞
yum update -y
 
yum install -y \
autoconf \
bash-completion \
conntrack \
curl \
dejavu-lgc-sans-fonts \
device-mapper-persistent-data \
fontconfig \
gcc \
git \
glibc-devel \
haproxy \
htop \
iotop \
ipset \
iptables \
ipvsadm \
java-1.8.0-openjdk-devel \
java-11-openjdk-devel \
jq \
keepalived \
libaio \
libpcap \
libseccomp \
lvm2 \
make \
nc \
ncurses-devel \
nethogs \
net-tools \
ntp \
numactl \
numactl-libs \
openssl-devel \
pcre \
pcre-devel \
python3 \
socat \
sysstat \
tcping \
tree \
unixODBC \
unixODBC-devel \
unzip \
vim \
wget \
yum-utils \
zip
```



## 升级linux内核

```shell
# 最新长期支持版：5.4.180-1.el7.elrepo.x86_64
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
yum --enablerepo=elrepo-kernel install kernel-lt kernel-lt-devel -y
 
# 列出启动项选择，
grep "^menuentry" /boot/grub2/grub.cfg | cut -d "'" -f2
grep "^menuentry" /etc/grub2-efi.cfg | cut -d "'" -f2
 
# 需要注意的是，执行yum update -y升级centos系统后，内核一般会升下第3个小版本，然后默认内核就是3.10.xx了，下面这步需要根据情况重新选择，未必一定是0
grub2-set-default 0
reboot
```



## 配置内核参数、iptables，主要是网络规则

```shell
#  iptables   流入主机数据包按照 iptables规则进行 过滤、封包重定向等
# Linux平台下的包过滤防火墙、免费、完成封包过滤、封包重定向和网络地址转换（NAT）等功能
# iptables规则
echo 'iptables规则'
# modprobe  br_netfilter 向内核加载 br_netfilter 、ip_vs 模块
# br_netfilter 模块用于将桥接流量转发至 iptables 链，br_netfilter 内核参数需要开启转发
modprobe br_netfilter  
modprobe ip_vs
# 清除已有配置，开放所有连接
iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat
# 转发策略开启
iptables -P FORWARD ACCEPT

 # 调大普通用户进程数限制，docker里面非root权限运行的进程全在这个里面
sed -i 's/4096/65535/g' /etc/security/limits.d/20-nproc.conf
cat /etc/security/limits.d/20-nproc.conf
 
# 关闭透明大页  -->https://blog.csdn.net/qq_20408423/article/details/121606540
echo never > /sys/kernel/mm/transparent_hugepage/enabled

# 设置Linux内核参数
cat << EOF > /etc/sysctl.d/k8s.conf
fs.file-max=52706963
fs.inotify.max_user_watches=89100
fs.nr_open=52706963
kernel.pid_max=99999
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.core.somaxconn=32768
net.ipv4.conf.all.forwarding=1
net.ipv4.conf.all.route_localnet=1
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.ip_forward=1
net.ipv4.tcp_tw_recycle=0
net.ipv6.conf.all.disable_ipv6=0
net.ipv6.conf.all.forwarding=1
net.ipv6.conf.default.forwarding=1
net.netfilter.nf_conntrack_max=2310720
vm.overcommit_memory=1
vm.panic_on_oom=0
vm.swappiness=0
EOF
sysctl -p /etc/sysctl.d/k8s.conf
```



## 设置ntp

```shell
export conf_ntp_server_ip="192.168.0.214"
 
cat << EOF > /etc/ntp.conf
driftfile /var/lib/ntp/drift
 
restrict 127.0.0.1
restrict ::1
 
# Hosts on local network are less restricted.
server $conf_ntp_server_ip
restrict $conf_ntp_server_ip nomodify notrap noquery
 
server  127.127.1.0     # local clock
fudge   127.127.1.0 stratum 10
 
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
disable monitor
EOF
 
 
rpm -q ntp
timedatectl set-timezone Asia/Shanghai
# ntpdate -u ntp.aliyun.com
ntpdate -u $conf_ntp_server_ip
systemctl restart ntpd
systemctl enable ntpd
systemctl status ntpd
timedatectl status
# 重启依赖于系统时间的服务
timedatectl set-local-rtc 0
systemctl restart rsyslog
systemctl restart crond
sleep 10
ntpq -p
ntpstat
echo $?
```

## 安装docker
安装配置docker
命令补全如果有的话：docker、kubectl、kubeadm

```shell
# 列出docker版本号
yum list docker-ce --showduplicates
# 安装docker最新版
yum install -y docker-ce kubectl
# 配置dockerd
echo '起docker daemon'
mkdir -p /etc/docker/
# 在/etc/hosts 里面加一条: 192.168.0.54 k8s-test
cat << EOF > /etc/docker/daemon.json
{
    "registry-mirrors": ["http://k8s-test:4801"],
    "insecure-registries":["k8s-test:4800", "k8s-test:4801","192.168.0.127:4800","dx.fingard.com:4800"],
    "max-concurrent-downloads": 20,
    "log-opts": {
       "max-size": "500m",
       "max-file": "3"
    },
    "live-restore": true
}
EOF
 
systemctl restart docker
systemctl enable docker
docker login k8s-test:4800 -u k8s -p 123456
 
# docker命令补全会在安装时提供
docker info
 
# kubectl命令行补全运行，装k3s时可以在k3s装完之后运行
echo 'kubectl命令行补全'
kubectl completion bash > /usr/share/bash-completion/completions/kubectl
```





## 重新分区，移除 /home

[centos7 centos-home 磁盘空间转移至centos-root下_SamScj1999的博客-CSDN博客](https://blog.csdn.net/qq_42095014/article/details/122843769)
