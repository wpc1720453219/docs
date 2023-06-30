[FastJson 狗都不用](https://mp.weixin.qq.com/s/WhCpiZ-EIjIdYXixZBskrQ)  
主推Jackson，逐渐的淘汰Fastjson（bug太多）  

https://blog.csdn.net/weixin_44747933/article/details/108301626

jacjson 方法总结： 
```java
//单个对象转json
 String jsonString = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(person);
//json转对象
Person deserializdPerson = mapper.readValue(jsonString, Person.class);

list<对象>
//对象列表 转json
String jsonInString = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(list);
// json字符串转对象列表
List<Person> personList2 = mapper.readValue(jsonInString, new TypeReference<List<Person>>() {});
```




