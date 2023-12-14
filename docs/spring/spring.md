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