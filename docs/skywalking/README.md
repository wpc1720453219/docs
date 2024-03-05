# Skywalking
![logo](./images/687474703a2f2f736b7977616c6b696e672e6170616368652e6f72672f6173736574732f6c6f676f2e737667.svg)

## 目录及链接
### 目录
- [Skywalking 6 安装文档](install.md)
- [Skywalking 6 界面功能截图](manual.md)
- [Skywalking 6 java代码端的使用](./use-in-java.md)
    - [扩展项目gitlab地址](http://gitlab.xyyweb.cn/rdp/skywalking-FG)
    - 包括手动获取traceid、手动添加trace、跨线程、日志添加traceId等
- [Skywalking 6 FAQ](./faq.md)
- [~~现在弃用的 Skywalking 5 版本~~](./5/README.md)

### 链接
#### 官网
- [Skywalking官网](https://skywalking.apache.org/)
- [Skywalking 6 支持的组件：Supported-list](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Supported-list.md)
- [探针性能揭秘 - skywalking的性能消耗](https://github.com/SkyAPMTest/Agent-Benchmarks/blob/master/README_zh.md)
- [版本发布页，从6.6版本开始支持elasticsearch7了](https://skywalking.apache.org/zh/downloads/)
    - 并且现在也有了官方helm chart
- [一个比较全的包下载地址，比如官方页面6.3.0以前的版本没有了](http://archive.apache.org/dist/skywalking/)
- [后台存储配置文档](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/backend/backend-storage.md)
    - [支持告警功能、webhook](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/backend/backend-alarm.md)

#### OpenTracing
skywalking 是 OpenTracing 的一个实现。
- [OpenTracing官网](https://opentracing.io/)
- [opentracing文档中文版 (翻译) 吴晟](https://wu-sheng.gitbooks.io/opentracing-io/content/)

#### 其他链接
- [APM系统SkyWalking介绍 - 运维咖啡吧](https://mp.weixin.qq.com/s/F-IPkfo6jp6Wkb4ql-jaLg)

## 简介
**SkyWalking** 创建于2015年，提供分布式追踪功能。
从5.x开始，项目进化为一个完成功能的[Application Performance Management](https://en.wikipedia.org/wiki/Application_performance_management) - APM系统。
他被用于追踪、监控和诊断分布式系统，特别是使用微服务架构，云原生或容积技术。提供以下主要功能：
- 分布式追踪和上下文传输
- 应用、实例、服务性能指标分析
- 根源分析
- 应用拓扑分析
- 应用和服务依赖分析
- 慢服务检测
- 性能优化

## 支持组件
新系统使用了spring boot、spring cloud、spring webflux这些比较新的东西的话，
推荐使用skywalking 6版本，内置了这些组件的支持，而5版本没有。
skywalking 6版本支持的组件：[Supported-list](https://github.com/apache/skywalking/blob/master/docs/en/setup/service-agent/java-agent/Supported-list.md)

### 现在强烈推荐使用6版本

关于插件，6版本提供rabbitmq、spring webflux、Spring Cloud Gateway、eureka、hystrix、redissson、Lettuce的支持。

关于后端，官方新增慢sql支持。

关于前端：服务调用链支持树的形式，官方有国际化形式的中文支持；前端是vue+ts；

