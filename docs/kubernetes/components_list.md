# k8s涉及组件清单

> [云原生全景图](https://landscape.cncf.io/)


已经用上的组件标记`✔`。

|  | 组件	   |  大概描述   |
|  ---- | ---- | ---- |
| ✔ | docker-ce	   |   docker容器运行时、操作控制   |
| ✔ | kubectl	   |  集群的使用，日常操作   |
| ✔ | kubelet	   |  负责对Pod对于的容器的创建、启停等任务   |
| ✔ | kube-proxy	   |   k8s内部逻辑与容器网络的映射，实现Kubernetes Service的通信与负载均衡机制   |
| ✔ | kube-scheduler	   | 负责资源调度（Pod调度）   |
| ✔ | kube-controller-manager	   |   k8s所有资源对象的自动化控制中心   |
| ✔ | kube-apiserver	   |   提供HTTP Rest接口，是Kubernetes里所有资源的增、删、改、查等操作的唯一入口，也是集群控制的入口   |
| ✔ | kubeadm	   |   k8s集群的搭建   |
| ✔ | coredns   |   	集群内部dns服务   |
| ✔ | kube-router	   |   k8s集群网络工具   |
| ✔ | dashboard	   |   k8s管理界面   |
| ✔ | etcd	   |   配置、注册中心   |
| ✔ | heapster   |   	监控信息收集，并在dashboard展示（官方已不再维护）   |
| ✔ | haproxy	   |   高可用代理   |
| ✔ | keepalived	   |   ip高可用   |
| ✔ | nginx	   |   反向代理   |
| ✔ | grafana	   |   监控界面   |
|  | metrics-server   |   	监控   |
| ✔ | influxdb   |   	监控数据持久化   |
| ✔ | jenkins	   |   项目自动打包、构建、发布   |
|  | jenkins X	   |   k8s环境的分布式jenkins   |
|  | rancher   |   	k8s集群部署的另一种方式   |
| ✔ | filebeat   |   	日志收集   |
| ✔ | kibana	   |   日志界面   |
| ✔ | elasticsearch   |   	日志持久化   |
| ✔ | nexus	   |   docker镜像仓库，也可以用作maven、yum、npm、helm等仓库   |
| ✔ | helm	   |   k8s里面应用的配置发布服务   |
|  | [Kubeapps](https://kubeapps.com/)	   |   helm ui界面   |
| ✔ | dive	   |   docker镜像构建历史查看   |
| ✔ | Fabric	   |   python自动运维框架，更偏手写代码   |
|  | ansible	   |   自动化运维，python写的，功能更全，更偏配置，在k8s官方的仓库里有见过用这个的   |
|  | saltstack	   |   自动化运维   |
| ✔ | prometheus	   |   监控，貌似现在k8s的监控更偏向使用这个   |
|  | ceph	   |   分布式存储   |
|  | rook	   |   ceph与k8s的集成与管理   |
|  | istio	   |   service mesh实现，与k8s高度集成   |
|  | opendevops	   |   主机管理等   |
|  | harbor	   |   docker镜像仓库，微服务分布式架构   |
|  | [skaffold](https://skaffold.dev/)	   |   helm cd命令行工具   |
|  | Traefik	   |   ingress组件的一种实现   |
| ✔ | ntp	   |   各主机时间同步   |
|  | zabbix	   |   linux监控   |
| ✔ | jib   |   	java项目通过maven打包docker镜像   |
| ✔ | kvm	   |   linux虚拟机   |
| ✔ | vmware	   |   虚拟机   |
|  | [KubeSphere](https://kubesphere.io/zh-CN/install/)   |   	k8s集群全方位监控   |
| ✔ | [Kuboard](https://kuboard.cn/)	   |   k8s更傻瓜化的dashboard，全图形界面操作，k8s持续维护的部署文档   |
|  | [宝塔Linux面板](https://bt.cn/)   |   	一个比较友好的中文linux监控界面（linux面板）   |
|  | [Draft](https://draft.sh/)   |   	draft 根据 packs 检测应用的开发语言，并自动生成 Dockerfile 和 Kubernetes Helm Charts   |
| | [Let’s Encrypt](https://letsencrypt.org/) | Let's Encrypt作为一个公共且免费SSL的项目逐渐被广大用户传播和使用，是由Mozilla、Cisco、Akamai、IdenTrust、EFF等组织人员发起，主要的目的也是为了推进网站从HTTP向HTTPS过度的进程，目前已经有越来越多的商家加入和赞助支持。 |
| | [jumpserver](http://www.jumpserver.org/) |  开源堡垒机 |
| | [KubeOperator](https://kubeoperator.io/) |  jumpserver开发的k8s安装工具 |
|| [kops](https://kubernetes.io/docs/setup/production-environment/tools/kops/) | 上k8s官网文档的k8s集群搭建工具 |
|| [KRIB](https://kubernetes.io/docs/setup/production-environment/tools/krib/) | 上k8s官网文档的k8s集群搭建工具 |
|| [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/) | 上k8s官网文档的k8s集群搭建工具 |
|| [Kubernetes Authentication](https://kuboard.cn/learning/k8s-advanced/sec/authenticate/install.html) | k8s用户认证扩展 |

​	












