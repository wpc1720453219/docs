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



