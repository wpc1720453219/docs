# Kotlin

- [Kotlin官网](https://kotlinlang.org/)
- [Kotlin中文网](https://www.kotlincn.net/)
    - [关键字与操作符](https://www.kotlincn.net/docs/reference/keyword-reference.html)
- [SidneyXu/JGSK 项目 Java,Groovy,Scala,Kotlin 四种语言的特点对比](https://github.com/SidneyXu/JGSK)
- [Kotlin菜鸟教程](https://www.runoob.com/kotlin/kotlin-tutorial.html)
- [Awesome Kotlin (https://kotlin.link)](https://kotlin.link/)
    - [github: KotlinBy/awesome-kotlin](https://github.com/KotlinBy/awesome-kotlin)
## spring
- [spring 官方 kotlin 支持文档](https://docs.spring.io/spring/docs/current/spring-framework-reference/languages.html#kotlin)
    - [webflux/reactor 与 coroutines 的转换、互操作](https://docs.spring.io/spring/docs/current/spring-framework-reference/languages.html#coroutines)
- [spring-boot-kotlin 官方demo](https://github.com/spring-guides/tut-spring-boot-kotlin)
    - 针对spring boot示例的内容点比较全面，可以参考
- [Building web applications with Spring Boot and Kotlin](https://spring.io/guides/tutorials/spring-boot-kotlin/)
    - spring 官方文字教程
- [webflux的官方文档，每段代码示例都包含java+kotlin](https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html)

### webflux
1. [spring: Going Reactive with Spring, Coroutines and Kotlin Flow](https://spring.io/blog/2019/04/12/going-reactive-with-spring-coroutines-and-kotlin-flow)
1. [Kotlin Coroutine 初探](https://www.jianshu.com/p/2d2e21941461)
    - 里面有结合spring webflux，二者间做了很多适配工作，二者搭配起来，基本上能做到实现比async/await关键字稍弱一档的逻辑，
        但比原生webflux的一排排高阶函数回调要好上太多。
    1. [Kotlin Coroutine 是如何与 Spring WebFlux 整合的](https://www.jianshu.com/p/17d93f1afc50)
    1. [JVM 上的协程，真香](https://www.v2ex.com/t/514615)
1. baeldung教程
    1. [Non-Blocking Spring Boot with Kotlin Coroutines](https://www.baeldung.com/spring-boot-kotlin-coroutines)
    1. [Spring Webflux with Kotlin](https://www.baeldung.com/spring-webflux-kotlin)
    1. [Reactive Flow with MongoDB, Kotlin, and Spring WebFlux](https://www.baeldung.com/kotlin-mongodb-spring-webflux)
    1. [Kotlin Reactive Microservice With Spring Boot](https://www.baeldung.com/spring-boot-kotlin-reactive-microservice)

## GraphQL
1. [GraphQL](https://graphql.cn/)
1. [GraphQL Kotlin](https://expediagroup.github.io/graphql-kotlin/docs/getting-started.html)
1. [Schema Generator](https://expediagroup.github.io/graphql-kotlin/docs/schema-generator/schema-generator-getting-started)
    - 可以根据类自动生成Schema，免了再写一遍定义的麻烦，是的GraphQL的使用成为可能。之前不看好主要是因为要多一步很麻烦的定义操作，相比之下，json几乎是完全自动化的。
1. [支持 Coroutines](https://expediagroup.github.io/graphql-kotlin/docs/schema-generator/execution/async-models)
1. [一个示例：GraphQL and Spring Webflux](https://github.com/geowarin/graphql-webflux)
## 语法特性
1. [与 Java 语言比较](https://www.kotlincn.net/docs/reference/comparison-to-java.html)
1. [与 Scala 比较【官方已删除】](https://www.kotlincn.net/docs/reference/comparison-to-scala.html)

基本可以看作java+，scala-

主要是和java的对比；

以下这些东西大部分是语法糖，java下也可以实现的，但就像这些情况
- java8 lambda表示式出现前，用匿名内部类实现
- lombok引入前


语法特性：
- 数据类
- 模板字符串
- 多行字符串
- 解构
```kotlin
// 数据类
data class Customer(var name:String,var email:String,var friends:ArrayList<String>)
val peter = Customer("Peter","peter@example.com", arrayListOf("Jane","Tom"))
// 解构
val (name,email) = peter
// 模板字符串
println("name=$name,email=$email")
```
- 闭包
    - 有类型推断，
    - 无需声明一堆、一长串类型，
        - 反例：[借助Java 8实现柯里化](https://www.jianshu.com/p/c623b8b2aec8)
- 函数是一等公民
    - 可以在任意地方声明函数
- 增强版switch
- [尾递归优化](https://www.jianshu.com/p/400c87a8c632)
    - tailrec修饰方法

```kotlin
fun show2(prefix: String) = { msg: String ->
    { postfix: String -> prefix + msg + postfix }
}
println("""show2("(")("foobar")(")") => ${show2("(")("foobar")(")")}""")
```

## 协程coroutines
1. [coroutines中文文档](https://www.kotlincn.net/docs/reference/coroutines/coroutines-guide.html)
1. [kotlinx.coroutines各子包官方参考手册](https://kotlin.github.io/kotlinx.coroutines/)

1. [支持类似上下文的threadLocal操作](https://www.kotlincn.net/docs/reference/coroutines/coroutine-context-and-dispatchers.html#%E7%BA%BF%E7%A8%8B%E5%B1%80%E9%83%A8%E6%95%B0%E6%8D%AE)
    - 有提及MDC 集成
    - 局部变量的变化传播有限制，在threadLocal里面尽量使用在这个调用操作内稳定的值
1. [coroutines 自带反应式流操作](https://www.kotlincn.net/docs/reference/coroutines/flow.html)

### log线程名
使用 -Dkotlinx.coroutines.debug JVM 参数运行；
当 JVM 以 -ea 参数配置运行时，调试模式也会开启。 
你可以在 DEBUG_PROPERTY_NAME 属性的文档中阅读有关调试工具的更多信息。 满
足这两个条件时，log线程会显示协程名字

### 调用阻塞操作
[Kotlin - “Inappropriate Block Method Call” when making Bluetooth Connection inside Coroutine](https://stackoverflow.com/a/60625413)

```kotlin
suspend fun initSocket() = withContext(Dispatchers.IO) { ... }
```

```kotlin
suspend fun <T> LdapRepository<T>.findAllAsync(ldapQuery: LdapQuery): Iterable<T> = withContext(IO) {
    findAll(ldapQuery)
}
// 这种表达方式与上面那种等价
suspend fun <T, ID, S : T> CrudRepository<T, ID>.saveAsync(entity: S): S = GlobalScope.async(Dispatchers.IO) {
    save(entity)
}.await()
```

### 阻塞点检测
1. [kotlinx-coroutines-debug包有做BlockHound支持](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-debug/)
1. [Integration with BlockHound in kotlinx-coroutines-debug module (#1821, #1060).](https://github.com/Kotlin/kotlinx.coroutines/releases/tag/1.3.6)

### kotlinx-coroutines-slf4j
[Add MDCContext to the coroutine context](https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-slf4j/)
添加了`MDC`的支持。

## 备忘
[关键字与操作符](https://www.kotlincn.net/docs/reference/keyword-reference.html)
### 类的修饰符
类的修饰符包括 classModifier 和 accessModifier:
- classModifier: 类属性修饰符，标示类本身特性。
```kotlin
abstract    // 抽象类  
final       // 类不可继承，默认属性
enum        // 枚举类
open        // 类可继承，类默认是final的
annotation  // 注解类
```
- accessModifier: 访问权限修饰符
```kotlin
private    // 仅在同一个文件中可见
protected  // 同一个文件中或子类可见
public     // 所有调用的地方都可见
internal   // 同一个模块中可见
```

## faq
### 关于log
java的lombok @Slf4j 用习惯了，但lombok注解在kotlin下不生效。

[MicroUtils/kotlin-logging](https://github.com/MicroUtils/kotlin-logging)
[Awesome](https://kotlin.link/?q=log)

#### kotlin-logging方案更好，这个弃用
略微简单些的方案：[Implement @slf4j annotation from Lombok in Kotlin](https://stackoverflow.com/questions/60419699/implement-slf4j-annotation-from-lombok-in-kotlin)
```kotlin
@RestController
@RequestMapping("/api/v1/sample")
class SampleController() {
    private val log = logger()

    @GetMapping
    fun show(): String {
        log.info("SOME LOGGING MESSAGE")
        return "OK"
    }
}

inline fun <reified T> T.logger(): Logger {
    if (T::class.isCompanion) {
        return LoggerFactory.getLogger(T::class.java.enclosingClass)
    }
    return LoggerFactory.getLogger(T::class.java)
}
```
[kotlin log](https://www.jianshu.com/p/ded857850072)
 

