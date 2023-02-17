# skywalking使用遇到问题汇总

## 官方fap
[skywalking FAQs](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/FAQ/README.md)

## 之前遇到的问题

### tracdId没产生
可能有以下情况：
1. 插件不支持
    - 检查[插件支持列表](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Supported-list.md)
2. 比如像netty这样的自定义服务
    - 这个需要自己手动添加Trace，[一个很简单的实现方式](./use-in-java.md#为方法手动添加trace)
3. skywalking服务端没启动、或挂掉了、或连接断开了
    - 重启skywalking服务端，重启应用，再观察。
    
### traceId断开
代码走到某个地方，traceId断了，并且可能外部调用产生了一堆新的traceId

1. 单次操作的span数量过多（包括rpc、rest、jdbc等插件支持的调用），超过了`agent.span_limit_per_segment`参数设置的值，这个值默认是300。
    - 调大`agent.span_limit_per_segment`值，比如一般在应用启动参数设置`-Dskywalking.agent.span_limit_per_segment=30000`
2. 跨线程调用了，新的线程没被监控到
    - 跨线程调用传递traceId参考：[java代码端使用-跨线程](./use-in-java.md#跨线程)
3. 用了一些比较奇怪的调用方式，比如redis的队列
    - 这个不支持，如果用队列的话，可以使用RabbitMQ，或其他如Kafka、RocketMQ、ActiveMQ，这几个受支持的队列。
    
### 大量的agent grpc请求超时报错
可能的原因是es负载过重，导致响应很慢，蔓延到应用的探针。
- 解决：使用skywalking6，mysql数据库

### grpc异常：Channel ManagedChannelImpl was not shutdown properly
```yaml
ERROR o.a.s.a.d.i.g.i.ManagedChannelOrphanWrapper - *~*~*~ Channel ManagedChannelImpl{logId=1042418, target=xxxxx:xxxxx} was not shutdown properly!!! ~*~*~*
```
skywalking 5版本的bug，在6.1版已修复。
- [[Agent] can not connect to the collector maybe cause memory leak #2190](https://github.com/apache/skywalking/issues/2190)


### span数量过多导致traceId丢失
> skywalking遇到性能问题时需注意

一个场景，要处理一批交易，这一批有10000笔，每笔都有几次数据库操作，由于有数据库jdbc的监控，导致span数量很快超限`agent.span_limit_per_segment`，
而这个参数值是为了保护应用不会被一个监控的东西jvm内存撑爆的，不断增加这个上限显然不合理。

可以通过关闭掉一些无所谓的监控，比如jdbc、oracle这样的span。

### 大量出现 Ignored Trace
出现大量Ignored Trace很可能就是服务端挂了，或者探针没配置好服务端地址

[TraceContext.traceId() always return [Ignored Trace]](https://github.com/apache/skywalking/issues/3480)

> You need to find out why IgnoredTracerContext created. In my mind, either agent hasn't registered to backend successfully, or sampling/ignore mechanism is working. No other case.
