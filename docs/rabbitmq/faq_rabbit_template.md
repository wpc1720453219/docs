# Spring amqp 使用faq

### spring amqp 1.3.5 使用碰到的问题总结

#### 消费端默认的Reject

rabbitmq的消费端失败，默认会Rejecting掉消息，如果这个是业务代码逻辑上的异常，也就是说这条消息每次执行都会异常，那么这个会无限循环

#### 为各消息单独设置超时时间

可以为某条消息设置单独的超时时间，这样这个参数就不用固定在队列上面了：

org.springframework.amqp.core.MessageBuilderSupport#setExpiration

#### 设置消息头（类似http的请求头）

使用MessagePostProcessor处理rabbitTemplate的消息

```java
public void send(TradeRequest tradeRequest) {
    getRabbitTemplate().convertAndSend(tradeRequest, new MessagePostProcessor() {
        public Message postProcessMessage(Message message) throws AmqpException {
            message.getMessageProperties().setReplyTo(new Address(defaultReplyToQueue));
            try {
                message.getMessageProperties().setCorrelationId(
                    UUID.randomUUID().toString().getBytes("UTF-8"));
            }
            catch (UnsupportedEncodingException e) {
                throw new AmqpException(e);
            }
            return message;
        }
    });
}
```

