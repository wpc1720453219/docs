## k3s
k3s 通过go的方式直接打包到一块儿，只有一个可执行文件，类似ats-hub。
1. 安装mysql ,创建 k3s库

主节点： 
```shell
wget -O /usr/local/bin/k3s http://10.60.44.54:8000/download/pkg/k3s/v1.22.5%2Bk3s1/k3s
chmod +x /usr/local/bin/k3s
  
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION="v1.22.5+k3s1" sh -s - server \
  --datastore-endpoint="mysql://root:fingard1@tcp(192.168.10.104:3306)/sunht_k3s" \
  --docker \
  --service-node-port-range="10000-32767" \
  --write-kubeconfig-mode=644
 
# 如果启动出问题，参数改动改这里：
cat /etc/systemd/system/k3s.service
# 重启
systemctl daemon-reload && systemctl restart k3s
```
指定脚本: 
```shell
curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -s - server \
  --datastore-endpoint="postgres://postgres:123456@192.168.10.1:5432/k3s-wsl?sslmode=disable" \
  --docker
```

从节点：
获取token
这里在主节点 k8s-sunht-104 执行

在主机点文件/var/lib/rancher/k3s/server/token内，【server:】后面的部分
```shell
cat /var/lib/rancher/k3s/server/token
# 下面用命令行的形式切字符串取出来
cat /var/lib/rancher/k3s/server/token | tr ':' '\n' | tail -n 1
# 这里的输出是：c1c6e493e95c736ca79994699daf5128
```


```shell
# k8s-sunht-102服务器执行
wget -O /usr/local/bin/k3s http://10.60.44.54:8000/download/pkg/k3s/v1.22.5%2Bk3s1/k3s
chmod +x /usr/local/bin/k3s
  
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_MIRROR=cn INSTALL_K3S_VERSION="v1.22.5+k3s1" sh -s - agent \
  --token "c1c6e493e95c736ca79994699daf5128" \
  --server "https://192.168.10.104:6443" \
  --docker
 
# 如果启动出问题，参数改动改这里：
cat /etc/systemd/system/k3s-agent.service
# 重启
systemctl daemon-reload && systemctl restart k3s-agent
```
