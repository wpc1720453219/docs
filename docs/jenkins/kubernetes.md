# jenkins kubernetes

1. [Kubernetes plugin for Jenkins - github](https://github.com/jenkinsci/kubernetes-plugin)
    1. [官方示例（带RBAC）](https://github.com/jenkinsci/kubernetes-plugin/tree/master/src/main/kubernetes)
    1. [声明式pipeline教程](https://github.com/jenkinsci/kubernetes-plugin#declarative-pipeline)
1. [Kubernetes plugin for Jenkins](https://plugins.jenkins.io/kubernetes)
1. [初试 Jenkins 使用 Kubernetes Plugin 完成持续构建与发布](https://blog.csdn.net/aixiaoyang168/article/details/79767649)
1. [Jenkins 和 Kubernetes -云上的神秘代理](https://jenkins.io/zh/blog/2018/09/14/kubernetes-and-secret-agents/)

## ci示例
单个模块的jenkins pipeline + k8s ci：
1. gitlab代码提交
1. jenkins触发构建
1. 拉取pipeline构建代码（只传几个经常变动的参数）
1. jenkins kubernetes plugin 创建一个jenkins从节点pod，以下在从节点进行
1. 调用 jenkins pipeline shared library 通用maven构建代码
1. 拉取kubectl配置、maven配置文件等基础环境配置
1. mvn编译项目
1. maven中的jib插件自动生成一个docker镜像上传到nexus3 docker私服
1. k8s deployments滚动替换对应的docker镜像为现在上传的镜像
1. java程序在新pod里面启动，一次更新完成

整个微服务项目的jenkins pipeline + k8s + helm ci：
1. 编写或修改通用helm chart
1. 使用gitlab ci参考官方示例为这个helm chart创建一个简单helm仓库
1. jenkins pipeline使用helm镜像启动
1. 使用这个chart生成一个环境
1. 接下来就是单个模块的ci

