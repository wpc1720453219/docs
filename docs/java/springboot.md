## actuator  
作用：健康检查 审计 统计 监控 HTTP追踪    
Actuator同时还可以与外部应用监控系统整合，比如 Prometheus  
[SpringBoot之Actuator](https://www.jianshu.com/p/563d8236bcd4)
```shell
  <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
```
[一文掌握Actuator](https://zhuanlan.zhihu.com/p/418832346)  
[SpringBoot四大神器之一：Actuator](https://blog.csdn.net/m0_64363449/article/details/131825058)  
[Spring boot——Actuator 详解](https://huaweicloud.csdn.net/63874eacdacf622b8df8a8bc.html) 

## processor
spring-boot-configuration-processor的作用就是将自己的配置你自己创建的配置类生成元数据信息，这样就能在你自己的配置文件中显示出来非常的方便。
（主要就是很多功能通过依赖导入进你的项目，你可以在配置文件中清除的看到可以配置的属性等）  
[SpringBoot学习：spring-boot-configuration-processor](https://blog.csdn.net/QLSDXF/article/details/125164652)  
[spring-boot-configuration-processor的作用](https://blog.csdn.net/meser88/article/details/120988217)  
```shell
 <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
  </dependency>
```

## spring-cloud-starter-bootstrap  
spring-cloud-starter-bootstrap 已经被弃用，取而代之的是 spring-cloud-starter-config 组件  
帮助 Spring Boot 应用程序从配置服务器（例如 Spring Cloud Config）中加载配置文件，并在应用程序启动时将其解析为 Spring Boot 属性    
[spring-cloud-starter-bootstrap](https://juejin.cn/s/spring-cloud-starter-bootstrap%20%E7%89%88%E6%9C%AC)  

## spring-boot-starter-mustache
模版引擎

## spring-cloud-dependencies
控制 cloud 各组件版本
```shell
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-dependencies</artifactId>
  <version>${spring.cloud.version}</version>
```
[https://blog.csdn.net/timeguys/article/details/106865375](https://blog.csdn.net/timeguys/article/details/106865375)

## auto-service  
先说说spi:  
SPI全称Service Provider Interface, 实际上是“基于接口的编程＋策略模式＋配置文件”组合实现的动态加载机制  
调用方只管对接口进行调用，至于接口的实现采用不同的依赖有对应的实现方法[JDBC加载不同类型数据库的驱动]， SPI的核心思想就是解耦。  
[高级开发必须理解的Java中SPI机制](https://www.jianshu.com/p/46b42f7f593c)  
auto-service 作用：  
AutoService框架的作用是自动生成SPI清单文件(也就是META-INF/services目录下的文件)。  
如果不使用它就需要手动去创建这个文件、手动往这个文件里添加服务(接口实现)，为了免去手动操作，才有了AutoService。  
[auto-service 帮我们自动生成实现类内容](https://www.cnblogs.com/rongfengliang/p/11695684.html)
APT是编译时技术，SPI是运行时技术。AutoService是APT的实现(或者叫应用)， 它运用了APT技术来解析程序中 @AutoService注解并且
自动生成SPI清单文件，SPI清单文件中保存了接口(服务)的实现，SPI清单文件是在程序运行时由ServiceLoader读取。  
[Google AutoService的使用与源码解析](https://blog.csdn.net/devnn/article/details/126837081)  

