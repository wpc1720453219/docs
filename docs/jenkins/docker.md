# jenkins docker镜像相关
[jenkins X 所有的构建器](https://github.com/jenkins-x/jenkins-x-builders)

一些持续维护的镜像汇总：

最新的lts
```bash
docker pull jenkins/jenkins:lts
```

已经装好blueocean的lts
```bash
docker pull jenkinsci/blueocean
```

maven构建工具集
[github](https://github.com/jenkins-x/builder-maven.git)
```bash
docker pull jenkinsxio/builder-maven
```
```
[root@dcc563328020 jenkins]# mvn -version
Apache Maven 3.5.3 (3383c37e1f9e9b3bc3df5050c29c8aff9f295297; 2018-02-24T19:49:05Z)
Maven home: /opt/apache-maven-3.5.3
Java version: 1.8.0_191, vendor: Oracle Corporation
Java home: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-957.el7.x86_64", arch: "amd64", family: "unix"
```

基础构建工具集
[github](https://github.com/jenkins-x/builder-base.git)
```bash
docker pull jenkinsxio/builder-base
```
