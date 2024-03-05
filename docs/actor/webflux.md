# webflux
1. [Web on Reactive Stack 官方文档](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html)
    - 基本上webflux上面遇到的所有问题，都能在这里找到最原始的解决办法，算是一个教全面的教程；这个是看帖子、博客、百度之类的做不到的。
    1. [Annotated Controllers 注解controller写法的webflux文档](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html#webflux-controller)
1. [响应式Spring的道法术器（Spring WebFlux 教程）](https://blog.csdn.net/get_set/article/details/79466657)
1. [芋道 Spring Boot 响应式 WebFlux 入门](http://www.iocoder.cn/Spring-Boot/WebFlux/)

## Reactor
webflux是基于Reactor的。
1. [Reactor](https://projectreactor.io/)
1. [官方系列文档](https://projectreactor.io/docs)
1. [reactor github](https://github.com/reactor/reactor-core)
1. [Spring Reactor 3 中文文档](http://devops.gitlab.xyyweb.cn/docs/actor/spring-reactor-core-zh-doc/reference.html)
    - 较旧，有些错误，但能看
    1. [中文文档 远程](http://htmlpreview.github.io/?https://github.com/get-set/reactor-core/blob/master-zh/src/docs/index.html)
1. [如何包装一个同步阻塞的调用？](http://devops.gitlab.xyyweb.cn/docs/actor/spring-reactor-core-zh-doc/reference.html#faq.wrap-blocking)
    - 实在没办法改动的同步阻塞变异步教程
1. [BlockHound：Project Reactor阻塞检测技术](https://github.com/reactor/BlockHound)

## jpa
1. [Hibernate Reactive 官方项目](https://github.com/hibernate/hibernate-reactive)
    - [如果要在 Spring webflux 和 Vert.x web 选一个，在不仅仅只考虑性能的情况下，选哪一个](https://v2ex.com/t/673714)
1. 几个小demo，维护不活跃
    1. [Spring WebFlux with JPA](https://github.com/rxonda/webflux-with-jpa)
    1. [reactive-jpa IBM](https://github.com/IBM/reactive-components)
        - 真要做些封装的话可以参考这个，或直接使用
    1. 里面提及，jpa是阻塞的，只能通过webflux的包装一层非阻塞调度器，即多线程来实现，
    [jdbc可以用单独的调度器，线程池里的个数和jdbc连接数相同](https://github.com/chang-chao/spring-webflux-reactive-jdbc-sample) 。


[如果要在 Spring webflux 和 Vert.x web 选一个，在不仅仅只考虑性能的情况下，选哪一个](https://v2ex.com/t/673714)
同步方式很好描述的逻辑，异步就未必直观了，比如
```js
for (i=0,n=0; i<10; i++) {
n = test(n, i);
if (n == 0) contine;
if (n == 1) n = test2(n, i);
if (n == 3) break;
n = test3(n, i);
}
```
每个 test 都是调用的第三方服务，转化成异步写法比较晦涩，这还只是简单的例子，实际 context 上的局部变量有很多个，回调和 promise 写法，需要自己维护这个 context，协程是系统帮你维护。协程只是增加一个选择，并不妨碍适合 rx 的地方继续 rx 。

## R2DBC
貌似现在最重头的同步阻塞过程jdbc都有反应式支持了

1. [R2DBC](https://r2dbc.io/)
1. [spring-data/r2dbc文档](https://docs.spring.io/spring-data/r2dbc/docs/1.1.0.RC1/reference/html/#reference)

## 支持webflux的新版swagger
直接引入3.0.0+ 的springfox-boot-starter，不做任何配置就可以获取webflux的支持。
```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-boot-starter</artifactId>
    <version>3.0.0</version>
</dependency>
```
1. [springfox 官方 demo](https://github.com/springfox/springfox-demos)
1. [springfox github 有最新版文档介绍](https://github.com/springfox/springfox)
1. [springfox swagger 官方文档](http://springfox.github.io/springfox/docs/current/)
    1. [注解详细说明](http://springfox.github.io/springfox/docs/current/#property-file-lookup)

swagger的页面地址是`/swagger-ui`

## webflux index.html问题
需求：把`/`解析为`/index.html`。
1. [Spring Webflux, How to forward to index.html to serve static content](https://stackoverflow.com/questions/45147280/spring-webflux-how-to-forward-to-index-html-to-serve-static-content)

## webflux websocket
1. [WebFlux定点推送、全推送灵活websocket运用](https://blog.csdn.net/qq_18537055/article/details/98681154)
1. [webflux的websocket连接与生命周期](https://blog.csdn.net/sinat_39291367/article/details/89467555)
    - 可以用来处理一些错误、关闭事件导致的状态改变等

## Web Security
1. [Web Security](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html#webflux-web-security)
1. [spring-security 在 spring webflux中的使用](https://blog.csdn.net/joker_2007/article/details/82736183)
    - 同样可以用类似的方法解决spring cloud gateway的问题

## feign-reactive
1. [feign-reactive](https://github.com/Playtika/feign-reactive)
    1. [对应的maven包](https://mvnrepository.com/search?q=feign-reactor&sort=relevance)

## faq

### Q: 线程数、阻塞处理相关

运行时默认一共有和cpu数量一样的线程数接管请求，比如4核8线程的电脑，webflux默认处理请求的线程是8个，
超过这个数量的阻塞处理，就会阻塞掉整个应用；

最外层用了webflux进入系统，里面一定要用非阻塞的写法，阻塞操作用Mono官方示例的方式封装，放在elastic调度器。

### Q: idea开启阻塞点检测
`文件` → `设置` → `编辑器` → `检查` → `JVM languages | Inappropriate thread-blocking method call`
> idea 2020以上有官方中文界面支持
