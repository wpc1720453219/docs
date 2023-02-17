# Helm 2

## 链接

1. [Helm简介 - 迷途的攻城狮](https://blog.csdn.net/chenleiking/article/details/79539012)
1. [使用Helm管理kubernetes应用 - jimmysong](https://jimmysong.io/kubernetes-handbook/practice/helm.html)
1. [Helm 2 中文文档](http://www.coderdocument.com/docs/helm/v2/index.html)

## 前置环境
### socat
helm需要所有的节点安装 socat
```bash
yum install -y socat
```
### 集群访问
当前用户可用kubectl命令操作k8s集群，即有 ` ~/.kube/config` 这个文件

## 安装

### 安装包下载
项目发布地址：
https://github.com/helm/helm/releases

当前最新版本 `v2.12.3` 下载地址（google的，需fq，当前文件夹已提供一个）：
https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz

### 执行命令
helm-rbac.yaml
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: helm
  name: helm-admin
  namespace: kube-system

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: helm-admin
  labels:
    k8s-app: helm
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: helm-admin
    namespace: kube-system

```

```bash

kubectl apply -f helm-rbac.yaml
tar -xzvf helm-v2.12.3-linux-amd64.tar.gz
cp linux-amd64/helm /usr/local/bin/
helm version
helm init --upgrade --service-account helm-admin --tiller-image registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.12.3 --stable-repo-url https://kubernetes-charts.proxy.ustclug.org

```

tiller已安装的情况下初始化helm客户端
```bash
helm init --client-only  --stable-repo-url https://kubernetes-charts.proxy.ustclug.org

```

