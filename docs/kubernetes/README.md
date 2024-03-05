# Kubernetes

## 目录
1. [连接k8s内网vpn教程](./vpn.md)
1. [essen项目部署文档](essen_deploy.md)
    - 一个k8s配置流程的示例
1. [k8s各组件介绍](architecture.md)
1. [k8s功能简介](concepts.md)
1. [Dashboard截图及功能说明](./manual.md)
1. [k8s涉及组件清单](./components_list.md)
1. [K8s + Docker 分享](./k8s_docker_share.md)
    - [《k8s+docker分享》ppt下载地址](http://10.60.44.54:8000/minio/download/ppt/kubernetes/)
1. [Helm](./helm.md)

## 外链
### k8s、cncf等官网
1. [k8s官网](https://kubernetes.io/zh/)
    - 中文版内容不全，遇到找不到的可以到[英文版](https://kubernetes.io/)
    1. [coredns升级指南](https://kubernetes.io/docs/tasks/administer-cluster/coredns/#upgrading-coredns)
    1. [k8s的最新版发布](https://github.com/kubernetes/kubernetes/releases)
    1. [CHANGELOG 各版本变化说明 支持的docker版本会在`CHANGELOG-*.md`里面](https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG)
    1. [官方 dashboard](https://kubernetes.io/zh/docs/tasks/access-application-cluster/web-ui-dashboard/)
1. [云原生全景图](https://landscape.cncf.io/)
    1. [cncf组件](https://landscape.cncf.io/format=card-mode&project=graduated,incubating)

### 系列资源、文档
1. [**Kubernetes指南 - feiskyer**](https://kubernetes.feisky.xyz/)
    1. [Kubernetes指南 - github地址](https://github.com/feiskyer/kubernetes-handbook)
    - 这个是比较系统、并且比较新的学习资料，有原理介绍，一个个组件式安装，概念、组件介绍，
    - 有k8s生态的实用工具介绍如draft、jenkins X等，实践案例
1. [**k8s学习文档 (kuboard)**](https://kuboard.cn/learning/)
    - 有持续更新的k8s集群安装、升级教程，教程内容是官网文档的翻译（官网文档的中文版很混乱）
    1. [亲和性与反亲和性](https://kuboard.cn/learning/k8s-intermediate/config/affinity.html)
1. [和我一步步部署 kubernetes 集群 (opsnull)](https://github.com/opsnull/follow-me-install-kubernetes-cluster)
1. [从Docker到Kubernetes进阶](https://www.qikqiak.com/k8s-book/)
    - 内有helm的教程

### 博客、文章
1. [青蛙小白 博客](https://blog.frognew.com/tags.html)
    1. [使用OpenVPN将Kubernetes集群网络暴露给本地开发网络](https://blog.frognew.com/2019/03/kubernetes-and-openvpn.html)
    1. [使用kubeadm安装Kubernetes 1.13](https://blog.frognew.com/2018/12/kubeadm-install-kubernetes-1.13.html)
        - 我自己写的k8s自动安装脚本就是参考这篇文章
1. [kubernetes实战篇之创建密钥自动拉取私服镜像](https://www.cnblogs.com/tylerzhou/p/11112086.html)
1. [[ 翻译 ] Kubernetes 新手指南](http://ju.outofmemory.cn/entry/364789)
    - 对k8s原理介绍最给力的一篇译文，图画的非常好、一级级的通过k8s的概念介绍了k8s的架构。图多，适合做ppt。
1. [What happens when I type kubectl run?（译文）](https://github.com/jamiehannaford/what-happens-when-k8s/blob/master/zh-cn/README.md)
    - 从一次执行的时序角度，介绍了k8s的原理
1. [史上最强 Kubernetes 知识图谱（附链接）](https://www.processon.com/view/link/5ac64532e4b00dc8a02f05eb#map)

### 原创
1. [k8s+docker部署文档](http://gitlab.xyyweb.cn/devops/k8s-auto)
