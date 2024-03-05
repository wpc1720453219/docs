# Java 相关

## 官网
1. [OpenJDK](https://jdk.java.net/)
    - openjdk官网不再维护java 8、11这样的旧版本，新版由redhat维护，并且OpenJDK官方提供的编译包不多，只提供源码包，推荐到[AdoptOpenJDK](https://adoptopenjdk.net/)下载
    1. [AdoptOpenJDK](https://adoptopenjdk.net/) [清华镜像](https://mirrors.tuna.tsinghua.edu.cn/AdoptOpenJDK/)
        - openjdk纯源码无商标构建，持续维护，各系统、各大版本的最新版可运行的openjdk程序，甚至包含nightly构建
        - 下载openjdk可以到这里下载，docker官方jdk镜像默认的源就是在这里
        - [从oracle jdk迁移到openjdk指南、及功能对比：Migrating from Oracle JDK](https://adoptopenjdk.net/migration.html#migration-oracle)
    1. [redhat的各版本openjdk下载](https://developers.redhat.com/products/openjdk/download)
    1. [红帽接手维护 OpenJDK 8 和 OpenJDK 11](https://www.oschina.net/news/106051/leadership-openjdk-8-and-openjdk-11-transitions-red-hat)
    1. [openjdk 各版本docker镜像](https://hub.docker.com/_/openjdk)
1. [oracle java](https://www.oracle.com/java/)
    1. [oracle java 各版本下载](https://www.oracle.com/java/technologies/oracle-java-archive-downloads.html)
    1. [oracle java 协议，新版商用要付费](https://www.oracle.com/technetwork/java/javase/overview/oracle-jdk-faqs.html)
    1. [Oracle如何对JDK收费](https://zhuanlan.zhihu.com/p/64731331)
    1. [oracle和google的官司](https://www.baidu.com/s?ie=UTF-8&wd=oracle%20google)

## java
1. [JDK11变化详解，JDK8升级JDK11详细指南](https://www.jianshu.com/p/81b65eded96c)
1. [Java 8-13版本功能差异一览指南](https://www.jdon.com/53413)
    1. [Java 13权威指南](https://www.jdon.com/53139) 终于支持多行字符串了

## h2数据库
1. [h2 特性 页面里面的 Database URL Overview](http://www.h2database.com/html/features.html)
    - 各种jdbc url的支持，包括单文件嵌入式、内存、端口等

### faq
#### idea连数据库失败
idea连不上spring boot自动生成的数据库，或者就算连上数据库也找不到表。

解决：
1. [数据库文件名不要带扩展名，会和h2驱动自动补全的冲突](https://intellij-support.jetbrains.com/hc/en-us/community/posts/203527130-Intellij-IDEA-and-H2-DB-file-recognition-problem)。
2. jdbc url 要加 [`;AUTO_SERVER=TRUE` 参数](https://stackoverflow.com/questions/49139874/h2-tables-not-showing-up-in-intellij-for-jhipster-generated-project)。
如：`jdbc:h2:file:./dist/db/avatar;AUTO_SERVER=TRUE`

#### spring jpa 重启会清数据
1. [要注意 `ddl-auto` 这样的参数](https://blog.csdn.net/sanpic/article/details/80816379)
比如：
```
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.generate-ddl=true
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
spring.datasource.platform=h2
```


## ssh jsch
使用[hutool封装的`JschUtil`](https://hutool.cn/docs/#/extra/Jsch%E5%B0%81%E8%A3%85/Jsch%E5%B7%A5%E5%85%B7-JschUtil)。

特点：
- 应该比原生的易用，看原生的jsch示例及评价，显得非常难用
- 默认exec方法，ssh的stderr打印在java的stderr，stdout作为字符串返回值

- [Jsch性能问题](https://blog.csdn.net/by_style/article/details/78308526)
- [退出码是-1的问题：What is the reason to get exit status value -1 in JSch](https://stackoverflow.com/questions/21280211/what-is-the-reason-to-get-exit-status-value-1-in-jsch)

## maven
1. [mvnw的作用是控制maven版本](https://www.liaoxuefeng.com/wiki/1252599548343744/1305148057976866)
1. [Maven编译指定(跳过)Module](https://www.cnblogs.com/yqyang/p/11328139.html)
1. [Maven maven-jar-plugin](https://www.jianshu.com/p/d44f713b1ec9)

### 小技巧：解决多个并行项目编译时序问题
刚想到一个小技巧，加这两个pom文件，可以完美解决依赖、自动打包等问题

在外层文件夹引用内部项目的文件夹名字，只引用文件夹，其他什么都不做，maven就能自动处理依赖、各项目打包等关系。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.xyyweb.rabbit.tfp</groupId>
    <artifactId>cc-all</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>

    <modules>
        <module>cc-cloud</module>
        <module>cc-thirdsys</module>
        <module>cc-usercore</module>
        <module>cc-cloud-tools</module>
    </modules>
</project>

```
### FAQ
#### Q: Maven指定pom启动
```bash
mvn clean install -f pom_own.xml
```
> [maven 指定pom.xml 启动](https://blog.csdn.net/majinfei/article/details/53406550)

## 工具包
1. [jmustache](https://github.com/samskivert/jmustache)
    - Mustache（胡子）模板引擎的java实现，类似jinja2模板引擎、vue取值语法，`{{}}`格式的。
1. [java下的图算法库](https://stackoverflow.com/questions/51574/good-java-graph-algorithm-library)
    - bing 关键词：`java graph library`，注意搜包的时候要用`library`，而不是`util`、`package`、`jar`之类的，这些关键词找不到。
    1. [JGraphT](https://github.com/jgrapht/jgrapht) 有最新时间的维护，并提供工具和guava配套使用，应该是最活跃的。
1. [vavr：让你像写Scala一样写Java](https://www.jianshu.com/p/bec7b7ab7c81)
    - 针对java8 lambda函数式与stream增强的工具包
    1. [vavr官网](https://www.vavr.io/)
    1. [vavr官方文档](https://www.vavr.io/vavr-docs/)
1. [google自动spi文件生成](https://github.com/google/auto/tree/master/service)
### [Hutool](https://hutool.cn/)
hutool的`cn.hutool.core.io.FileUtil#file(String)`方法传入相对路径的话，是从classpath下寻找的，
和默认的`new File(String)`并不一样，java自带的file是当前路径，这个应该是java进程启动的路径。

读一个classpath文件的最简洁写法：
```groovy
String string = ResourceUtil.readUtf8Str('classpath:/static/config/apollo/sql/apollo_config_db.sql')
```

### 科学计算
[apache commons-math](http://commons.apache.org/proper/commons-math/)

[数值计算包 List of numerical libraries](https://en.wikipedia.org/wiki/List_of_numerical_libraries#Java)

[Java第三方工具库/包汇总](https://blog.csdn.net/panrenlong/article/details/79246349)

[基本概念:DL4J,Torch,Theano,TensorFlow,Caffe,Paddle,MxNet,Keras和CNTK的比较](https://my.oschina.net/lums/blog/1809043)

## Sonar
SonarLint是idea插件
- [Java代码规范与质量检测插件SonarLint](https://www.cnblogs.com/cjsblog/p/10735800.html)

## 小技巧
### 指向自身的泛型
```java
public abstract class Enum<E extends Enum<E>>
        implements Comparable<E>, Serializable {}
```

### 以字符串的方式监听一个OutputStream
有时会有一个接口让传output stream，已经封装好的各种stream真的都是输出到各种地方，但有时我们只想对输出的一行行字符串做些处理。
spock测试框架下就有一个类能满足这种需求：
```xml
<dependency>
  <groupId>org.spockframework</groupId>
  <artifactId>spock-core</artifactId>
  <version>1.3-groovy-2.5</version>
</dependency>
```
```groovy
import org.spockframework.util.StringMessagePrintStream

def stringMessagePrintStream = new StringMessagePrintStream() {
    @Override
    protected void printed(String message) {
        StrUtil.split(message, '\n').each { log.debug(it) }
        // log.debug(message)
    }
}
channel.setErrStream(stringMessagePrintStream, false)
channel.setOutputStream(stringMessagePrintStream, false)

```

## Netty
k8s下netty的dns解析问题：
- [DNS Issue on Kubernetes (ndots=5 + search domain query) #8880](https://github.com/netty/netty/issues/8880)

## 网络编程
1. [Java—网络编程总结（整理版）](https://www.cnblogs.com/swordfall/p/10781281.html)
### Wireshark
tcp包分析工具
1. [Wireshark 官网](https://www.wireshark.org/)

### 客户端发syn未回复
- [linux开启tcp_timestamps和tcp_tw_recycle引发的问题研究](https://www.cnblogs.com/charlieroro/p/11593410.html)
- [NAT网络下TCP连接建立时可能SYN包被服务器忽略-tcp_tw_recycle](http://chenzhenianqing.com/articles/1150.html)


现象：发现同时启用该参数tcp_tw_recycle和tcp_timestamps后有可能在NAT环境下导致客户端始连接失败，抓包表现为：客户端一直发送SYN报文，但服务端不响应。

默认状态：
- /proc/sys/net/ipv4/tcp_tw_recycle （默认关闭的） 
- /proc/sys/net/ipv4/tcp_timestamps （默认打开的）
```
[root@rdc-test-57 ~]# sysctl net.ipv4.tcp_tw_recycle
net.ipv4.tcp_tw_recycle = 0
[root@rdc-test-57 ~]# sysctl net.ipv4.tcp_timestamps
net.ipv4.tcp_timestamps = 1
```

## FAQ
### Java在Linux下不能处理图形
Java运行时加上参数：-Djava.awt.headless=true
1. [Java在Linux下 不能处理图形--提示信息："Can't connect to X11 window server"](https://yq.aliyun.com/articles/545855)
1. [java处理图片时找到不sun.awt.X11GraphicsEnvironment问题](https://www.bbsmax.com/A/A2dmn8eBze/)
