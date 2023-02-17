[返回上级目录](../README.md)

# 现在弃用的 Skywalking 5 版本

## 目录及链接

### ~~Skywalking 5~~
Skywalking 5版本的一些信息，正在使用的版本，但新项目不建议再使用

- [Skywalking 5 安装文档](install.md)
- [Skywalking 5 界面功能截图](manual.md)
- [公司内部改造版的源码地址](http://gitlab.fingard.cn/rdp/skywalking-FG/tree/5.0.0-GA-FG-SNAPSHOT)
- [官方中文文档](http://gitlab.fingard.cn/rdp/skywalking-FG/tree/5.0.0-GA-FG-SNAPSHOT/docs/README_ZH.md)


### 现在公司改造的版本(skywalking 5)支持的组件
这些是原版支持的组件
> * HTTP Server
>   * [Tomcat](https://github.com/apache/tomcat) 7
>   * [Tomcat](https://github.com/apache/tomcat) 8
>   * [Tomcat](https://github.com/apache/tomcat) 9
>   * [Spring Boot](https://github.com/spring-projects/spring-boot) Web 4.x
>   * Spring MVC 3.x, 4.x with servlet 3.x
>   * [Nutz Web Framework](https://github.com/nutzam/nutz)  1.x
>   * [Struts2 MVC](http://struts.apache.org/)  2.3.x -> 2.5.x
>   * [Resin](http://www.caucho.com/resin-4.0/) 3 (Optional¹)
>   * [Resin](http://www.caucho.com/resin-4.0/) 4 (Optional¹)
>   * [Jetty Server](http://www.eclipse.org/jetty/) 9
>   * [Undertow](http://undertow.io/)  2.0.0.Final -> 2.0.13.Final
> * HTTP Client
>   * [Feign](https://github.com/OpenFeign/feign) 9.x
>   * [Netflix Spring Cloud Feign](https://github.com/spring-cloud/spring-cloud-netflix/tree/master/spring-cloud-starter-feign) 1.1.x, 1.2.x, 1.3.x
>   * [Okhttp](https://github.com/square/okhttp) 3.x
>   * [Apache httpcomponent HttpClient](http://hc.apache.org/) 4.2, 4.3
>   * [Spring RestTemplete](https://github.com/spring-projects/spring-framework) 4.x
>   * [Jetty Client](http://www.eclipse.org/jetty/) 9
>   * [Apache httpcomponent AsyncClient](https://hc.apache.org/httpcomponents-asyncclient-dev/) 4.x
> * JDBC
>   * Mysql Driver 5.x, 6.x
>   * Oracle Driver (Optional¹)
>   * H2 Driver 1.3.x -> 1.4.x
>   * [Sharding-JDBC](https://github.com/shardingjdbc/sharding-jdbc) 1.5.x
>   * PostgreSQL Driver 8.x, 9.x, 42.x
> * RPC Frameworks
>   * [Dubbo](https://github.com/alibaba/dubbo) 2.5.4 -> 2.6.0
>   * [Dubbox](https://github.com/dangdangdotcom/dubbox) 2.8.4
>   * [Motan](https://github.com/weibocom/motan) 0.2.x -> 1.1.0
>   * [gRPC](https://github.com/grpc/grpc-java) 1.x
>   * [Apache ServiceComb Java Chassis](https://github.com/apache/incubator-servicecomb-java-chassis) 0.1 -> 0.5,1.0.x
>   * [SOFARPC](https://github.com/alipay/sofa-rpc) 5.4.0
> * MQ
>   * [RocketMQ](https://github.com/apache/rocketmq) 4.x
>   * [Kafka](http://kafka.apache.org) 0.11.0.0 -> 1.0
>   * [ActiveMQ](https://github.com/apache/activemq) 5.x
> * NoSQL
>   * Redis
>     * [Jedis](https://github.com/xetorthio/jedis) 2.x
>   * [MongoDB Java Driver](https://github.com/mongodb/mongo-java-driver) 2.13-2.14,3.3+
>   * Memcached Client
>     * [Spymemcached](https://github.com/couchbase/spymemcached) 2.x
>     * [Xmemcached](https://github.com/killme2008/xmemcached) 2.x
>   * [Elasticsearch](https://github.com/elastic/elasticsearch)
>     * [transport-client](https://github.com/elastic/elasticsearch/tree/master/client/transport) 5.2.x-5.6.x
> * Service Discovery
>   * [Netflix Eureka](https://github.com/Netflix/eureka)
> * Spring Ecosystem
>   * Spring Bean annotations(@Bean, @Service, @Component, @Repository) 3.x and 4.x (Optional²)
>   * Spring Core Async SuccessCallback/FailureCallback/ListenableFutureCallback 4.x
> * [Hystrix: Latency and Fault Tolerance for Distributed Systems](https://github.com/Netflix/Hystrix) 1.4.20 -> 1.5.12
> * Scheduler
>   * [Elastic Job](https://github.com/elasticjob/elastic-job) 2.x
> * OpenTracing community supported

公司内的版本添加的插件
- `logback插件`：在`MDC`里面注入`application`与`traceid`，使得日志可以打出来
- `oracle插件`：官方提供，但默认不编译、不开启；这里进行编译+配置
- `rabbitmq插件`：监控rabbitmq调用，把异步消息调用串起来
- `redisson插件`：添加对redisson监控
- `weblogic插件`：增加对weblogic的支持
