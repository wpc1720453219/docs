### bean的作用范围[scope]
1. singleton【spring bean默认范围】  
    1. 单例，一个bean容器里 获取对应的bean时都会是同一个bean
    2. 单例模式是整个jvm只有一个对象，而spring中singleton类型的bean则是表示在对应的bean容器中只会拥有一个对应的bean实例
       但一个项目定义多个不同的bean容器 生成同一个singleton类型的bean，不是同一个bean 变成多例  
       又或者我们在同一个bean容器中将同一个类型的bean定义多次，其也会拥有多个不同的实例， hello对象与hello1对象不同
         ```shell
        <bean id="hello" class="com.elim.learn.spring.bean.Hello"/>
        <bean id="hello1" class="com.elim.learn.spring.bean.Hello" scope="singleton"/>
        ```
     3.  在Spring内部，当我们把一个bean定义singleton时，Spring在实例化对应的bean后会将其缓存起来，然后在之后每次需要从bean容器中
        获取对应的bean时都会从缓存中获取，这也就是为什么定义为singleton的bean每次从bean容器中获取的都是同一个的原因

2. prototype 
   1. 多例，每次从bean容器中获取对应bean实例时都将获取一个全新的实例
   2. 当bean定义为prototype时，Spring将只会回调对应bean定义的初始化方法【因为创建新的实例随便执行了】，而对于销毁方法，Spring是不会进行回调的
      因为新创建的实例在Spring不会保留，所以它拿不到，也就不会进行回调
   3. singleton类型的bean里有prototype【或者其他类型】的bean.在创建的时候缓存里保留当前创建的状态的bean.即prototype类型 也变成单例的bean
    ```java
        public class Hello {
        
            private World world;
            public World getWorld() {
                return this.world;
            }
            public void setWorld(World world) {
                this.world = world;
            }
        }
   @org.junit.Test
	public void test() {
		Hello hello = context.getBean("hello", Hello.class);
		World w1 = hello.getWorld();
		World w2 = hello.getWorld();
		System.out.println(w1 == w2); //true
	}
     ```
3. request
   1. WEB 项目中,Spring 创建一个 Bean 的对象,将对象存入到 request 域中
   2. 在每一个HttpRequest生命周期内从bean容器获取到的对应bean定义的实例都是同一个实例，而不同的HttpRequest所获取到的实例是不一样的  
> 如果我们拥有一个singleton类型的 beanA，然后其需要被注入一个request类型的beanB时，如果我们在对beanA进行定义时就定义好了其对beanB的依赖。  
则由于Spring默认会在初始化bean容器后立即对单例类型的bean进行实例化，进而导致会实例化其所依赖的其它bean，也就是说在实例化beanA的时候，  
会进而实例化beanB。但此时是没有HttpRequest请求的，也就是说没有Web环境的，那么Spring将无法实例化beanB，其会抛出异常。  
处理方法:  
指定beanA为懒初始化，这样Spring在bean容器初始化完成后默认不会对其进行实例化，只有在需要被使用的情况下才会被初始化

4. session
   1. WEB 项目中,Spring 创建一个 Bean 的对象,将对象存入到 session 域中
   2. 同一session环境下，不管你从bean容器中获取对应bean定义的实例多少次，你取到的总是一个相同的实例
5. global-session：作用于集群环境的会话范围（全局会话范围），当不是集群环境时，它就是session

### bean的生命周期
所谓的生命周期就是：对象从创建开始到最终销毁的整个过程  
（1）Bean生命周期的管理，可以参考Spring的源码：AbstractAutowireCapableBeanFactory类的doCreateBean()方法   
（2）Bean生命周期可以划分为十大步：   
 * 第一步： 实例化Bean
 * 第二步： Bean属性赋值
 * 第三步： 检查Bean是否实现了Aware的相关接口，并设置相关依赖
 * 第四步： **Bean后处理器 before 执行**
 * 第五步： 检查Bean是否实现InitializingBean接口，并调用接口方法
 * 第六步： 初始化Bean
 * 第七步： **Bean后处理器 after 执行**
 * 第八步： 使用Bean
 * 第九步： 检查Bean是否实现了DisposableBean接口，并调用接口方法
 * 第十步： 销毁Bean


* bean 对象的生命周期：  
    1. singleton(单例):   
        1. Spring 能够精确地知道该Bean何时被创建，何时初始化完成，以及何时被销毁  
        2. 单例对象的生命周期和bean容器相同  
    2. 多例对象(scope="prototype")  
        每次访问对象时，都会重新创建对象实例。  
        生命周期：  
        1. Spring只负责创建,当容器创建Bean的实例后，Bean的实例就交给客户端代码管理，Spring容器将不再跟踪其生命周期  
        2. 对象出生：当使用对象时，创建新的对象实例。  
        3. 对象活着：只要对象在使用中，就一直活着。  
        4. 对象死亡：当对象长时间不用时，被 java 的垃圾回收器回收了。 

### 注解
#### 创建bean
Component:
```shell
作用：用于把当前类对象存入spring容器中
属性：
     value：用于指定 bean的id。当我们不写时，它的默认值是当前类名，且首字母改小写。
     Controller：一般用在表现层
     Service：   一般用在业务层
     Repository：一般用在持久层
     以上三个注解他们的作用和属性与Component是一模一样。 三个注解里只有value且都是指定bean的id
```
#### 注入bean对象  
@Autowired  
* 作用： 自动按照类型注入，只要容器中有唯一的一个bean对象类型和要注入的变量类型匹配，就可以注入成功
    * 如果ioc容器中没有任何bean的类型和要注入的变量类型匹配，则报错
    * 如果Ioc容器中有多个类型匹配时,需要结合@Qualifier，不然启动项目报错【亲手实验过】
* 出现位置：
    * 可以是变量上，也可以是方法上
* 细节：
    * 在使用注解注入时,set方法就不是必须的了
```shell
Autowired 注解 源码
			@Target({ElementType.CONSTRUCTOR, ElementType.METHOD, ElementType.PARAMETER, ElementType.FIELD, ElementType.ANNOTATION_TYPE})
			@Retention(RetentionPolicy.RUNTIME)
			@Documented
			public @interface Autowired {
				boolean required() default true;
			}
    required属性
		@Autowired(required=true)：当使用@Autowired注解的时候，其实默认就是@Autowired(required=true)，表示注入的时候，该bean必须存在，否则就会注入失败
		@Autowired(required=false)：表示忽略当前要注入的bean，如果有直接注入，没有跳过，不会报错。			
```

@Qualifier
* 作用：在按照类中注入的基础之上再按照名称注入。它在给类成员注入时不能单独使用。但是在给方法参数注入时可以可以独立使用  
  * 属性： value：用于指定注入bean的id  
```shell
        public interface IpfProductService
			@service ("pfProductservice1")
			public class PfProductServicel implements IPfProductservice
			@service ("pfProductservice2")
			public class PfProductServicel implements IPfProductservice
			@Qualifier("pfProductService1")   //通过这个标示，表明了哪个实现类才是我们所需要的,添加@Qualifier注解,需要注意的是@Qualifier的参数名称为我们之前定义@Service注解的名称之一
			IPfProductService pfProductService;
```

@Resource
* 作用：直接按照bean的id注入。它可以独立使用  
     * 属性： name：用于指定bean的id  

区别：
@Autowired是按照先byType 后 byName @Resources是按照先byName后byType
@Qualifier: spring的注解，按名字注入 一般当出现两个及以上bean时,不知道要注入哪个，作为@Autowired()的修饰用  

### 其他注解
@Configuration  
指定当前类是一个配置类,因为@Configuration注解里继承@Component，所以这个类会加入spring容器。但这个配置类里的方法生成的对象还是需要用@Bean注解加载到spring容器 
@Configuration标识的配置类中，重复调用@Bean标识的工厂方法，Spring会对创建的对象进行缓存。仅在缓存中不存在时，
才会通过工厂方法创建对象。后续重复调用工厂方法创建对象，先去缓存中找，不直接创建对象。从而让@Bean工厂方法，有了"幂等的能力"
[@Configuration配置类](https://blog.csdn.net/m0_71777195/article/details/128797965)  

@Bean
```shell
作用：用于把当前方法的返回值作为bean对象存入spring的ioc容器中
属性:
     name:用于指定bean的id。当不写时，默认值是当前方法的名称
细节：
     当我们使用注解配置方法时，如果方法有参数，spring框架会去容器中查找有没有可用的bean对象。
     查找的方式和Autowired注解的作用是一样的
```

@Import
让导入的类里的方法 变成 被@Bean的方法加载到spring容器里，说白了就是导入的类里的方法生成的对象加载到spring 容器里  
[@Import注解把类注入容器的四种方式](https://blog.csdn.net/qq_45076180/article/details/119653676)  






