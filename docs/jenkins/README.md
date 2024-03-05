# Jenkins

![logo](./images/1502354304971856.png)

## 目录及链接

### 目录
1. [截图及功能说明](./manual.md)
1. [插件介绍](./plugins.md)
    1. [jenkins kubernetes插件](./kubernetes.md)
1. [问题解决备忘](./faq.md)
    1. [环境变量参考：env-vars](./env-vars.md)
1. [单元测试相关](./unit-test.md)
1. [jenkins docker镜像相关](./docker.md)

### 外链

1. [Jenkins官网](https://jenkins.io/)
1. [Jenkins官方文档（中文）](https://jenkins.io/zh/doc/)
1. [Jenkins中文文档-w3cschool](https://www.w3cschool.cn/jenkins/?)
1. [jenkins 插件下载加速最终方案](https://my.oschina.net/VASKS/blog/3106314)
    1. [tfp项目的一个实现](http://saas.gitlab.xyyweb.cn/document/environment/jenkins.html#jenkins插件更新源)
1. [Jenkins出现No valid crumb was included in the reques【通常会在反向代理时出现】](https://blog.51cto.com/13589448/2066437)

### Jenkins Pipeline
1. [Jenkins Pipeline 发送邮件配置](https://www.jianshu.com/p/c8fab60ed58e)
1. [jenkins pipeline中获取shell命令的输出](https://blog.csdn.net/zimou5581/article/details/94016158)
1. [pipeline基础步骤 workflow-basic-steps](https://jenkins.io/zh/doc/pipeline/steps/workflow-basic-steps/)
1. [pipeline步骤参考手册](https://www.jenkins.io/zh/doc/pipeline/steps/)
1. [参数 parameters 语法参考](https://www.jianshu.com/p/7a852d58d9a9)
1. [parallel 语法文档](https://plugins.jenkins.io/workflow-cps/)
```groovy
retry(3) {
for (int i = 0; i < 10; i++) {
  branches["branch${i}"] = {
    node {
      retry(3) {
        checkout scm
      }
      sh 'make world'
    }
  }
}
parallel branches
```

### rest api
1. [Jenkins API 中文文档](https://blog.csdn.net/nklinsirui/article/details/80832005)
1. [远程访问API - 官网文档](https://wiki.jenkins.io/display/JENKINS/Remote+access+API)
1. [java rest操作封装](https://github.com/cdancy/jenkins-rest)

## 简介

> copy自[Jenkins中文文档-w3cschool](https://www.w3cschool.cn/jenkins/?)

**Jenkins**是一个独立的开源软件项目，是基于[Java](https://www.w3cschool.cn/java/)开发的一种持续集成工具，用于监控持续重复的工作，旨在提供一个开放易用的软件平台，使软件的持续集成变成可能。前身是Hudson是一个可扩展的持续集成引擎。可用于自动化各种任务，如构建，测试和部署软件。Jenkins可以通过本机系统包[Docker安装](https://www.w3cschool.cn/docker/)，甚至可以通过安装Java Runtime Environment的任何机器独立运行。

### 主要用于：

1. 持续、自动地构建/测试软件项目，如CruiseControl与DamageControl。
2. 监控一些定时执行的任务。

### 环境搭建

Jenkins支持各个平台上的搭建过程，开发我们主要在Linux和win7上玩转Jenkins，这边主要通过win7下介绍Jenkins玩法，[Linux](https://www.w3cschool.cn/linux/)上大同小异。

### Jenkins特点：

1. 开源免费;
1. 跨平台，支持所有的平台;
1. master/slave支持分布式的build;
1. web形式的可视化的管理页面;
1. 安装配置超级简单;
1. tips及时快速的帮助;
1. 已有的200多个插件
