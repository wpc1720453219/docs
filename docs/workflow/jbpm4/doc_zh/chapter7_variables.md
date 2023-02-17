## 第 7 章 Variables变量

流程变量在流程外部，通过`ExecutionService`提供的方法进行访问：

- `ProcessInstance startProcessInstanceById(String processDefinitionId, Map<String, Object> variables);`
- `ProcessInstance startProcessInstanceById(String processDefinitionId, Map<String, Object> variables, String processInstanceKey);`
- `ProcessInstance startProcessInstanceByKey(String processDefinitionKey, Map<String, ?> variables);`
- `ProcessInstance startProcessInstanceByKey(String processDefinitionKey, Map<String, ?> variables, String processInstanceKey);`
- `void setVariable(String executionId, String name, Object value);`
- `void setVariables(String executionId, Map<String, ?> variables);`
- `Object getVariable(String executionId, String variableName);`
- `Set<String> getVariableNames(String executionId);`
- `Map<String, Object> getVariables(String executionId, Set<String> variableNames);`

在流程中可以通过Execution接口，传递给用户代码，比如 `ActivityExecution`和`EventListenerExecution`：

- `Object getVariable(String key);`
- `void setVariables(Map<String, ?> variables);`
- `boolean hasVariable(String key);`
- `boolean removeVariable(String key);`
- `void removeVariables();`
- `boolean hasVariables();`
- `Set<String> getVariableKeys();`
- `Map<String, Object> getVariables();`
- `void createVariable(String key, Object value);`
- `void createVariable(String key, Object value, String typeName);`

jBPM没有自动检测变量值变化的机制。 比如，从实例变量中获得了一个序列化的集合，添加了一个元素， 然后你就需要把变化了的变量值准确的保存到DB中。

## 7.1. 变量作用域

默认情况下，变量创建在顶级的流程实例作用域中。 这意味着它们对整个流程实例中的所有执行都是可见的，可访问的。 流程变量是动态创建的。意味着，当一个变量通过任何一个方法设置到流程中， 整个变量就会被创建了。

每个执行都有一个变量作用域。声明在内嵌执行级别中的变量， 可以看到它自己的变量和声明在上级执行中的变量，这时按照正常的作用域规则。 使用execution接口中的`createVariable`方法， `ActivityExecution`和`EventListenerExecution`可以创建流程的局部变量。

在未来的发布中，我们可能添加在jPDL流程语言中声明的变量。

## 7.2. 变量类型

jBPM支持下面的Java类型，作为流程变量：

- java.lang.String
- java.lang.Long
- java.lang.Double
- java.util.Date
- java.lang.Boolean
- java.lang.Character
- java.lang.Byte
- java.lang.Short
- java.lang.Integer
- java.lang.Float
- byte[] (byte array)
- char[] (char array)
- hibernate entity with a long id
- hibernate entity with a string id
- serializable

为了持久化这些变量，变量的类型会按照这个列表中的例子进行检测。 第一个匹配的类型， 会决定变量如何保存。

## 7.3. 更新持久化流程变量

(jBPM 4.3中新添加的功能)

在 `custom`s, `event-handler`s 和其他 用户代码中，你可以获取流程变量。当一个流程变量作为 持久化的对象被保存时，你可以直接更新反序列化的对象， 而不需要再次进行保存。jBPM会管理反序列化的流程变量 如果出现了修改就会自动更新它们。比如（参考报org.jbpm.examples.serializedobject）， 查看一个`custom`活动行为内的代码片段：

```java
public class UpdateSerializedVariables implements ActivityBehaviour {

  public void execute(ActivityExecution execution) {
    Set<String> messages = (Set<String>) execution.getVariable("messages");
    messages.clear();
    messages.add("i");
    messages.add("was");
    messages.add("updated");
  }
}
```

当事务提交时，用户代码会被调用， 更新消息集合会自动被更新到数据库中。

当从DB读取以序列化格式保存的流程变量时， jBPM会监控反序列化的对象。在事务提交之前， jBPM会反序列化并自动更新变量，如果必要的话。 jBPM会忽略更新反序列化对象，如果其他对象被设置到那个作用域 （这可能是其他类型）。jBPM也会略过更新 那些数值没有发生变化的的反序列化对象。这些检测会查看 如果一个对象被修改了，基于计算再次序列化对象的字节数组， 和从数据库中原来读取的字节数组进行比较。

## 7.4. 声明变量

(从 jBPM 4.4 开始)

变量可以被直接定义在流程定义中（jPDL）。这些变量 会在流程实例启动时被创建。这里可能有多于一个的变量定义。

这儿有几种可能方式来声明变量：

- 声明`字符串`变量，使用静态文本初始化

  ```xml
  <variable name="declaredVar" type="string" init-expr="testing declared variable"/>
              
  ```

- 声明`自定义`变量，使用EL进行初始化

  ```xml
  <variable name="declaredVar" type="long" init-expr="#{anotherVar}"/>
              
  ```

- 声明`自定义`变量，使用可持久化的类进行初始化

  ```xml
  <variable name="declaredVar" type="serializable" >
     <object class="org.jbpm.examples.variable.declared.HistoryVariable" />
  </variable>
              
  ```

就像上面演示的那样，变量值可以通过两种方式设置：使用`init-expr`属性 或通过内嵌的init标识符（`object`元素）在变量标签中。

注意，每个流程定义只能使用一个赋值方式。



**表 7.1. variable 元素的属性：**

| 属性             | 类型               | 默认值 | 是否必须 | 描述                                                         |
| ---------------- | ------------------ | ------ | -------- | ------------------------------------------------------------ |
| `name`           | 字符串             |        | **必须** | 变量的名称                                                   |
| `type`           | 字符串             |        | **必须** | 变量的类型，必须引用jbpm.variable.types.xml中定义的类型      |
| `init-expr`      | 字符串（EL表达式） |        | **可选** | 变量的值，这个属性或内嵌元素必须设置                         |
| `init-expr-type` | 字符串             | UEL    | **可选** | 定义表达式执行的语言                                         |
| `history`        | boolean            | false  | **可选** | 表示变量是否需要保存到历史库中 - 默认为false。 更多历史的信息，请参考[第 7.5 节 “变量历史”](http://www.mossle.com/docs/jbpm4userguide/html/variables.html#variablehistory) |



**表 7.2. variable的内嵌元素**

| 元素     | 数目 | 描述                                                         |      |      |
| -------- | ---- | ------------------------------------------------------------ | ---- | ---- |
| `object` | 1    | 变量的值，它是一个自定义对象，这个元素或`init-expr`属性必须被指定。 |      |      |

## 7.5. 变量历史

(从 jBPM 4.4 开始)

变量可以被标记为作为历史记录保存。这意味着，当流程实例结束， 它的运行阶段的信息被删除，历史细节依然会被保存。

有两种方式可以启用变量的历史功能：

- 通过公共 API `ExecutionService`:

```java
  void createVariable(String executionId, String name, Object value, boolean historyEnabled);
  void createVariables(String executionId, Map<String, ?> variables, boolean historyEnabled);
```
- 通过变量定义

  ```xml
  <variable name="declaredVar" type="string" init-expr="testing declared variable" history="true"/>
              
  ```

当前，所有变量历史都会作为`字符串`值保存。 变量（无论什么类型）会被转换成一个字符串的值，使用`toString()`方法。 在自定义对象的情况，它们需要重写`toString()`方法来提供字符串的内容， 这些内容会作为历史记录保存下来。这就提供了一个简单的方法， 可以根据变量值来进行搜索的功能。

可以通过 `HistoryService` 方法来访问历史变量：

- `Object getVariable(String processInstnceId, String name);`
- `Map<String, Object> getVariables(String processInstnceId, Set<String> variableNames);`
- `Set<String> getVariableNames(String processInstnceId);`

------
