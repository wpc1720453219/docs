# faq
k8s相关问题解决记录。

## metrics-server FailedDiscoveryCheck
metrics-server 有 FailedDiscoveryCheck 的异常，导致这个api不能用，导致kuboard的资源占用指标统计不了。
间接导致helm构建失败，因为这个要获取所有的api列表。

```bash
kubectl get apiservices
# v1beta1.metrics.k8s.io                 kube-system/metrics-server   False (FailedDiscoveryCheck)
```
[解决办法](https://github.com/kubernetes-sigs/metrics-server/issues/45#issuecomment-382010320)
> SOLUTION (if you are behind Corporate Proxy)
> 
> Get Cluster-IP of your metrics server kubectl -n=kube-system get services
> Add the IP to no_proxy variable in the kube-apiserver config vi /etc/kubernetes/manifests/kube-apiserver.yaml
> reload systemctl daemon-reload && systemctl restart kubelet
> should work now kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"


## redis集群
[redis集群不支持docker的端口映射](https://redis.io/topics/cluster-tutorial#redis-cluster-and-docker)


## openvpn客户端
docker命令下，需要加以下参数：
```
docker run --rm -it --privileged --device /dev/net/tun xxx bash
```
k8s下，参考openvpn服务端的helm生成文件，可以这么写，添加网络权限，并创建`/dev/net/tun`设备。
```yaml
command:
  - sh
  - -c
  - "mkdir -p /dev/net;
    mknod /dev/net/tun c 10 200;
    openvpn --config /root/xxxx.ovpn"
securityContext:
  capabilities:
    add:
      - NET_ADMIN
```

## 重启容器
1. 直接删pod
    - 最常用
2. 改deploy的个数
    - 可自动化
3. 直接在物理机 docker rm -f 删容器
    - 这个对于kube-router这样daemonSet的很有效

## join集群
在master节点执行
```bash
kubeadm token create --print-join-command
```
## 清空节点并删掉
在kubectl可用的机器上面执行
```bash
export k8s_node_name="{{env_k8s_node_name}}"
kubectl drain $k8s_node_name --delete-local-data --force --ignore-daemonsets
kubectl delete node $k8s_node_name
```
在对应节点上面执行
```bash
kubeadm reset -f
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
ipvsadm -C
```

## 更新策略
[deployment 可以选择更新策略](https://kubernetes.io/zh/docs/concepts/workloads/controllers/deployment/#%E7%AD%96%E7%95%A5)

### 重新创建 Deployment

当 `.spec.strategy.type==Recreate`,所有现有的 Pods 在创建新 Pods 之前被杀死。

### 滚动更新 Deployment

Deployment 会在 `.spec.strategy.type==RollingUpdate`时，采取 [滚动更新](https://kubernetes.io/docs/tasks/run-application/rolling-update-replication-controller/)的方式更新Pods。可以指定 `maxUnavailable` 和 `maxSurge` 来控制滚动更新操作。

### eureka集群一直unavailable-replicas
通过 cloud-eureka-0.cloud-eureka 也可以访问到对应的 POD，但是此处必须使用完整域名，否则 eureka-server 将不被认为是 available
- [kuboard 在K8S上部署eureka-server](https://kuboard.cn/learning/k8s-practice/ocp/eureka-server.html)
- [kubernetes 部署 Eureka 集群,解决unavailable-replicas,available-replicas条件](http://www.mamicode.com/info-detail-2256985.html)


## 使用 Kubernetes 最容易犯的 10 个错误！
- [使用 Kubernetes 最容易犯的 10 个错误！](https://mp.weixin.qq.com/s/ZwhgR9uWemn96_Z2-RRL4A)
- [10 Most Common Mistakes When Using Kubernetes](https://medium.com/devops-dudes/10-most-common-mistakes-when-using-kubernetes-8a07abb8e850)

1. 资源请求和限制
1. liveness 和 readiness 探针的设置
1. HTTP 服务的负载均衡器
1. 无 K8s 感知的集群自动伸缩
1. 不使用 IAM、RBAC 的功能
1. Pod 亲和性
1. 没有 PodDisruptionBudget
1. 共享集群中太多租户或环境
1. externalTrafficPolicy：Cluster
1. 把集群当宠物，控制平面压力大

## 大量pod变Evicted
[遇到问题--k8s--pod的状态为evicted](https://blog.csdn.net/zzq900503/article/details/83788152)
```bash
kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod

```

最近kube-master2 128g内存、1T硬盘，硬盘使用超80%了，导致调度到这个节点的pod老是被驱逐，pod报错：
```yaml
status:
  message: 'The node was low on resource: ephemeral-storage. Container settlesys was
    using 47644Ki, which exceeds its request of 0. Container filebeat was using 2488Ki,
    which exceeds its request of 0. '
  phase: Failed
  reason: Evicted
  startTime: "2020-07-21T09:46:09Z"
```


- [用df -h查看磁盘的使用空间，发现根目录还剩下80%, 启动kubernetes时候，发现kube-proxy无法启动，状态是Evicted。](https://blog.csdn.net/u013355826/article/details/101020231)
- [kubernetes-issue-1：ephemeral-storage引发的pod驱逐问题](https://cloud.tencent.com/developer/article/1456389)
    - 一系列原因列举
- [k8s的容器存储空间资源限制ephemeral-storage](https://blog.csdn.net/sdmei/article/details/101017405)
- [k8s pod Evicted](https://www.jianshu.com/p/d5456d9bb327)


- [Kubernetes Node节点DiskPressure异常处理.md](https://www.jianshu.com/p/29bebed74eda)

需要硬盘已用空间低于80%
```yaml
status:
  message: 'Pod The node had condition: [DiskPressure]. '
  phase: Failed
  reason: Evicted
  startTime: "2020-07-22T08:35:41Z"
```
