# Docker 镜像制作教程
以essen、ats-saas为例


## 查看docker镜像
进入容器查看文件
```bash
docker run --rm -it nginx bash
```

有的镜像没有`bash`，运行这行命令
```bash
docker run --rm -it nginx:alpine bash
```
会报错：
```bash
docker: Error response from daemon: OCI runtime create failed: container_linux.go:348: starting container process caused "exec: \"bash\": executable file not found in $PATH": unknown.
```
这时可以用`sh`访问容器：
```bash
docker run --rm -it nginx:alpine sh
```

## docker镜像制作
### 最普通的docker镜像制作示例
```docker
FROM tomcat:7
ENV TZ Asia/Shanghai
ADD msyh.ttc /usr/share/fonts/
ADD ats-web-front.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
```
说明：
1. 以docker官方的tomcat7为基础镜像，
2. 设置中国时区，
3. 添加字体，
4. 把打好的war包放到tomcat的路径下，
5. 启动命令（这个可继承基础镜像的，可不写，可自定义）

#### 制作镜像
把dockerfile及相关文件和编译好打好包的项目上传到有docker的远端服务器，`cd`到文件夹下

```bash
docker build -f front.dockerfile -t k8s-test:4800/com.fingard/tomcat-example:1.0.0 .
```

上传镜像到私服
```bash
docker push k8s-test:4800/com.fingard/tomcat-example:1.0.0
```
#### 该方法点评
以上步骤看似没什么毛病，但那个war包里面的参数是写死的，并且全部是手动的，仅仅改一个数据库的ip，都要从头开始再来一遍

> DevOps八荣八耻 —— 徐天岳
> - 以可配置为荣     以硬编码为耻
> - 以系统互备为荣   以系统单点为耻
> - 以随时可重启为荣 以不能迁移为耻
> - 以整体交付为荣   以部分交付为耻
> - 以无状态为荣     以特殊化为耻
> - 以自动化工具为荣 以人肉操作为耻
> - 以无人值守为荣   以人工介入为耻


操作全部靠手工，仅仅是一个可变参数的修改会导致镜像不可用，明显不合理。


### 使用maven插件jib自动打包镜像
java项目一般用`maven`编译构建，而maven有这些插件可以做到通过maven自动打包

- [com.spotify:docker-maven-plugin](https://github.com/spotify/docker-maven-plugin)
- [com.spotify:dockerfile-maven-plugin](https://github.com/spotify/dockerfile-maven)
- [com.google.cloud.tools:jib-maven-plugin](https://github.com/GoogleContainerTools/jib)

其中，`docker-maven-plugin`项目已废弃，被`dockerfile-maven-plugin`项目取代，这两个项目都依赖一个正在运行的`dockerd`后台；
`jib`项目是google的，github的star比前两者多，并且是直接操作的镜像文件，对镜像的缓存也有优化，并且不依赖`docker`后台，所以最终选型`jib`。

这两个最主要的区别是：docker-maven-plugin只是java代码调用dockerd服务的tcp做请求，而jib是直接用java代码制作docker镜像的（无需后台起着docker）。

[jib-maven官方文档](https://github.com/GoogleContainerTools/jib/blob/master/jib-maven-plugin/README.md)

[jib各种demo地址](https://github.com/GoogleContainerTools/jib/tree/master/examples)

### 尽量兼容以前的配置方式的tomcat项目打包docker镜像步骤简化
这个方法不能保证镜像的参数不写死，但可以简化打包步骤。
目前在ats-saas的k8s环境用的是这种打包方式。

#### tomcat基础镜像
以tomcat 8.5为例，tomcat7也可以参考：
```dockerfile
FROM tomcat:8.5-alpine

ENV TZ Asia/Shanghai

RUN rm -rf /usr/local/tomcat/webapps/*
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache -U tzdata msttcorefonts-installer fontconfig ttf-dejavu
RUN update-ms-fonts && fc-cache -f

ADD msfonts /usr/share/fonts/msfonts/
```
目录结构
```
.
└── 8.5-alpine
    ├── Dockerfile
    ├── msfonts
    │   ├── msyh.ttc
    │   ├── msyhbd.ttc
    │   ├── msyhl.ttc
    │   ├── simfang.ttf
    │   ├── simkai.ttf
    │   └── simsun.ttc
    └── readme.md
```
镜像名：
```
k8s-test:4800/com.fingard.baseimage/tomcat:saas-8.5-alpine
```
操作有：
- 设置中国时区
- 删掉tomcat默认的其他项目
- 安装微软字体，及常用中文字体包括
    - 微软雅黑
    - 宋体
    - 楷体
    - 仿宋

至于打包镜像，可以在装了docker的linux下用命令行，但更简单方便的方式是idea安装docker插件，配置一个docker远程端口后，在idea中就可以执行。
打包后用 `docker push` 命令推送到私服（或直接发到docker-hub，反正基础镜像里面没公司的项目）。

关于基础镜像的要求，需要尽量做到完成了除要放进的项目之外的一切准备工作，然后制作项目镜像的时候，打包的操作只需要把项目拷进去即可。

#### 项目的maven添加些配置
`pom.xml`的`properties`里面添加下面几行。
其中：
- `jib-maven-plugin.version`是jib插件的版本
- `docker-registry-address`是docker私服的地址
- `jenkins.buildNumber`和`jenkins.buildTag`这两个参数随意，只作为一个占位符，给镜像打标签确定版本号的。
每次打包的新镜像都要有不同的版本号，这个需要运行`mvn`命令时以`-D`参数带过去。

```xml
    <properties>
        
        ……
        
        <!-- Docker配置 -->
		<jib-maven-plugin.version>1.0.0</jib-maven-plugin.version>
		<docker-registry-address>k8s-test:4800</docker-registry-address>
		<jenkins.buildNumber>0</jenkins.buildNumber>
        <jenkins.jobName>jenkins</jenkins.jobName>
        <jenkins.buildTag>jenkins</jenkins.buildTag>
        <jib.skip>true</jib.skip>
    </properties>
```

私服的用户名、密码需要在maven的`apache-maven-3.2.3/conf/settings.xml`里面配置，
```xml
    <servers>
        ……
        
        <server>
            <id>k8s-test:4800</id>
            <username>k8s</username>
            <password>123456</password>
            <configuration>
                <email>k8s@test.com</email>
            </configuration>
        </server>
    </servers>
```
然后在tomcat打war包的那个项目，比如`basecore-provider`项目，`pom.xml`加入以下配置中的 `<plugin>……</plugin>`：
```xml
    <build>
        ……
        <plugins>
            ……

            <plugin>
                <groupId>com.google.cloud.tools</groupId>
                <artifactId>jib-maven-plugin</artifactId>
                <version>${jib-maven-plugin.version}</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>build</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <from>
                        <image>k8s-test:4800/com.fingard.baseimage/tomcat:saas-8.5-alpine</image>
                    </from>
                    <to>
                        <image>${docker-registry-address}/${project.groupId}/${project.artifactId}</image>
                        <tags>
                            <tag>${project.version}</tag>
                            <tag>${jenkins.jobName}</tag>
                            <tag>${project.version}.${jenkins.jobName}.${jenkins.buildNumber}</tag>
                            <tag>${jenkins.buildTag}</tag>
                        </tags>
                    </to>
                    <container>
                        <appRoot>/usr/local/tomcat/webapps/webmvc</appRoot>
                        <ports>
                            <port>8080</port>
                        </ports>
                        <useCurrentTimestamp>true</useCurrentTimestamp>
                    </container>
                    <allowInsecureRegistries>true</allowInsecureRegistries>
                </configuration>
            </plugin>
        </plugins>
    </build>
```
稍微解释下，详细的文档看[官网文档](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin)

maven构建命令：
```bash
mvn package -Djib.skip=false -DsendCredentialsOverHttp=true -P cmbc-mysql-test \
    -Djenkins.buildNumber=$BUILD_NUMBER -Djenkins.buildTag=$BUILD_TAG -Djenkins.jobName=$JOB_NAME
```
这个命令会构建镜像并推送到私服。若没私服，可以用 `mvn jib:buildTar` 构建`.tar`文件，然后用`docker load --input target/jib-image.tar`导入镜像

`groupId`、`artifactId`、`version`指定插件依赖；`configuration`为配置：
- `from` 基础镜像
- `to` 要打包的镜像名，带上私服地址，直接推送
    - 可以写多个`tag`，这个`tag`可作为当前镜像的唯一标识，比如在jenkins环境下，有`BUILD_NUMBER`、`BUILD_TAG`这两个环境变量，每次构建都不一样
- `container` 是镜像详细的配置内容
    - `appRoot` 把项目文件复制到哪个目录
    - `args` 相当于docker的`CMD`，若没特别需求就不用写，直接继承基础镜像的即可
    - `environment` 为镜像添加环境变量

jenkins开头的几个-D属性，是这个编译过程在jenkins中构建时使用的，可以把jenkins的构建码，给镜像打一个的唯一识别的标签，可以供k8s使用。

executions绑定了package步骤，但默认的属性jib.skip设置为true，也就是说普通的编译会跳过镜像构建，就像跳过单元测试那样，
想要启用时在maven package或install命令加入`-Djib.skip=false`参数即可，也就是不跳过镜像构建。

### essen java项目的打包镜像方式

这个项目和普通的tomcat打war包的项目而言比较激进，但更好的符合了“DevOps八荣八耻”。
做到不同环境（测试环境、开发环境）编译出来的zip包、war包是一模一样的，运行时可修改配置文件。
也就是说编译时不区分环境，环境是在运行时区分的，随便编译出来一个包，改下配置，在不同的环境就能跑。
配置文件可预设一部分，也可以做到运行时完全更改；
对于预设的配置文件，比如：dev、test，在运行时加一个启动参数即可切换；
对于完全陌生的环境，完全可以参考已有的配置，新建配置文件运行（对于k8s而言就是挂载一个新的配置文件）。

使用示例：
```xml
<plugin>
    <groupId>com.google.cloud.tools</groupId>
    <artifactId>jib-maven-plugin</artifactId>
    <version>${jib-maven-plugin.version}</version>
    <configuration>
        <from>
            <image>${docker-mirror-address}shijianjs/openjdk:8-alpine</image>
        </from>
        <to>
            <image>${docker-registry-address}/${project.groupId}/${project.artifactId}</image>
            <tags>
                <tag>${project.version}</tag>
                <tag>${project.version}.${jenkins.buildNumber}</tag>
                <tag>${jenkins.buildTag}</tag>
            </tags>
        </to>
        <container>
            <entrypoint>
                <entry>sh</entry>
                <entry>/app/resources/config/start.sh</entry>
            </entrypoint>
            <ports>
                <port>20880</port>
            </ports>
            <useCurrentTimestamp>true</useCurrentTimestamp>
        </container>
        <allowInsecureRegistries>true</allowInsecureRegistries>
        <extraDirectory>
            <path>${project.basedir}/target/docker-root</path>
        </extraDirectory>
    </configuration>
</plugin>
```

启动命令，这句话有点长，所以从 `pom.xml` 里面提取出来了

`start.sh`的内容：
```bash
#!/usr/bin/env bash

set -xe
source /app/resources/config/$properties_profile/logback-config.sh

java \
-javaagent:/app/skywalking/skywalking-apm-sniffer/skywalking-agent.jar \
-Dskywalking_config=/app/resources/config/$properties_profile/skywalking-agent.properties \
$ENV_JAVA_OPTS \
-cp /app/resources:/app/classes:/app/libs/* \
com.alibaba.dubbo.container.Main

```
说明：
`set -x`打印当前执行的命令 
`set -e`遇到报错退出

关于`$properties_profile`，这是一个环境变量，在运行时设置一个环境变量进去，如 `dev`、`test`、`uat`等，分别对应几套已经写好的配置；
如果是一个全新的环境，没有预定义配置，可以通过文件挂载的方式，新创建配置文件挂载到指定路径。

spring配置文件xml中，表达式 `${properties_profile:local}` 是可以取到`context:property-placeholder`、java的`-D`参数、操作系统环境变量的。
这么写可以设置以上所有地方都取不到变量时的默认值：`${properties_profile:local}`


#### 基础镜像
添加一些必要的软件，微软字体，时区支持，设置中国时区
```docker
FROM openjdk:8-alpine

ENV TZ Asia/Shanghai

RUN apk add --no-cache -U tzdata msttcorefonts-installer fontconfig ttf-dejavu
RUN update-ms-fonts && fc-cache -f
```

## faq

#### Q: java应用不能jmap
基础镜像换成官方默认debian的，解决apline jdk镜像不能jmap、jstack等1进程的问题
