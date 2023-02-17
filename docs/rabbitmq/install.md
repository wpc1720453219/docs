# RabbitMQ安装

`RabbitMQ`安装`3.1`以上的版本，我自己这边本地安装的版本是`3.7.15`。

## 链接
- [`Erlang`与`RabbitMQ`对应的版本号](https://www.rabbitmq.com/which-erlang.html)
- [RabbitMQ官网下载页面](https://www.rabbitmq.com/download.html)


## Centos 7 安装RabbitMQ

```bash
# 添加epel源，是centos软件包的补充
yum install -y epel-release
yum install rabbitmq-server erlang
rabbitmq-plugins list
# 开启网页管理界面插件，端口15672
rabbitmq-plugins enable rabbitmq_management
rabbitmq-server
```
注意：`yum install rabbitmq-server erlang`这一句里面，`rabbitmq-server`和`erlang`放一块儿，
yum会自动解析他们相互依赖的版本号。

### 其他功能：
#### 允许移动消息
```bash
rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management
```

## Windows安装RabbitMQ
下载erlang安装：<http://erlang.org/download/otp_win64_21.3.exe>

下载rabbitmq安装：
<https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.15/rabbitmq-server-3.7.15.exe>

打开cmd跳转到RabbitMQ的安装文件夹的`sbin`目录下：
```cmd
cd "C:\Program Files\RabbitMQ Server\rabbitmq_server-3.7.15\sbin"
```
打开网页管理界面插件，默认端口`15672`：
```cmd
rabbitmq-plugins enable rabbitmq_management
```
运行RabbitMQ，默认端口`5672`：
```cmd
rabbitmq-server
```

## faq
[linux centos7 环境下rabbitmqctl status报错](https://blog.csdn.net/k826240369/article/details/104281545)
