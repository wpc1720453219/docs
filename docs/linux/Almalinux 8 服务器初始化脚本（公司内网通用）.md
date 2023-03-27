

# AlmaLinux

centos 8 替代品

## centos7 升级到 almalinux8

官方提供从centos7升级到almalinux8工具

[AlmaLinux OS - 升级你的发行版](https://almalinux.org/zh-hans/elevate)

[迁移CentOS 7到版本 8 的 AlmaLinux、Rocky Linux、Oracle Linux - Linux迷 (linuxmi.com)](https://www.linuxmi.com/centos-7update-almalinux-8-rocky-linux-8.html)

[从Centos-7迁移到AlmaLinux-8.6的教程_抽离1024的博客-CSDN博客_almalinux8](https://blog.csdn.net/a15969091614/article/details/121687481)



## 操作系统安装要求

1. 操作系统安装Almalinux 8；
2. 硬盘分区：
   1. 如果有固态硬盘：
      1. 固态硬盘是主分区，装操作系统，全部挂在/，不要默认的大部分挂/home；
      2. 机械硬盘到挂在在/data。
   2. 如果无固态硬盘：
      1. 机械硬盘全部挂在/，不要默认的大部分挂/home
3. 文件系统
   1. 可以默认选ext4文件系统，不会出任何问题
   2. 如果选xfs文件系统，需要设置ftype=1
      1. 否则docker不支持overlay2文件系统

## 重新分区，移除 /home

[centos7 centos-home 磁盘空间转移至centos-root下_SamScj1999的博客-CSDN博客](https://blog.csdn.net/qq_42095014/article/details/122843769)

【注意】先执行下面命令看看硬盘是否符合要求，不符合立即重装系统吧，调整硬盘比重装系统麻烦多了，并且在服务器用起来后再调整，丢数据风险极大！

```she
df -h
```



## 设置主机名

``````
# 【注意】输入主机名，更改这个变量
env_hostname="主机名"
hostnamectl set-hostname $env_hostname
``````



## 配置dns

``````
# 查看自己的网卡信息
ip a
# 填有服务器内网ip的网卡名
export env_ifname=`nmcli connection show -active | grep ethernet | awk '{print $1}'`
echo 当前网卡：$env_ifname
nmcli con mod $env_ifname ipv4.dns "10.60.44.54 223.5.5.5" 10.60.44.54
# 【注意】确认输出无误，才重启网卡，否则ssh连不上网，需要到机房
systemctl restart NetworkManager.service
cat /etc/resolv.conf
ping -c 1 kube-master1
``````



## 禁用防火墙、selinux

备注：尽量禁用吧，不然到时候哪个端口不通你开哪个，再花时间排查哪个报错是因为哪个端口不通

``````
echo '禁用防火墙'
systemctl stop firewalld
systemctl disable firewalld
 
echo '禁用 SELinux'
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
cat /etc/selinux/config
``````



## 改ssh端口

ssh不能用22，容易中病毒

``````
#
vi /etc/ssh/sshd_config
 
systemctl restart sshd.service
``````



## 配置保融内网yum源

[almalinux镜像_almalinux下载地址_almalinux安装教程-阿里巴巴开源镜像站 (aliyun.com)](https://developer.aliyun.com/mirror/almalinux?spm=a2c6h.13651102.0.0.1d1d1b11FeX6AP)

``````
env_date=`date +"%Y-%m-%d_%H-%M-%S"`
mv /etc/yum.repos.d /etc/yum.repos.d.$env_date.bak
mkdir /etc/yum.repos.d
 
cat > /etc/yum.repos.d/fingard.repo <<EOF
# http://10.60.44.54:8081/repository/yum-aliyun/
 
[baseos]
name=AlmaLinux \$releasever - BaseOS
#mirrorlist=https://mirrors.almalinux.org/mirrorlist/\$releasever/baseos
baseurl=http://10.60.44.54:8081/repository/yum-aliyun/almalinux/\$releasever/BaseOS/\$basearch/os/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-AlmaLinux
 
[appstream]
name=AlmaLinux \$releasever - AppStream
# mirrorlist=https://mirrors.almalinux.org/mirrorlist/\$releasever/appstream
baseurl=http://10.60.44.54:8081/repository/yum-aliyun/almalinux/\$releasever/AppStream/\$basearch/os/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-AlmaLinux
 
[extras]
name=AlmaLinux \$releasever - Extras
# mirrorlist=https://mirrors.almalinux.org/mirrorlist/\$releasever/extras
baseurl=http://10.60.44.54:8081/repository/yum-aliyun/almalinux/\$releasever/extras/\$basearch/os/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-AlmaLinux
 
[epel]
name=Extra Packages for Enterprise Linux 8 - \$basearch
# It is much more secure to use the metalink, but if you wish to use a local mirror
# place its address here.
baseurl=http://10.60.44.54:8081/repository/yum-aliyun/epel/8/Everything/\$basearch
#metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-8&arch=\$basearch&infra=\$infra&content=\$contentdir
enabled=1
gpgcheck=0
countme=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8
 
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=http://10.60.44.54:8081/repository/yum-aliyun/docker-ce/linux/centos/\$releasever/\$basearch/stable
enabled=1
gpgcheck=0
gpgkey=https://download.docker.com/linux/centos/gpg
 
[kubernetes]
name=Kubernetes
baseurl=http://10.60.44.54:8081/repository/TsingYumProxy/kubernetes/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
 
EOF
 
cat /etc/yum.repos.d/fingard.repo
yum makecache
``````



## 安装常用软件

``````
# 清理和docker冲突的podman
dnf remove -y podman buildah
 
# 升级系统，推荐执行，新版会修复已公布的漏洞
yum update -y
 
# 基础软件
yum install -y \
autoconf \
bash-completion \
chrony \
conntrack \
curl \
dejavu-lgc-sans-fonts \
device-mapper-persistent-data \
fontconfig \
gcc \
glibc-devel \
haproxy \
htop \
iotop \
iproute \
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
net-tools \
numactl \
numactl-libs \
openssl-devel \
pcre \
pcre-devel \
python3 \
socat \
sysstat \
tree \
unixODBC \
unixODBC-devel \
unzip \
vim \
wget \
yum-utils \
zip
 
# 安装q
wget http://10.60.44.54:8000/download/pkg/q-text-as-data-3.1.6.x86_64.rpm
rpm -ivh q-text-as-data-3.1.6.x86_64.rpm
ps -ef | q -H "SELECT UID, COUNT(*) cnt FROM - GROUP BY UID ORDER BY cnt DESC LIMIT 3"
``````



## 配置内核参数、iptables，主要是网络规则

``````
# iptables规则
echo 'iptables规则'
modprobe br_netfilter
modprobe ip_vs
iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat
iptables -P FORWARD ACCEPT
 
 
echo -e "* hard nproc 102400\n* soft nproc 102400\n* hard nofile 165536\n* soft nofile 165536" > /etc/security/limits.d/90-nproc.conf
/etc/security/limits.d/90-nproc.conf
# 需要【重启】生效
reboot
 
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
``````



设置ntp、chrony

``````
timedatectl set-timezone Asia/Shanghai
 
# 或者：ntp.aliyun.com
export conf_ntp_server_ip="10.60.44.214"
 
cat << EOF > /etc/chrony.conf
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
#pool 2.cloudlinux.pool.ntp.org iburst
server $conf_ntp_server_ip iburst
 
# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift
 
# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3
 
# Enable kernel synchronization of the real-time clock (RTC).
rtcsync
 
# Specify file containing keys for NTP authentication.
keyfile /etc/chrony.keys
 
# Get TAI-UTC offset and leap seconds from the system tz database.
leapsectz right/UTC
 
# Specify directory for log files.
logdir /var/log/chrony
 
EOF
 
systemctl restart chronyd
systemctl enable chronyd
systemctl status chronyd
 
chronyc -a makestep
timedatectl status
# 重启依赖于系统时间的服务
timedatectl set-local-rtc 0
systemctl restart rsyslog
systemctl restart crond
 
chronyc sources -v
``````





## 安装docker

1. 安装配置docker
2. 命令补全如果有的话：docker、kubectl、kubeadm

``````
# 列出docker版本号
yum list docker-ce --showduplicates
# 安装docker最新版
yum install -y docker-ce kubectl
# 配置dockerd
echo '起docker daemon'
mkdir -p /etc/docker/
# 在/etc/hosts 里面加一条: 10.60.44.54 k8s-test
cat << EOF > /etc/docker/daemon.json
{
    "registry-mirrors": ["http://k8s-test:4801"],
    "insecure-registries":["k8s-test:4800", "k8s-test:4801","10.60.44.127:4800","dx.fingard.com:4800"],
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
``````



## 添加Prometheus监控

加入k8s节点的服务器不需要这一步，k8s节点会自动添加监控

``````
# 注意！！！ 这里填下ip
export HOST_IP="这里填本机ip"
 
# 安装启动node_exporter
mkdir -p /data/prometheus
cd /data/prometheus || exit
wget http://10.60.44.54:8000/download/pkg/node_exporter-1.3.0.linux-amd64.tar.gz
tar -zxvf node_exporter-1.3.0.linux-amd64.tar.gz
 
cat << EOF >/etc/systemd/system/node_exporter.service
[Unit]
Description = prometheus node_exporter
 
[Service]
ExecStart = /data/prometheus/node_exporter-1.3.0.linux-amd64/node_exporter --web.listen-address=:9100 --collector.processes --collector.ntp --collector.systemd --collector.logind
 
[Install]
WantedBy = multi-user.target
EOF
 
systemctl daemon-reload
systemctl enable node_exporter
systemctl restart node_exporter
 
 
# 向consul注册
export id=node-exporter-$HOST_IP;
export name=node-exporter-$HOST_IP;
export address=$HOST_IP;
export port=9100;
export check=http://$HOST_IP:$port/metrics;
curl -X PUT -H "Content-Type: application/json" \
  -d "{\"id\": \"$id\",\"name\": \"$name\",\"address\": \"$address\",\"port\": $port,\"tags\": [\"test\"],\"checks\": [{\"http\": \"$check\", \"interval\": \"5s\"}]}" \
   http://10.60.44.58:8500/v1/agent/service/register
# 从consul注册中心下掉：
echo curl --request PUT http://10.60.44.58:8500/v1/agent/service/deregister/node-exporter-$HOST_IP
``````





## 卸载旧版本k8s

#### 卸载原生k8s节点

如luna-k8s

``````
kubeadm reset -f
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
ipvsadm -C
systemctl stop kubelet
systemctl disable kubelet
yum remove kubelet kubeadm kubectl -y
 
# 重启服务器，这一步非常必要，清理掉残余的虚拟网卡、网络配置
reboot
``````



### 卸载k3s节点

如avatar-k8s

```
/usr/local/bin/k3s-agent-uninstall.sh
```

## 添加为avatar-k8s节点

技术细节参考 [k3s 探索](http://jira.fingard.com:6002/pages/viewpage.action?pageId=2203068)

``````
# 首先必须初始化好docker
docker info
 
wget -O /usr/local/bin/k3s http://10.60.44.54:8000/download/pkg/k3s/v1.22.5%2Bk3s1/k3s
chmod +x /usr/local/bin/k3s
 
 
# 如果要设置pod>110 ，下面命令添加参数：--kubelet-arg=max-pods=300
# 配置节点限制 node-limit，一般：核心 rdc；企金 qj；保险 insurance；
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION="v1.22.5+k3s1" sh -s - agent \
  --token "c26b2a1384b6285d888b20b0750da1ec" \
  --server "https://10.60.44.214:6443" \
  --docker \
  --node-label node-limit=rdc
 
# 安装完成后改配置，假如需要的话
cat /etc/systemd/system/k3s-agent.service
# vim /etc/systemd/system/k3s-agent.service
# 改完后重启生效
systemctl daemon-reload
systemctl restart k3s-agent
``````



