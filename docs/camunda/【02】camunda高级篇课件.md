# Camunda

# 一、Camunda介绍

官网地址：https://camunda.com/

中文站点：http://camunda-cn.shaochenfeng.com/

下载：https://downloads.camunda.cloud/release/camunda-bpm/run/7.15/

案例地址：[Congratulation! | docs.camunda.org](https://docs.camunda.org/get-started/quick-start/complete/)

前期准备工作: JAVA1.8以上的JRE或JDK

## 1.Camunda Modeler

&emsp;&emsp;Camunda Modeler 是Camunda 官方提供的一个流程设计器，用于编辑流程图以及其他模型【表单】，也就是一个流程图的绘图工具。可以官方下载，也可以在提供给大家的资料中获取。获取后直接解压缩即可，注意：解压安装到非中文目录中!!!

![image-20220901105936567](img\image-20220901105936567.png)



启动的效果：

![image-20220901110007447](img\image-20220901110007447.png)



## 2.Camunda BPM

下载地址 https://camunda.com/download/

&emsp;&emsp;Camunda BPM 是Camunda官方提供的一个`业务流程管理`平台,用来管理，部署的流程定义、执行任务，策略等。下载安装一个Camunda平台，成功解压 Camunda 平台的发行版后，执行名为start.bat（对于 Windows 用户）或start.sh（对于 Unix 用户）的脚本。此脚本将启动应用程序服务器。

![image-20220901110225636](img\image-20220901110225636.png)

&emsp;&emsp;打开您的 Web 浏览器并导航到http://localhost:8080/以访问欢迎页面，Camunda的管理平台。



![image-20220718162641800](img\image-20220718162641800.png)



登录成功的主页：

![image-20220718162726028](img\image-20220718162726028.png)







## 3.入门案例

### 3.1 创建简单流程

&emsp;&emsp;我们先通过 Modeler 来绘制一个简单流程

1.) 创建流程：选择 BPMN diagram (Camunda Platform)

![image-20220901110718700](img\image-20220901110718700.png)

2.) 创建开始节点：并设定节点名称

![image-20220901110850675](img\image-20220901110850675.png)

3.) 创建服务节点：设置处理方式

![image-20220901110926577](img\image-20220901110926577.png)

![image-20220901111045576](img\image-20220901111045576.png)

我们切换节点的类型为 `service Task`

![image-20220901111125584](img\image-20220901111125584.png)

![image-20220901111141656](img\image-20220901111141656.png)

然后我们需要配置`刷卡付款`节点，服务类型有很多执行的方法，这次我们使用“external（外部）”任务模式。

![image-20220901111330988](img\image-20220901111330988.png)

具体配置内容为

![image-20220901111419588](img\image-20220901111419588.png)



4.) 添加结束节点

![image-20220901111521063](img\image-20220901111521063.png)



5.) 配置流程参数

&emsp;&emsp;点击画布的空白处，右侧的面板会显示当前流程本身的参数,这里我们修改id为*payment-retrieval*，id是区分流程的标识然后修改Name 为“付款流程”最后确保 `Executable`是勾选的，只有`Executable`被勾选，流程才能执行

![image-20220901111725855](img\image-20220901111725855.png)



### 3.2 外部任务

&emsp;&emsp;在上面设计的流程图，`刷卡付款`节点的处理是外部任务，Camunda 可以使多种语言实现业务逻辑，我们以Java为例来介绍。

添加相关的依赖：

```xml
    <dependencies>
		<dependency>
			<groupId>org.camunda.bpm</groupId>
			<artifactId>camunda-external-task-client</artifactId>
			<version>7.15.0</version>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-simple</artifactId>
			<version>1.6.1</version>
		</dependency>
		<dependency>
			<groupId>javax.xml.bind</groupId>
			<artifactId>jaxb-api</artifactId>
			<version>2.3.1</version>
		</dependency>
	</dependencies>

```

编写处理的业务逻辑的代码

```java
import org.camunda.bpm.client.ExternalTaskClient;

import java.awt.*;
import java.net.URI;

public class Demo01 {
    public static void main(String[] args) {
        ExternalTaskClient client = ExternalTaskClient.create()
                .baseUrl("http://localhost:8080/engine-rest")
                .asyncResponseTimeout(10000) // 长轮询超时时间
                .build();
        // 订阅指定的外部任务
        client.subscribe("charge-card")
                .lockDuration(1000)
                .handler(((externalTask, externalTaskService) -> {
                    // 获取流程变量
                    String item = (String) externalTask.getVariable("item");
                    Long amount = (Long) externalTask.getVariable("amount");
                    System.out.println("item--->"+item + "  amount-->" + amount);
                    try {
                        Desktop.getDesktop().browse(new URI("https://docs.camunda.org/get-started/quick-start/complete"));
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    // 完成任务
                    externalTaskService.complete(externalTask);
                })).open();
    }
}

```

运行该方法即可，当流程处理时会执行相关逻辑。



### 3.3 部署流程

&emsp;&emsp;接下来我们就可以来部署上面定义的流程了。使用 Camunda Modeler 部署流程，点击工具栏中的部署按钮可以将当前流程部署到流程引擎，点击部署按钮，输入Deployment Name 为 “Payment” ，输入下方REST Endpoint 为http://localhost:8080/engine-rest ，然后点击右下角Deploy部署

部署操作：

![image-20220901102738775](img\image-20220901102738775.png)

部署的时候报错：原因是安装路径中有中文

![image-20220901101904825](img\image-20220901101904825.png)



部署成功：

![image-20220901102705446](img\image-20220901102705446.png)



然后在BPM中我们可以查看部署的流程：

![image-20220901112401741](img\image-20220901112401741.png)





### 3.4 启动流程

&emsp;&emsp;我们使用Rest API发起流程，所以需要一个接口测试工具（例如：Postman），或者也可以使用电脑自带的curl

curl执行如下命令

```curl
curl -H "Content-Type: application/json" -X POST -d '{"variables": {"amount": {"value":555,"type":"long"}, "item": {"value":"item-xyz"} } }' http://localhost:8080/engine-rest/process-definition/key/payment-retrieval/start

```

postman方式处理

在url中输入：http://localhost:8080/engine-rest/process-definition/key/payment-retrieval/start 通过`POST`方式提交，提交的方式是`JSON` 数据，具体内容为：

```json
{
	"variables": {
		"amount": {
			"value":555,
			"type":"long"
		},
		"item": {
			"value": "item-xyz"
		}
	}
}

```

![image-20220901112634925](img\image-20220901112634925.png)

然后我们点击发送，操作成功可以看到如下的返回信息

![image-20220901112709320](img\image-20220901112709320.png)



同时任务执行后我们在控制台可以看到相关的信息

![image-20220901112810150](img\image-20220901112810150.png)

# 二、IDEA引入流程设计器

&emsp;&emsp;在工作流引擎中流程设计器是一个非常重要的组件，而`InterlliJ IDEA`是Java程序员用到的最多的编程工具了。前面在基础篇的介绍中我们都在通过Camunda提供的流程设计器绘制好流程图，然后需要单独的拷贝到项目中，要是调整修改不是很方便，这时我们可以在IDEA中和流程设计器绑定起来。这样会更加的灵活。

## 1.下载Camunda Model

&emsp;&emsp;第一步肯定是需要下载`Camunda Model` 这个流程设计器，我们前面有介绍。就是之前解压好的目录了。

![image-20220907002253021](img\image-20220907002253021.png)



## 2.IDEA中配置

&emsp;&emsp;我们先进入`settings`中然后找到`tools`,继续找到`External Tool`.

![image-20220907002432482](img\image-20220907002432482.png)

![image-20220907002649744](img\image-20220907002649744.png)

最终效果

![image-20220907002735603](img\image-20220907002735603.png)



## 3.编辑bpmn文件

&emsp;&emsp;找到您想打开的bpmn文件, 点击右键, 找到External Tools 运行camunda modler即可进行文件编写.

![image-20220907002851738](img\image-20220907002851738.png)

搞定~



# 三、SpringBoot整合Camunda

## 1.官方案例说明

&emsp;&emsp;接下来我们看看怎么在我们的实际项目中来使用Camunda了。方式有多种，首先我们可以参考官网提供的整合案例。

![image-20220907003810268](img\image-20220907003810268.png)

&emsp;&emsp;但是这里有个比较头疼的问题就是Camunda和SpringBoot版本的兼容性问题，虽然官方也给出了兼容版本的对照表。

![image-20220907003929928](img\image-20220907003929928.png)



&emsp;&emsp;但是如果不小心还是会出现各种问题，比如：

![image-20220907004050862](img\image-20220907004050862.png)

&emsp;&emsp;上面就是典型的版本不兼容的问题了。



## 2.官方Demo

&emsp;&emsp;为了能让我们的案例快速搞定，我们可以通过Camunda官方提供的网站来创建我们的案例程序。地址：https://start.camunda.com/

![image-20220907004531764](img\image-20220907004531764.png)

&emsp;&emsp;生成代码后，解压后我们通过idea打开项目，项目结构

![image-20220907010229047](img\image-20220907010229047.png)

相关的pom.xml中的依赖

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

  <modelVersion>4.0.0</modelVersion>

  <groupId>com.boge.workflow</groupId>
  <artifactId>camunda-project-demo</artifactId>
  <version>1.0.0-SNAPSHOT</version>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>8</maven.compiler.source>
    <maven.compiler.target>8</maven.compiler.target>
  </properties>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-dependencies</artifactId>
        <version>2.4.3</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>

      <dependency>
        <groupId>org.camunda.bpm</groupId>
        <artifactId>camunda-bom</artifactId>
        <version>7.15.0</version>
        <scope>import</scope>
        <type>pom</type>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <dependencies>
    <dependency>
      <groupId>org.camunda.bpm.springboot</groupId>
      <artifactId>camunda-bpm-spring-boot-starter-rest</artifactId>
    </dependency>

    <dependency>
      <groupId>org.camunda.bpm.springboot</groupId>
      <artifactId>camunda-bpm-spring-boot-starter-webapp</artifactId>
    </dependency>

    <dependency>
      <groupId>org.camunda.bpm</groupId>
      <artifactId>camunda-engine-plugin-spin</artifactId>
    </dependency>

    <dependency>
      <groupId>org.camunda.spin</groupId>
      <artifactId>camunda-spin-dataformat-all</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
      <groupId>com.h2database</groupId>
      <artifactId>h2</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>

  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <version>2.4.3</version>
      </plugin>
    </plugins>
  </build>

</project>
```

属性文件的配置信息

```yaml
spring.datasource.url: jdbc:h2:file:./camunda-h2-database

camunda.bpm.admin-user:
  id: demo
  password: demo
```

然后通过启动类启动程序

![image-20220907010434493](img\image-20220907010434493.png)

访问服务：http://localhost:8080/

![image-20220907010523901](img\image-20220907010523901.png)





## 3.MySQL数据库

&emsp;&emsp;上面的例子我们数据存储在了H2这个内存型数据库，我们可以切换到`MySQL`数据库。首先我们需要导入相关的SQL脚本。位置就在我们之前下载的`Camunda Web`服务中。

![image-20220907010729453](img\image-20220907010729453.png)

&emsp;&emsp;执行创建所有必需的表和默认索引的SQL DDL脚本。上面两个脚本都要执行。

![image-20220907011030798](img\image-20220907011030798.png)

&emsp;&emsp;生成的相关表结构比较多，因为本身就是基于Activiti演变而来，所以有Activiti基础的小伙伴会非常轻松了。简单介绍下相关表结构的作用。

* **ACT_RE** ：'RE'表示 repository。 这个前缀的表包含了流程定义和流程静态资源 （图片，规则，等等）。
* **ACT_RU**：'RU'表示 runtime。 这些运行时的表，包含流程实例，任务，变量，异步任务，等运行中的数据。 Flowable只在流程实例执行过程中保存这些数据， 在流程结束时就会删除这些记录。 这样运行时表可以一直很小速度很快。
* **ACT_HI**：'HI'表示 history。 这些表包含历史数据，比如历史流程实例， 变量，任务等等。
* **ACT_GE**： GE 表示 general。 通用数据， 用于不同场景下 
* **ACT_ID:**   ’ID’表示identity(组织机构)。这些表包含标识的信息，如用户，用户组，等等。

具体的表结构的含义:

| **表分类** | **表名**                | **解释**                    |
| ------- | --------------------- | ------------------------- |
| 一般数据    |                       |                           |
|         | [ACT_GE_BYTEARRAY]    | 通用的流程定义和流程资源              |
|         | [ACT_GE_PROPERTY]     | 系统相关属性                    |
| 流程历史记录  |                       |                           |
|         | [ACT_HI_ACTINST]      | 历史的流程实例                   |
|         | [ACT_HI_ATTACHMENT]   | 历史的流程附件                   |
|         | [ACT_HI_COMMENT]      | 历史的说明性信息                  |
|         | [ACT_HI_DETAIL]       | 历史的流程运行中的细节信息             |
|         | [ACT_HI_IDENTITYLINK] | 历史的流程运行过程中用户关系            |
|         | [ACT_HI_PROCINST]     | 历史的流程实例                   |
|         | [ACT_HI_TASKINST]     | 历史的任务实例                   |
|         | [ACT_HI_VARINST]      | 历史的流程运行中的变量信息             |
| 流程定义表   |                       |                           |
|         | [ACT_RE_DEPLOYMENT]   | 部署单元信息                    |
|         | [ACT_RE_MODEL]        | 模型信息                      |
|         | [ACT_RE_PROCDEF]      | 已部署的流程定义                  |
| 运行实例表   |                       |                           |
|         | [ACT_RU_EVENT_SUBSCR] | 运行时事件                     |
|         | [ACT_RU_EXECUTION]    | 运行时流程执行实例                 |
|         | [ACT_RU_IDENTITYLINK] | 运行时用户关系信息，存储任务节点与参与者的相关信息 |
|         | [ACT_RU_JOB]          | 运行时作业                     |
|         | [ACT_RU_TASK]         | 运行时任务                     |
|         | [ACT_RU_VARIABLE]     | 运行时变量表                    |
| 用户用户组表  |                       |                           |
|         | [ACT_ID_BYTEARRAY]    | 二进制数据表                    |
|         | [ACT_ID_GROUP]        | 用户组信息表                    |
|         | [ACT_ID_INFO]         | 用户信息详情表                   |
|         | [ACT_ID_MEMBERSHIP]   | 人与组关系表                    |
|         | [ACT_ID_PRIV]         | 权限表                       |
|         | [ACT_ID_PRIV_MAPPING] | 用户或组权限关系表                 |
|         | [ACT_ID_PROPERTY]     | 属性表                       |
|         | [ACT_ID_TOKEN]        | 记录用户的token信息              |
|         | [ACT_ID_USER]         | 用户表                       |

 

&emsp;&emsp;然后我们在SpringBoot项目中导入`MySql`的依赖，然后修改对应的配置信息

```xml
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
    </dependency>
```

&emsp;&emsp;修改`application.yaml`。添加数据源的相关信息。

```yaml
# spring.datasource.url: jdbc:h2:file:./camunda-h2-database

camunda.bpm.admin-user:
  id: demo
  password: demo
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/camunda1?serverTimezone=Asia/Shanghai
    username: root
    password: 123456
camunda:
  bpm:
    database:
      type: mysql
      schema-update: true
    auto-deployment-enabled: false # 自动部署 resources 下的 bpmn文件
```

然后启动项目，发现数据库中有了相关记录，说明操作成功

![image-20220907011831014](img\image-20220907011831014.png)





# 四、Camunda专题讲解

&emsp;&emsp;用了整合的基础我们就可以来完成一个流程审批的案例了

## 1.部署流程

```java
@RestController
@RequestMapping("/flow")
public class FlowController {

    @Autowired
    private RepositoryService repositoryService;

    @GetMapping("/deploy")
    public String deplopy(){
        Deployment deploy = repositoryService.createDeployment()
                .name("部署的第一个流程") // 定义部署文件的名称
                .addClasspathResource("process.bpmn") // 绑定需要部署的流程文件
                .deploy();// 部署流程
        return deploy.getId() + ":" + deploy.getName();
    }
}
```

启动后访问接口即可

## 2.启动流程

&emsp;&emsp;启动流程我们通过单元测试来操作

```java
package com.boge.workflow;


import org.camunda.bpm.engine.RepositoryService;
import org.camunda.bpm.engine.RuntimeService;
import org.camunda.bpm.engine.TaskService;
import org.camunda.bpm.engine.runtime.ProcessInstance;
import org.camunda.bpm.engine.task.Task;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest(classes = Application.class)
public class ApplicationTest {

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private RuntimeService runtimeService;

    @Autowired
    private TaskService taskService;

    /**
     * 启动流程的案例
     */
    @Test
    public void startFlow(){
        // 部署流程
        ProcessInstance processInstance = runtimeService
                .startProcessInstanceById("1a880f27-2e57-11ed-80d9-c03c59ad2248");
        // 部署的流程实例的相关信息
        System.out.println("processInstance.getId() = " + processInstance.getId());
        System.out.println("processInstance.getProcessDefinitionId() = " + processInstance.getProcessDefinitionId());
    }


}

```



## 3.查询待办

&emsp;&emsp;查询待办也就是查看当前需要审批的任务，通过TaskService来处理

```java
    /**
     * 查询任务
     *    待办
     *
     *  流程定义ID:processDefinition : 我们部署流程的时候会，每一个流程都会产生一个流程定义ID
     *  流程实例ID:processInstance ：我们启动流程实例的时候，会产生一个流程实例ID
     */
    @Test
    public void queryTask(){
        List<Task> list = taskService.createTaskQuery()
                //.processInstanceId("eff78817-2e58-11ed-aa3f-c03c59ad2248")
                .taskAssignee("demo1")
                .list();
        if(list != null && list.size() > 0){
            for (Task task : list) {
                System.out.println("task.getId() = " + task.getId());
                System.out.println("task.getAssignee() = " + task.getAssignee());
            }
        }
    }
```



## 4.完成任务

```java
   /**
     * 完成任务
     */
    @Test
    public void completeTask(){
        // 根据用户找到关联的Task
        Task task = taskService.createTaskQuery()
                //.processInstanceId("eff78817-2e58-11ed-aa3f-c03c59ad2248")
                .taskAssignee("demo")
                .singleResult();
        if(task != null ){
            taskService.complete(task.getId());
            System.out.println("任务审批完成...");
        }
    }
```



