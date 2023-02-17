# java代码端使用

## 版本

基于skywaling的版本`${skywalking.version}`：`6.3.0`

## Maven依赖
```xml
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-trace</artifactId>
    <version>${skywalking.version}</version>
</dependency>
```

## 获取当前`traceId`
```java
import org.apache.skywalking.apm.toolkit.trace.TraceContext;

String traceId = TraceContext.traceId()
```
还有为trace添加自定义信息等操作，参考：[Application-toolkit-trace](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Application-toolkit-trace.md)

## 为方法手动添加trace
方法添加`@Trace`注解即可，适用于skywalking插件监控不到的方法，比如netty。
```java
@Trace
public void doSomeThing(SomeParam param){
    //your code
}
```
#### 高级用法
不建议使用这个，推荐使用上面那个添加注解的方式。
使用skywalking提供的[`OpenTracing` api](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Opentracing.md)。

maven依赖：
```xml
<dependency>
    <groupId>org.apache.skywalking</groupId>
    <artifactId>apm-toolkit-opentracing</artifactId>
    <version>${skywalking.version}</version>
</dependency>
```
```java
Tracer tracer = new SkywalkingTracer();
Tracer.SpanBuilder spanBuilder = tracer.buildSpan("/yourApplication/yourService");
```


## logback普通行日志

> 参考：[Application-toolkit-logback](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Application-toolkit-logback-1.x.md)

`logback.xml`里面的layout裹一层skywalking的工具。

pom依赖：
```xml
<dependency>
     <groupId>org.apache.skywalking</groupId>
     <artifactId>apm-toolkit-logback-1.x</artifactId>
     <version>${skywalking.version}</version>
</dependency>
```
```xml
<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <encoder class="ch.qos.logback.core.encoder.LayoutWrappingEncoder">
        <layout class="org.apache.skywalking.apm.toolkit.log.logback.v1.x.TraceIdPatternLogbackLayout">
            <Pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%tid] [%thread] %-5level %logger{36} -%msg%n</Pattern>
        </layout>
    </encoder>
</appender>
```
logback向elk打日志参考下面`logstash-logback-traceid-encoder`

## 跨线程
两种用法：
> 参考：[trace cross thread](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Application-toolkit-trace-cross-thread.md)

### 注解`@TraceCrossThread`
在`Callable`、`Runnable`的实现类上面添加`@TraceCrossThread`注解：
```java
@TraceCrossThread
public static class MyCallable<String> implements Callable<String> {
    @Override
    public String call() throws Exception {
        return null;
    }
}
```
```java
ExecutorService executorService = Executors.newFixedThreadPool(1);
executorService.submit(new MyCallable());
```

### 包装`Callable`、`Runnable`
使用`CallableWrapper`包装`Callable`，适合lambda表达式
```java
ExecutorService executorService = Executors.newFixedThreadPool(1);
executorService.submit(CallableWrapper.of(new Callable<String>() {
    @Override 
    public String call() throws Exception {
        return null;
    }
}));
```

使用`RunnableWrapper`包装`Runnable`：
```java
ExecutorService executorService = Executors.newFixedThreadPool(1);
executorService.execute(RunnableWrapper.of(new Runnable() {
    @Override 
    public void run() {
        //your code
    }
}));
executorService.execute(RunnableWrapper.of(()->doSomething()));
```
