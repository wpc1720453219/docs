# ELK简要安装文档

#### 2.3.4.  Centos6不支持SecComp
对应报错：
```bash
system call filters failed to install; check the logs and fix your configuration or disable system call filters at your own risk
```
原因：
这是在因为Centos6不支持SecComp，而ES5.2.0默认bootstrap.system_call_filter为true进行检测，所以导致检测失败，失败后直接导致ES不能启动。
解决：
在elasticsearch.yml中配置bootstrap.system_call_filter为false，注意要在Memory下面:
```yaml
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
```



#### 2.5.3.  集群配置

详细操作可参考：<https://www.cnblogs.com/kevingrace/p/7693422.html>



 

## 5.     结束 - ELK简要使用指南

至此，整个ELK服务环境搭建完成。

可以在java程序中把logback的logstash插件指向logstash中input的地址和端口，运行程序，输出log。

在浏览器kibana的界面，选择索引gardpaylog（刚才在logstash中配置的），即可看到日志：

![img](./images/clip_image008.jpg)

