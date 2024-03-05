# Skywalking 6 版本安装

## 软件下载

### 主体软件包
<https://skywalking.apache.org/downloads/>

下载里面的`6.3.0`版本的`tar.gz`即可。
解压缩。

### oracle插件
<https://github.com/SkyAPM/java-plugin-extensions/releases>

下载里面的`apm-oracle-10.x-plugin-1.0.1.jar`即可。
然后把这个jar包放到`agent/plugins`文件夹下。

本地提供的地址：[apm-oracle-10.x-plugin-1.0.1.jar](./plugins/apm-oracle-10.x-plugin-1.0.1.jar)

### logback插件
作用：把traceId打印到日志里面。
[xyyweb-logback-plugin-6.3.0.jar](./plugins/xyyweb-logback-plugin-6.3.0.jar)

然后把这个jar包放到`agent/plugins`文件夹下。

### docker镜像
skywalking官方提供了docker镜像。
- <https://hub.docker.com/r/apache/skywalking-oap-server>
- <https://hub.docker.com/r/apache/skywalking-ui>
```bash
docker pull apache/skywalking-ui:6.3.0
docker pull apache/skywalking-oap-server:6.3.0
```

## 安装

### 主程序
解压后，改完配置文件，用`bin/startup.sh`启动脚本启动即可，需要java8环境。

#### 配置oracle组件映射
打开`config/component-libraries.yml`，在最后面添加映射`ojdbc: ORACLE`:
如下：
```yaml{4}
Component-Server-Mappings:
  ...（其他省略掉）
  transport-client: Elasticsearch
  ojdbc: ORACLE
```

#### 配置持久化
也就是Skywalking的数据库。

目前官方提供的持久化组件有：[Backend storage](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/backend/backend-storage.md#backend-storage)
> - H2
> - ElasticSearch 6
> - MySQL
> - TiDB

这里H2是内存数据库，为了启动方便，官方作为默认配置；
但实际部署时，数据是需要持久化的，建议使用`MySQL`。

skywalking对es的消耗是日志的几十倍，同样的skywalking，用es比用mysql持久化耗cpu、硬盘读写多40倍。
skywalking持久化主要是增删改查，和es的主功能全文索引扯不上关系，用了es徒增资源消耗。

##### Mysql配置
mysql 驱动用 [mysql-connector-java-5.1.42.jar](http://10.60.44.54:8081/repository/maven-aliyun/mysql/mysql-connector-java/5.1.42/mysql-connector-java-5.1.42.jar)
下载后放到 `oap-libs` 文件夹；
在 `config/application.yml` 文件中，把h2的那一段注释掉，mysql的那段打开。
```yaml
storage:
#  elasticsearch:
#    nameSpace: ${SW_NAMESPACE:""}
#    clusterNodes: ${SW_STORAGE_ES_CLUSTER_NODES:localhost:9200}
#    user: ${SW_ES_USER:""}
#    password: ${SW_ES_PASSWORD:""}
#    indexShardsNumber: ${SW_STORAGE_ES_INDEX_SHARDS_NUMBER:2}
#    indexReplicasNumber: ${SW_STORAGE_ES_INDEX_REPLICAS_NUMBER:0}
#    # Batch process setting, refer to https://www.elastic.co/guide/en/elasticsearch/client/java-api/5.5/java-docs-bulk-processor.html
#    bulkActions: ${SW_STORAGE_ES_BULK_ACTIONS:2000} # Execute the bulk every 2000 requests
#    bulkSize: ${SW_STORAGE_ES_BULK_SIZE:20} # flush the bulk every 20mb
#    flushInterval: ${SW_STORAGE_ES_FLUSH_INTERVAL:10} # flush the bulk every 10 seconds whatever the number of requests
#    concurrentRequests: ${SW_STORAGE_ES_CONCURRENT_REQUESTS:2} # the number of concurrent requests
#    metadataQueryMaxSize: ${SW_STORAGE_ES_QUERY_MAX_SIZE:5000}
#    segmentQueryMaxSize: ${SW_STORAGE_ES_QUERY_SEGMENT_SIZE:200}
#  h2:
#    driver: ${SW_STORAGE_H2_DRIVER:org.h2.jdbcx.JdbcDataSource}
#    url: ${SW_STORAGE_H2_URL:jdbc:h2:mem:skywalking-oap-db}
#    user: ${SW_STORAGE_H2_USER:sa}
#    metadataQueryMaxSize: ${SW_STORAGE_H2_QUERY_MAX_SIZE:5000}
  mysql:
    metadataQueryMaxSize: ${SW_STORAGE_H2_QUERY_MAX_SIZE:5000}
```
在 `config/datasource-settings.properties` 配置里面改mysql地址、用户密码，比如：
```properties
jdbcUrl=jdbc:mysql://10.60.44.58:3306/sw_luna_59?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8
dataSource.user=root
dataSource.password=xxxxxxx
dataSource.cachePrepStmts=true
dataSource.prepStmtCacheSize=250
dataSource.prepStmtCacheSqlLimit=2048
dataSource.useServerPrepStmts=true
dataSource.useLocalSessionState=true
dataSource.rewriteBatchedStatements=true
dataSource.cacheResultSetMetadata=true
dataSource.cacheServerConfiguration=true
dataSource.elideSetAutoCommits=true
dataSource.maintainTimeStats=false

```


##### es持久化配置
具体配置是在 `config/application.yml` 文件中，把h2的那一段注释掉，es的那段打开，配下es的地址就好。如下：
```yaml
storage:
  elasticsearch:
    nameSpace: ${SW_NAMESPACE:""}
    clusterNodes: ${SW_STORAGE_ES_CLUSTER_NODES:localhost:9200}
    user: ${SW_ES_USER:""}
    password: ${SW_ES_PASSWORD:""}
    indexShardsNumber: ${SW_STORAGE_ES_INDEX_SHARDS_NUMBER:2}
    indexReplicasNumber: ${SW_STORAGE_ES_INDEX_REPLICAS_NUMBER:0}
    # Batch process setting, refer to https://www.elastic.co/guide/en/elasticsearch/client/java-api/5.5/java-docs-bulk-processor.html
    bulkActions: ${SW_STORAGE_ES_BULK_ACTIONS:2000} # Execute the bulk every 2000 requests
    bulkSize: ${SW_STORAGE_ES_BULK_SIZE:20} # flush the bulk every 20mb
    flushInterval: ${SW_STORAGE_ES_FLUSH_INTERVAL:10} # flush the bulk every 10 seconds whatever the number of requests
    concurrentRequests: ${SW_STORAGE_ES_CONCURRENT_REQUESTS:2} # the number of concurrent requests
    metadataQueryMaxSize: ${SW_STORAGE_ES_QUERY_MAX_SIZE:5000}
    segmentQueryMaxSize: ${SW_STORAGE_ES_QUERY_SEGMENT_SIZE:200}
#  h2:
#    driver: ${SW_STORAGE_H2_DRIVER:org.h2.jdbcx.JdbcDataSource}
#    url: ${SW_STORAGE_H2_URL:jdbc:h2:mem:skywalking-oap-db}
#    user: ${SW_STORAGE_H2_USER:sa}
#    metadataQueryMaxSize: ${SW_STORAGE_H2_QUERY_MAX_SIZE:5000}
#  mysql:
#    metadataQueryMaxSize: ${SW_STORAGE_H2_QUERY_MAX_SIZE:5000}
```

#### 其他配置详情
关于配置，详情可参考官网教程[Backend and UI setup](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/backend/backend-ui-setup.md)

主要是配置es的地址、es集群名，端口号等。

### 探针

#### 添加oracle插件
由于apache协议的原因，官方的包不能把oracle集成进来，需要手动添加。
把下载到的oracle插件jar包放到`agent/plugins`文件夹下。

#### 删掉redis插件

到agent/plugins文件夹下，删掉这两个jar包：
1. apm-jedis-2.x-plugin-6.3.0.jar
1. apm-redisson-3.x-plugin-6.3.0.jar
    - redisson插件在6.3版本还发现了会导致traceId断掉的问题


#### 参数覆盖配置
配置可以修改配置文件，但比较麻烦，最佳实践是推荐使用覆盖参数配置。

官方教程链接：[Setting-override](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Setting-override.md)

现在的覆盖配置支持3种方式：
##### [java -D 参数](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Setting-override.md#system-properties)

一个配置示例：
```bash
java -cp /app/resources:/app/classes:/app/libs/* \
-javaagent:C:\green\apache-skywalking-apm-6.3.0\agent\skywalking-agent.jar \
-Dskywalking.agent.namespace=luna_dev \
-Dskywalking.agent.service_name=luna_dev_usercore \
-Dskywalking.agent.span_limit_per_segment=30000 \
-Dskywalking.collector.backend_service=127.0.0.1:11800 \
-Dskywalking.logging.level=INFO \
-Dskywalking.logging.file_name=skywalking-agent-usercore.log \
com.alibaba.dubbo.container.Main
```
如果想要忽略掉一些trace，比如监控信息等，可以添加如下参数，示例：
```bash
-Dskywalking.agent.ignore_suffix=com.alibaba.dubbo.monitor.MonitorService.collect(URL),.jpg,.jpeg,.js,.css,.png,.bmp,.gif,.ico,.mp3,.mp4,.html,.svg
```

###### tomcat配置

拷贝agent/文件夹到应用的每个服务器，每个部署了tomcat里面运行着我们的项目的服务器，都需要拷贝探针。

以部署了usercore的tomcat为例，在tomcat的bin/catalina.sh的第二行（或前面有空地方的），加入以下配置：

```bash
export CATALINA_OPTS="$CATALINA_OPTS \
-javaagent:C:\green\apache-skywalking-apm-6.3.0\agent\skywalking-agent.jar \
-Dskywalking.agent.namespace=tfp \
-Dskywalking.agent.service_name=usercore \
-Dskywalking.agent.span_limit_per_segment=30000 \
-Dskywalking.collector.backend_service=127.0.0.1:11800 \
-Dskywalking.logging.level=INFO \
-Dskywalking.logging.file_name=skywalking-agent-usercore.log \
-Dskywalking.agent.ignore_suffix='com.alibaba.dubbo.monitor.MonitorService.collect(URL),.jpg,.jpeg,.js,.css,.png,.bmp,.gif,.ico,.mp3,.mp4,.html,.svg'"

```

配置项说明：

`-javaagent:`后跟着探针目录下的skywalking-agent.jar包的位置；

`-Dskywalking.agent.service_name=`应用名，比如usercore

`-Dskywalking.collector.backend_service=`skywalking部署的主机ip:11800（端口号不要动）

`-Dskywalking.logging.file_name=`skywalking-agent-usercore.log把usercore替换成现在这个tomcat装的应用名（再次强调：一个tomcat只能部署一个应用！）

##### [javaagent 参数](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Setting-override.md#agent-options)

一个配置示例：
```bash
java -cp /app/resources:/app/classes:/app/libs/* 
-javaagent:C:\java\svn\skywalking\skywalking-agent\skywalking-agent.jar=agent.namespace=luna_dev,agent.service_name=luna_dev_usercore,agent.span_limit_per_segment=30000,collector.backend_service=127.0.0.1:11800,logging.level=INFO
com.alibaba.dubbo.container.Main
```

##### [操作系统环境变量](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/Setting-override.md#system-environment-variables)

在docker环境下这个很有用，一个操作系统对应一个应用，环境变量很容易在k8s的配置文件里面配置，反倒是改java启动参数的方式会显得比较混乱。

### 所有支持的参数

[This is the properties list supported in `agent/config/agent.config`.](https://github.com/apache/skywalking/blob/v6.3.0/docs/en/setup/service-agent/java-agent/README.md#table-of-agent-configuration-properties)

property key | Description | Default |
----------- | ---------- | --------- | 
`agent.namespace` | Namespace isolates headers in cross process propagation. The HEADER name will be `HeaderName:Namespace`. | Not set | 
`agent.service_name` | Application(5.x)/Service(6.x) code is showed in sky-walking-ui. Suggestion: set a unique name for each service, service instance nodes share the same code | `Your_ApplicationName` |
`agent.sample_n_per_3_secs`|Negative or zero means off, by default.SAMPLE_N_PER_3_SECS means sampling N TraceSegment in 3 seconds tops.|Not set|
`agent.authentication`|Authentication active is based on backend setting, see application.yml for more details.For most scenarios, this needs backend extensions, only basic match auth provided in default implementation.|Not set|
`agent.span_limit_per_segment`|The max number of spans in a single segment. Through this config item, skywalking keep your application memory cost estimated.|Not set |
`agent.ignore_suffix`|If the operation name of the first span is included in this set, this segment should be ignored.|Not set|
`agent.is_open_debugging_class`|If true, skywalking agent will save all instrumented classes files in `/debugging` folder.Skywalking team may ask for these files in order to resolve compatible problem.|Not set|
`agent.active_v2_header`|Active V2 header in default.|`true`|
`agent.instance_uuid` |Instance uuid is the identity of an instance, skywalking treat same instance uuid as one instance.if empty, skywalking agent will generate an 32-bit uuid.   |`""`|
`agent.cause_exception_depth`|How depth the agent goes, when log all cause exceptions.|5|
`agent.active_v1_header `|Deactive V1 header in default.|`false`|
`collector.grpc_channel_check_interval`|grpc channel status check interval.|`30`|
`collector.app_and_service_register_check_interval`|application and service registry check interval.|`3`|
`collector.backend_service`|Collector skywalking trace receiver service addresses.|`127.0.0.1:11800`|
`logging.level`|The log level. Default is debug.|`DEBUG`|
`logging.file_name`|Log file name.|`skywalking-api.log`|
`logging.dir`|Log files directory. Default is blank string, means, use "system.out" to output logs.|`""`|
`logging.max_file_size`|The max size of log file. If the size is bigger than this, archive the current file, and write into a new file.|`300 * 1024 * 1024`|
`jvm.buffer_size`|The buffer size of collected JVM info.|`60 * 10`|
`buffer.channel_size`|The buffer channel size.|`5`|
`buffer.buffer_size`|The buffer size.|`300`|
`dictionary.service_code_buffer_size`|The buffer size of application codes and peer|`10 * 10000`|
`dictionary.endpoint_name_buffer_size`|The buffer size of endpoint names and peer|`1000 * 10000`|
`plugin.mongodb.trace_param`|If true, trace all the parameters in MongoDB access, default is false. Only trace the operation, not include parameters.|`false`|
`plugin.elasticsearch.trace_dsl`|If true, trace all the DSL(Domain Specific Language) in ElasticSearch access, default is false.|`false`|
`plugin.springmvc.use_qualified_name_as_endpoint_name`|If true, the fully qualified method name will be used as the endpoint name instead of the request URL, default is false.|`false`|
`plugin.toolit.use_qualified_name_as_operation_name`|If true, the fully qualified method name will be used as the operation name instead of the given operation name, default is false.|`false`|
`plugin.mysql.trace_sql_parameters`|If set to true, the parameters of the sql (typically `java.sql.PreparedStatement`) would be collected.|`false`|
`plugin.mysql.sql_parameters_max_length`|If set to positive number, the `db.sql.parameters` would be truncated to this length, otherwise it would be completely saved, which may cause performance problem.|`512`|
`plugin.solrj.trace_statement`|If true, trace all the query parameters(include deleteByIds and deleteByQuery) in Solr query request, default is false.|`false`|
`plugin.solrj.trace_ops_params`|If true, trace all the operation parameters in Solr request, default is false.|`false`|


