# K8s + Docker 分享
[《k8s+docker分享》ppt下载地址](http://10.60.44.54:8000/minio/download/ppt/kubernetes/)

由Docker容器、Kubernetes容器集群管理，实现分布式系统自动化部署、运维平台简介

[TOC]

## 培训需求
```
希望以直播的方式和大家一起分享K8S
熟悉下k8的坑
k8s 组件
k8搭建与自动化部署
关于k8交流
了解k8s运行机制及运维新场景
熟悉一下分布式
k8s 组件
熟悉K8S大概

了解docker的一些案例
期待有实践例子讲解
了解原理和工作应用场景
学习容器技术
无比期待学习docker
了解容器

干货学习
内容给力
熟悉
暂无
通俗易懂
了解下
学习
内容充实有用
get新技能
学习学习
学习下
希望对技术用途和使用方法，学习掌握
支持大佬

```

## 分布式应用部署
分布式应用的部署，不管是手动部署、自动部署脚本、容器化等等，都是要解决下面两个问题：
1. 在哪台主机部署什么？
    - k8s 屏蔽了`主机`的概念，这一切交给k8s调度。
1. 怎么部署、部署步骤？
    - docker 屏蔽了`步骤`这个概念，所有的步骤都通过镜像封装好了。

## Docker简介
[两小时入门Docker](https://www.cnblogs.com/peng104/p/10296717.html)
[技术选型之Docker容器引擎](https://segmentfault.com/a/1190000019462392)

`docker`提供运行时的隔离，把`操作系统`+`jdk`+`应用`+`启动方式`打包起来。
docker的操作表现像虚拟机，但是里面跑着的应用的进程是跑在宿主里面的，docker仅仅是做了应用程序级别的隔离。

#### 与虚拟机的对比

轻量级：一台机器，装4~5个虚拟机；而docker容器随随便便能起100个。
容器的进程是跑在物理机上面的

### 教程推荐
[菜鸟教程 - docker](https://www.runoob.com/docker/docker-tutorial.html)

### 概念介绍
镜像
容器
源
dockerfile


#### 大概原理

containerd和runc、docker的关系其实比较复杂，我们不妨简单地理解成，containerd是一个纯粹的，面向容器工业标准的一个容器管理运行时，
runc是一个包装了libcontainer的满足OCI标准的类库，docker则更像是一个承载容器而又不想只做容器引擎的一个复杂产物。
[docker，containerd，runc，docker-shim](https://www.jianshu.com/p/52c0f12b0294)
[小尝containerd（一）](http://ju.outofmemory.cn/entry/343456)


### 与手动部署相比
实际使用上的好处：
路径映射
端口映射
启动方便
安装步骤固化
自动重启
开机自启
方便管理


#### 自动重启
docker可以设置挂掉自动重启，一个参数的事儿：`--restart=always`
手动部署的应用设置自动重启可是相当的不简单，并且不同的操作系统还不一样，比如：centos6、centos7、debian、suse，各家有各家的风格。

#### 端口不再冲突
一个tomcat至少需要三个端口，而放dubbo应用的tomcat至少需要4个端口，并且只有一个端口有用，其他三个端口是废的，
而那个有用的端口我们也不需要知道它的端口号，起两个这样的应用改端口就很烦了，如果是起10多个呢？

docker下没用的端口不用管，有用的那个映射出去即可。

#### 一句命令搞定的事儿
这是一个centos7安装oracle的教程：
> [CentOS7安装Oracle11g—静默安装](https://blog.csdn.net/oschina_41140683/article/details/81510709)

看的是不是很头大？
复杂的操作步骤、配置文件等，哪一步不小心搞错了，可能前功尽弃，需要排查各种情况哪里出了问题；
实在找不到时，能够从头再来都是好的，也可能出现安装执行过程中出现了一大堆回退不了的错误，为了这事儿甚至需要重装系统；
况且就算完全按照教程来，一步都没错，却在哪个步骤教程说会打印xxx，而你的打印了yyy，由于系统、操作环境等的不一致也可能失败。

> 为了解决某个特定的问题，我经常会使用既不是我写的，我也不是很理解的软件。最好的情况是，这个我不得不用的程序有一份描述精确的使用说明。 但是往往这个程序要么没有描述文件要么就是描述文件是错误的。
> 那么， 当文件写着：『做XYZ后，就会发生PQR』，而你做了『XYZ』后，『PQR』却没发生的时候，你该怎么办呢？如果你很幸运，写这个程序的人就在你旁边，那么你就能直接过去问搞定这些问题。不是这样的话，你要么用Google碰碰运气，要么就直接挖出源代码找答案吧。
> 用Google这个「大赌场」找怎么修复bug，真的是让人极度沮丧的事儿。我简单 Google 搜索一下，然后会发现一些记录，某个可怜不幸的家伙也遇到了和我正好一样的问题。我喜出望外，颤抖着用手指输入可以除掉诅咒的魔法指令…..然后…..啥也没有改变。问题依然存在。
>
> [《为何编程如此之难？Erlang 之父的感触》](https://baijiahao.baidu.com/s?id=1589430059642139770)

而在docker启动一个oracle的操作是：
```bash
docker run -d \
    -p 1522:1521 \
    -e TZ=Asia/Shanghai \
    --name oracle-11g \
    --restart=always \
    -v /ssd/oracle/data:/u01/app/oracle \
    k8s-test:4800/sath89/oracle-ee-11g
docker logs -f oracle-11g
```
里面两行命令，其中`\`是为了看起来方便而进行的折行，而第二行仅仅是为了显示下log，看看进度，等一会儿，这样一个oracle就起好了。

这里做了磁盘映射，oracle迁移的话，把`/ssd/oracle/data`这个文件夹拷走，这句命令里面的映射地址换成新的文件夹路径即可。

docker对我们来说一个重要的功能，安装、启动步骤的`固化`。不用再去管那些乱七八糟的配置文件放在什么地方、改在那个地方、填什么值，
一般来讲，`docker run`配几个常用的环境变量、启动参数就搞定了。

#### 方便管理
我们手动起的进程，想要查看的话，一般用`ps`命令，而这个的执行结果通常与操作系统的一大堆看不懂是什么东西的进程交织混杂在一起。
首先，看不清楚，不好找；
另外，像数据库、es之类的持久化组件，会产生不能丢失的数据文件，而这些文件各个软件各有各的配置、各有各的目录结构、各有各的默认路径，
搞得各种各样、比较重要、并且还不能丢掉的文件隐藏在操作系统的各个角落，依旧是不好找、不好管理。
另外还有上面提到过的[自动重启](#自动重启)、[端口不再冲突](#端口不再冲突)，有了这些可以用docker集中管理，文件目录集中存放。
`docker ps`可以查看所有用docker启动的进程；



### docker的具体应用
我们这边主要用docker放一些有状态应用，其他无状态应用一般交给k8s管理。

mysql
elasticsearch
oracle
weblogic

nginx这个主要是起着方便，给jenkins插件源做代理用的
nginx


## Kubernetes(k8s)简介
[k8s功能简介](./concepts.md)

至于`kubernetes`（俗称`k8s`）是docker的集群管理软件，docker，不算上内置的另一个docker集群管理swarm的话，是没有集群功能的：
不能跨主机网络访问，不能跨主机调度；swarm更简单，但之所以选择它，是因为kubernetes比swarm功能更全面、更强大。

### 学习指南
[我收集的一些资料](./README.md)

### 几个关键词的概念
pod、deployment、daemonset、rs
config、node、service、namespace

#### Dashboard
[dashboard](./manual.md)
配合dashboard的截图、或现场点开讲，ppt留截图、链接

#### 大概原理
架构图、我画的那个
[k8s各组件介绍](./architecture.md)
[[ 翻译 ] Kubernetes 新手指南](http://ju.outofmemory.cn/entry/364789)

### 涉及的组件
cncf组件图

[我的组件列表](./components_list.md)

#### 介绍几个组件
kube-router
coredns
etcd k8s的持久化
grafana
nexus

#### kubectl的几个命令

我自己常用的也就这么几个，其他的要么靠命令自动补全，要么临时查文档、百度
```bash
kubectl get node
kubectl get pod -n tfp-press -o wide -w
kubectl apply -f xxx.yaml
kubectl create -f xxx.yaml
kubectl delete -f xxx.yaml
```
##### 小技巧：命令补全
docker安装的过程中已经把命令行自动补全搞定了，但kubernetes并不会，需要
```bash
sudo yum install -y bash-completion
kubectl completion bash > /usr/share/bash-completion/completions/kubectl
kubeadm completion bash > /usr/share/bash-completion/completions/kubeadm
```
执行后重新进入bash生效

## 具体应用
### kubernetes实际使用情况
k8s这边主要放一些无状态应用，无状态是指不写磁盘，就算写也就是写些临时文件、日志之类的，其中
- 临时文件无所谓，不用管，pod重启自动消失；
- 日志用filebeat收集，发送到es，就是现在用的[efk栈](../elk/README.md)。

1. java应用
    1. filebeat做sidecar
    1. 不同的namespace隔离不同的环境
    1. tomcat应用
        1. saas/tfp项目的5个环境，每个环境跑着这么些子模块
            1. acccore              
            1. adminhomepage        
            1. adminsysnew          
            1. appserver            
            1. basecore             
            1. cachemanager         
            1. checksys             
            1. dubbo-monitor-simple 
            1. fundbudsys           
            1. homepage             
            1. intraccsys           
            1. settlesys            
            1. skywalking-oap-server
            1. skywalking-ui        
            1. taskser              
            1. usercore             
            1. warningser           
            1. websysnew            
            1. workflow             
    1. dubbo应用
        1. okr系统的各环境
    1. spring boot应用
        1. apollo
        1. skywalking
    1. jenkins
    1. zookeeper
1. node应用
    1. 打包后用nginx装着
1. 其他
    1. redis单点
1. go应用
    1. 大部分是k8s系统本身
    1. kube-router
    1. kube-proxy
    1. coredns
    1. kube-scheduler
    1. kube-controller-manager
    1. kube-apiserver
    1. etcd
    1. kube-router
    1. kubernetes-dashboard
    1. monitoring-grafana
    1. heapster
    1. monitoring-influxdb


### docker镜像制作教程
[Docker 镜像制作教程](./make_image.md)

### 和jenkins的集成
#### jenkins简介
[jenkins](../jenkins/README.md)

#### 结合k8s
普通的jenkins

#### 分布式构建
jenkins kubernetes 插件的应用
- [jenkins kubernetes插件](../jenkins/kubernetes.md)
    - 一个ci的构建流程
- [jenkins部署情况](http://saas.gitlab.fingard.cn/document/deployment/jenkins.html)

### 开发者访问集群
~~[l2tp vpn](old/vpn.md)~~
现在换openvpn

### 失败例子
1. redis集群
1. elasticsearch集群
1. 没开资源限制导致集群挂掉，资源分配不均，挂掉的物理机蔓延现象

### k8s自动安装脚本
跟avatar的作用类似，就是在物理机部署应用，只不过这个应用是集群模式的k8s而已。
1. 自动安装脚本，做的事情类似于在一台物理机安装一个应用，主要做的就是一些前置linux环境准备，如时间及同步、时区、系统名、hosts、ip、网卡、yum源、linux内核参数等。
    1. 考虑搭一个dns服务器，不然新增节点就要改所有主机的hosts，除非像kube-router做到那样完全的自动化，不然这种方式显得不够可靠，比如100台机器集群，添加一台机器的话，就要改100个hosts配置。
1. 真正的安装也就是一句yum install命令，外加一个docker配置文件的修改。
1. 至于集群的启动，一句kubeadm命令就搞定了，关键是那个启动配置文件。
1. 后续的k8s集群内部组件安装，可以全部由kubectl/helm接替了，集群核心功能主要包括：
    1. cni，这里用kube-router
    1. coredns，cni装好后会自动启动
    1. 监控与图形化界面（dashboard、kuboard、Prometheus、metrics-server）
    1. ingress组件，这里用traefik

升级了一个版本，目前暂不可用，可以参考给出的几个教程来安装，或者直接运行代码里面的shell脚本。
[k8s自动安装脚本](http://gitlab.fingard.cn/devops/k8s-auto)

## 上年`展望`的实现
### helm
k8s一堆配置文件的自动化处理，有了这个，可以做到一键管理一个环境；使得k8s凌乱的各种配置文件有一个归集，更易维护。
比如一堆配置里面做了更改，删掉了某个yaml api资源，但普通的kubectl apply 一个大yaml文件、或文件夹，并不能识别出这个；helm就可以。

### Traefik
k8s ingress其中一种实现，比官方默认的nginx实现版功能更丰富，k8s内部所有的http资源，可以通过域名的方式访问。
由于http路径一般来说是有意义的，会影响到前端的访问，这里traefik的作用更类似一个外部dns，把k8s外部的域名映射到k8s内部的服务。

### gitlab
由于k8s目前机器资源紧张，以及经常改动可能造成服务不稳定，gitlab依旧是在普通机器维护。
但是gitlab自动构建ci正在使用k8s的资源，类似jenkins 的分布式构建，目前大部分用在gitlab page，vuepress自动生成的静态页面。

### openvpn
是比l2tp更好用的方式，会自动设置ip路由表；用于直接访问k8s集群内部资源，一般是tcp端口的访问，比如redis、zookeeper、dubbo。

### minio
一个类似ftp的文件上传下载服务；go实现的，单文件启动，比vsftpd更易安装；与Amazon S3 兼容，亚马逊云的S3 API（接口协议） 是在全球范围内达到共识的对象存储的协议，是全世界内大家都认可的标准。

## 展望
1. 基于k8s、虚拟机的云效
1. 基于avatar的k8s部署自动化
    - 之前有一套并不是很好用的基于python的自动部署脚本
    - 升级支持
    - 目前kubeadm可以很简单的起一个k8s集群，麻烦的是前置环境的配置，以及kubeadm前置参数的选择，
1. k8s api、存储、加解密、鉴权的深入学习
    - 之前有遇到过因能力有限，完全没办法解决的问题，只能完全重装整套k8s
1. ansible、rancher
    - k8s或其他应用自动部署相关，但随着kubeadm的完善，至少对k8s而言这些组件意义不大。
1. skaffold、draft、jenkins X
1. istio
1. ceph、rook

还有[我的组件列表](./components_list.md)里面，没接触过的组件接触下，好用的就用起来。
