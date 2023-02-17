# 问题解决备忘

### Jenkins自带的用户权限管理功能少，粒度不够细

[Role Strategy Plugin](https://wiki.jenkins.io/display/JENKINS/Role+Strategy+Plugin)

参考文章：[Jenkins 不同角色不同视图及不同权限设置](https://blog.csdn.net/lipei1220/article/details/78623226)



### jenkins的shell起的后台进程被杀死

设置环境变量
```bash
BUILD_ID=DONTKILLME
```

参考：[jenkins中通过execute shell启动的进程会被杀死的问题](<https://blog.csdn.net/u011138533/article/details/53941123>)



### `|` 管道符在jenkins页面写shell被转义

复杂的命令写shell脚本文件，jenkins只用来调用脚本



### 标记构建的版本号

每次构建都带一系列环境变量，`$BUILD_TAG` 等，可用来标记版本号。

更多环境变量参考：[env-vars](./env-vars.md)

### 使用`Send files or execute commands over SSH`在远程启动时，`.sh`脚本文件取不到jenkins的环境变量，比如`$BUILD_TAG`

把jenkins环境变量以shell脚本参数的形式，在命令行里面传过去。

比如：
`Exec command`里面填写：
```bash
/data/test-tmp/start.sh $BUILD_TAG
```
`start.sh`文件内容：
```bash
#! /bin/sh
set -xe
BUILD_TAG=$1

echo $BUILD_TAG
```

### 使用[Publish Over SSH](http://wiki.jenkins-ci.org/display/JENKINS/Publish+Over+SSH+Plugin)执行脚本时，脚本里面写了 `BUILD_ID=DONTKILLME` 但没起作用，进程开始被杀掉

这个变量需要在jenkins的命令框里面声明，在远程脚本的地址声明无效。
```bash
BUILD_ID=DONTKILLME && /data/luna/test/usercore/start.sh $BUILD_TAG
```

### 一个启动jar包的脚本示例
```bash
#!/bin/sh
# 命令执行出错退出，打印执行的每行命令
set -xe

# 取参数
BUILD_TAG=$1

# 子进程不被jenkins杀死
BUILD_ID=DONTKILLME

# 获取进程号，杀进程
appid=$(ps -ef |grep '/data/luna/test/usercore/usercore-provider-1.0.0-SNAPSHOT-' |grep -v grep | awk '{print $2}')
echo $appid
if [ $appid -ne 0 ];
then
echo 'enter......' 
ps -ef |grep '/data/luna/test/usercore/usercore-provider-1.0.0-SNAPSHOT-' |grep -v grep | awk '{print $2}'| xargs kill -9
fi

# 把jar包移到合适的位置
mv /data/luna/test/usercore/usercore-provider/target/usercore-provider-1.0.0-SNAPSHOT.jar /data/luna/test/usercore/usercore-provider-1.0.0-SNAPSHOT-$BUILD_TAG.jar

# 真正的启动命令
nohup java -Xms512m -Xmx512m -Dspring.profiles.active=fat -Denv=fat -javaagent:/data/luna/test/skywalking/apache-skywalking-apm-bin/agent/skywalking-agent.jar -Dskywalking.agent.namespace=luna_test -Dskywalking.agent.service_name=luna_test_usercore -Dskywalking.agent.span_limit_per_segment=30000 -Dskywalking.collector.backend_service=127.0.0.1:11800 -Dskywalking.logging.level=INFO -jar /data/luna/test/usercore/usercore-provider-1.0.0-SNAPSHOT-$BUILD_TAG.jar >>  /data/luna/test/usercore/out.log 2>&1 & 
echo "started successfully"

```


### 解决jenkins运行磁盘满的问题
[解决jenkins运行磁盘满的问题](https://blog.csdn.net/ling811/article/details/74991899)

### 一个新建的任务没构建按钮
新建一个任务，需要在随后弹出的配置页面点击保存，才会出现构建运行按钮。

### 取不到环境变量
[jenkins执行shell读不到环境变量问题](https://blog.csdn.net/qq_33873431/article/details/80348561)

### 构建前清理上次构建的所有东西
勾选上`构建环境` -> `Delete workspace before build starts`，会在构建前清理工作空间，包括拉的代码，效果类似`rm -rf .`

### 批量清理历史构建
登录Jenkins -> Manage Jenkins -> Script Console(脚本命令行)
执行如下命令：
```groovy
import hudson.tasks.LogRotator

def jobs =   Jenkins.instance.allItems(Job)
jobs.findAll({it.name.startsWith("tfp")})
.each { println("${it}  ${it.builds.number} ${it.supportsLogRotator()}") }
.each { job ->
  println "$job.builds.number $job.name"
  if ( job.isBuildable() && job.supportsLogRotator()) {
      job.setLogRotator(new LogRotator ("", "2", "", "2"))
      job.logRotate() //立马执行Rotate策略
    println "$job.builds.number $job.name 磁盘回收已处理"
  } else { println "$job.name 未修改，已跳过" }
}
```
> 参考：[快速批量删除Jenkins构建清理磁盘空间并按参数保留最近构建](https://blog.csdn.net/liliwang90/article/details/104690491)
> - [LogRotator](https://javadoc.jenkins.io/hudson/tasks/LogRotator.html)

