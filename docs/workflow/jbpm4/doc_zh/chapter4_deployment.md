# 第 4 章 部署业务归档

业务归档是一系列文件的集合 分发在一个jar格式的文件里。。 业务归档中的文件可以使jPDL流程文件，表单，类， 流程图和其他流程资源。

## 4.1. 部署流程文件和流程资源

流程文件和流程资源必须 部署到流程资源库里 并保存到数据库中。

这儿有一个jBPM的ant任务来部署业务流程归档 (`org.jbpm.pvm.internal.ant.JbpmDeployTask`)。 `JbpmDeployTask`可以部署 单独的流程文件和流程归档。 它们通过JDBC连接直接部署到数据库中。 所以在你部署流程之前 需要保证数据库正在运行。

创建和部署流程归档的例子 可以在发布包的examples目录下找到ant脚本（build.xml）。 让我们看一下相关部分。 首先，path用来声明包含jbpm.jar和它的所有依赖库。

```xml
<path id="jbpm.libs.incl.dependencies">
  <pathelement location="${jbpm.home}/examples/target/classes" />
  <fileset dir="${jbpm.home}">
    <include name="jbpm.jar" />
  </fileset>
  <fileset dir="${jbpm.home}/lib" />
</path>
```

你使用的数据库的JDBC驱动jar应该也包含在path中。 MySQL, PostgreSQL和HSQLDB的驱动都包含在发布包中。 但是oracle的驱动你必须从oracle网站上单独下载， 因为我们没有被允许重新分发这个文件。

当一个业务归档被发布时，jBPM扫描 业务归档中所有以`.jpdl.xml`结尾的文件。 所以那些文件会被当做jPDL流程解析，然后可以用在运行引擎中。 业务归档中所有其他的资源也会作为资源 保存在部署过程中，然后可以通过 `RepositoryService`类中的 `InputStream getResourceAsStream(long deploymentDbid, String resourceName);`访问。

为了创建一个业务归档， 可以使用`jar`任务。

```xml
<jar destfile="${jbpm.home}/examples/target/examples.bar">
      <fileset dir="${jbpm.home}/examples/src">
        <include name="**/*.jpdl.xml" />
        ...
      </fileset>
    </jar>
```

在jbpm-deploy被使用之前，它需要像这样进行声明：

```xml
<taskdef name="jbpm-deploy"
           classname="org.jbpm.pvm.internal.ant.JbpmDeployTask"
         classpathref="jbpm.libs.incl.dependencies" />
```

然后可以像这样使用ant任务

```xml
<jbpm-deploy file="${jbpm.home}/examples/target/examples.bar" />
```



**表 4.1. jbpm-deploy属性：**

| 属性   | 类型 | 默认值       | 是否必填 | 描述                                                         |
| ------ | ---- | ------------ | -------- | ------------------------------------------------------------ |
| `file` | 文件 |              | 可选     | 被部署的文件。`.xml`结尾的文件会被当做流程文件部署。 `ar`结尾，比如.bar或.jar，的文件 会被当做业务归档部署。 |
| `cfg`  | 文件 | jbpm.cfg.xml | 可选     | 指向jbpm配置文件，它应该放在 `jbpm-deploy`定义的classpath下。 |



**表 4.2. jbpm-deploy元素**

| 元素      | 数目 | 描述                                                         |
| --------- | ---- | ------------------------------------------------------------ |
| `fileset` | 0..* | 被部署的文件，表示成一个简单的ant的fileset。 `.xml`结尾的文件会被当做流程文件部署。 `ar`结尾，比如.bar或.jar，的文件 会被当做业务归档部署。 |

## 4.2. 部署java类

从4.2版本开始，jBPM拥有了一个像jBPM3一样的流程类加载器机制。

从流程中引用的类必须至少在下面三种方式之一是 有效的：

- 业务存档中的.class文件。和jBPM3中不同，现在 存档文件的根被用来搜索类资源。 所以当类`com.superdeluxsandwiches.Order` 在流程文件中引用时，它会找到，当它在相同的业务归档中 的入门名称`com/superdeluxsandwiches/Order.class` 类会被缓存（key是结合了发布和上下文类加载器）， 所以它应该比jBPM 3中执行的更好。
- 在调用jBPM的web应用中可用的类。 当jBPM部署到服务器端的jboss或tomcat中，jBPM会找到你的 web应用或企业应用，调用jBPM的类。 这是因为你使用了当前上下文类加载器， 在流程执行过程中查找类时。
- 服务器端可用的类文件。比如像是在 tomcat和jboss的lib目录下的jar。

在实例中，一个包含了所有类的examples.jar被创建了， 并把它放在了JBoss服务器配置的`lib`目录下。 tomcat下操作相同。参考`install.examples.into.tomcat` 和`install.examples.into.jboss`任务。在未来的一个发布版中 我们可能切换到业务存档自身包含的类。

------
