# 延时队列
通过Rabbitmq插件`rabbitmq_delayed_message_exchange`，使用java代码实现。

相对于死信队列的好处：
1. 实现简单
    - 不用再做多个队列的死信转发配置，设置一个属性即可
2. 功能支持完整
    - 消息级的自由定义时间延迟，而[死信队列的`expiration`](https://www.rabbitmq.com/ttl.html#per-message-ttl-in-publishers)只有[将要消费的第一个消息才做判定](https://www.rabbitmq.com/ttl.html#per-message-ttl-caveats)，在逻辑上有问题。
3. spring amqp api的原生支持

## 链接
1. [rabbitmq 插件](https://www.rabbitmq.com/community-plugins.html)
1. [RabbitMQ Delayed Message Plugin 插件的github与使用说明](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange)
1. [支持rabbitmq 3.7~3.8的插件下载页面](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/tag/v3.8.0)

## 安装插件
1. 在对应版本的插件下载页面下载插件文件`rabbitmq_delayed_message_exchange-3.8.0.ez`，
2. 放到rabbitmq的安装目录的`plugins`文件夹里面，
3. 在安装目录的sbin文件夹，执行
```
rabbitmq-plugins enable rabbitmq_delayed_message_exchange
rabbitmq-plugins list
```
4. 重启rabbitmq

## spring amqp下的用法
原始用法参考官方github文档，这里只介绍spring rabbitTemplate下的用法。
demo项目地址[mq-demo](http://gitlab.xyyweb.cn/sunht/mq-demo)，
关于延时队列的内容都在包`com.example.sht.mq.mqdemo.wait`里面，
测试方法`com.example.sht.mq.mqdemo.wait.MessageWaitTest#testDelay`

其他和普通的rabbitmq队列写法相同，只有这两个地方设置两个属性即可。
交换机声明：
```java
@Bean
public DirectExchange delayExchange(RabbitAdmin rabbitAdmin) {
    DirectExchange exchange = new DirectExchange(delayExchangeName);
    exchange.setAdminsThatShouldDeclare(rabbitAdmin);
    // 在这里设置交换机的属性为延时，在管理界面可以看到Type是x-delayed-message
    exchange.setDelayed(true); 
    return exchange;
}
```
设置消息的延迟时间，单位是毫秒。
```java
private void sendToDelay(WaitMessage ldWsMessage, final int waitTime) {
    delayRabbitTemplate.convertAndSend(waitConsumerQueueName, ldWsMessage, message -> {
        // 在这里设置具体消息的延迟时长
        message.getMessageProperties().setDelay(waitTime);
        //System.out.println(message.getMessageProperties().getHeaders());
        return message;
    });
}
```
