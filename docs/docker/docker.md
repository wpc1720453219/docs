## redis
```shell
docker rm -f luna-sunht-dev-redis
docker run -d --name luna-sunht-dev-redis \
  -p 6379:6379 \
  -e TZ=Asia/Shanghai \
  --restart=always \
  redis:5.0.13
docker logs -f luna-sunht-dev-redis
```
### 废弃
```shell
# 可以将文件映射出来
docker run -p 6380:6379 --name myredis \
-v /home/fingard/redis/redis.conf:/etc/redis/redis.conf \
-v /home/fingard/redis/data:/data
-d redis redis-server /etc/redis/redis.conf --appendonly yes
```

## zookeeper
```shell
docker rm -f luna-sunht-dev-zookeeper
docker run -d --name luna-sunht-dev-zookeeper \
  -p 2181:2181 \
  -e TZ=Asia/Shanghai \
  --restart=always \
  zookeeper:3.6.3
docker logs -f luna-sunht-dev-zookeeper
```

## mysql
```shell
mkdir -p /data/mysql/data
chmod 777 /data/mysql/data
  
docker rm -f mysql
docker run -d --name mysql \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=fingard1 \
  -v /data/mysql/data:/var/lib/mysql \
  -e TZ=Asia/Shanghai \
  --restart=always \
  mysql:5.7.28 \
  --character-set-server=utf8mb4 \
  --collation-server=utf8mb4_general_ci \
  --lower-case-table-names=1 \
  --default-storage-engine=INNODB \
  --max-connections=100000
docker logs -f mysql
```

## nacos
### nacos 默认h2数据库
```shell
mkdir -p /home/fingard/nacos/docker-data
chmod 777 /home/fingard/nacos/docker-data
 
docker pull nacos/nacos-server:1.4.2
 
docker rm -f luna-sunht-dev-nacos
docker run -d --name luna-sunht-dev-nacos \
  -p 8848:8848 \
  -v /home/fingard/nacos/docker-data:/home/nacos/data \
  -e MODE=standalone \
  -e TZ=Asia/Shanghai \
  --restart=always \
  nacos/nacos-server:1.4.2
 
docker logs -f luna-sunht-dev-nacos
```
### nacos  mysql数据库
```shell
docker run --name nacos -d -p 8848:8848  \
--privileged=true \
--restart=always  \
-e JVM_XMS=256m  \
-e JVM_XMX=256m  \
-e MODE=standalone  \
-v /home/nacos/logs:/home/nacos/logs \ 
-v /home/nacos/init.d/custom.properties:/home/nacos/init.d/custom.properties  \ 
nacos/nacos-server
```

custom.properties
```shell
erver.contextPath=/nacos
server.servlet.contextPath=/nacos
server.port=8848

spring.datasource.platform=mysql

db.num=1
db.url.0=jdbc:mysql://172.25.50.75:3309/nacos?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=GMT%2B8
db.user=root
db.password=123456


nacos.cmdb.dumpTaskInterval=3600
nacos.cmdb.eventTaskInterval=10
nacos.cmdb.labelTaskInterval=300
nacos.cmdb.loadDataAtStart=false

management.metrics.export.elastic.enabled=false

management.metrics.export.influx.enabled=false


server.tomcat.accesslog.enabled=true
server.tomcat.accesslog.pattern=%h %l %u %t "%r" %s %b %D %{User-Agent}i


nacos.security.ignore.urls=/,/**/*.css,/**/*.js,/**/*.html,/**/*.map,/**/*.svg,/**/*.png,/**/*.ico,/console-fe/public/**,/v1/auth/login,/v1/console/health/**,/v1/cs/**,/v1/ns/**,/v1/cmdb/**,/actuator/**,/v1/console/server/**
nacos.naming.distro.taskDispatchThreadCount=1
nacos.naming.distro.taskDispatchPeriod=200
nacos.naming.distro.batchSyncKeyCount=1000
nacos.naming.distro.initDataRatio=0.9
nacos.naming.distro.syncRetryDelay=5000
nacos.naming.data.warmup=true
nacos.naming.expireInstance=true
```

##RabbitMQ 3.8.23
```shell
# 多了延时队列插件
mkdir -p /home/fingard/rabbitmq38-5672/data
chmod 777 /home/fingard/rabbitmq38-5672/data
  
docker rm -f rabbitmq38-5672
  
docker run -d --name rabbitmq38-5672 \
    --hostname FMSServer\
    --restart=always \
    -p 15672:15672 \
    -p 5672:5672 \
    -e RABBITMQ_DEFAULT_USER=rabbit \
    -e RABBITMQ_DEFAULT_PASS=fingard@2 \
    -e TZ=Asia/Shanghai \
    -v /home/fingard/rabbitmq38-5672/data:/var/lib/rabbitmq/mnesia/rabbit\@rabbit38 \
    rabbit:3.8.23-fg1-delay
docker logs -f rabbitmq38-5672
```

```shell
#没有插件，上面多了个插件
docker run -d --hostname rabbit --name rabbit \
-e RABBITMQ_DEFAULT_USER=admin \
-e RABBITMQ_DEFAULT_PASS=admin \
-p 15672:15672 \
-p 5672:5672 \
rabbitmq:3-management
```
## nginx
```shell
docker run \
-p 80:80 \
-p 443:443 \
--name nginx  \
-e TZ=Asia/Shanghai \
--restart always \
-v /home/fingard/nginx/nginx.conf:/etc/nginx/nginx.conf \
-v /home/fingard/nginx/conf:/etc/nginx/conf.d \
-v /home/fingard/nginx/log:/var/log/nginx \
-v /home/fingard/nginx/html:/usr/share/nginx/html \
-v /home/fingard/nginx/keys:/etc/nginx/keys \
-d nginx:1.22.0
```
### nginx.conf
```shell
worker_processes  1;
error_log  /var/log/nginx/error.log notice;
events {
  worker_connections  1024;
}
#daemon off;
http {
  include       mime.types;
  default_type  application/octet-stream;
  client_max_body_size 100m;
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  keepalive_timeout  86400;
  proxy_read_timeout 86400; # 这个设置nginx检测的超时时间，单位秒
  proxy_send_timeout 86400;
  gzip  on;
  gzip_min_length 1k;
  gzip_buffers 4 16k;
  gzip_comp_level 4;
  gzip_types text/plain application/x-javascript application/javascript application/json text/css text/javascript application/xml application/x-httpd-php image/jpeg image/gif image/png;
  gzip_vary on;
  gzip_disable "MSIE [1-6]\.";
  
  # websocket 需要加下这个，Nginx 在 1.3 以后的版本才支持 websocket 反向代理
  map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
  }
  
  server {
    # access_log  logs/host.access.log  main;
    # 后台api接口。注意，websys的tomcat应用路径需要是/web
    location /api {
      proxy_pass http://127.0.0.1:8080;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header REMOTE-HOST $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_read_timeout 86400; # 这个设置nginx检测的超时时间，单位秒
      proxy_send_timeout 86400;
      proxy_http_version 1.1;
    }
  
    # 前端静态页面
    location / {
      root /usr/share/nginx/html;  # 这个指向前端编译好的静态页面的文件夹地址
      index index.html;
      proxy_read_timeout 86400; # 这个设置nginx检测的超时时间，单位秒
      proxy_send_timeout 86400;
      try_files $uri $uri/ /index.html; # 防止页面刷新404
    }
  }
}
```

## seata
```shell
docker run --name seata-server \
        -p 8091:8091 \
        -e SEATA_IP=192.168.0.128 \
        -e SEATA_CONFIG_NAME=file:/root/seata-config/registry \
        -v /home/fingard/seata:/root/seata-config  \
        -d seataio/seata-server:1.4.2
```

registry.conf
```shell
registry {
  # file 、nacos 、eureka、redis、zk、consul、etcd3、sofa
  type = "nacos"
 
  nacos {
    application = "seata-server"
    serverAddr = "192.168.0.128:8848"
    group = "1.4"
    namespace = ""
    cluster = "default"
    username = ""
    password = ""
  }
  eureka {
    serviceUrl = "http://localhost:8761/eureka"
    application = "default"
    weight = "1"
  }
  redis {
    serverAddr = "localhost:6379"
    db = 0
    password = ""
    cluster = "default"
    timeout = 0
  }
  zk {
    cluster = "default"
    serverAddr = "127.0.0.1:2181"
    sessionTimeout = 6000
    connectTimeout = 2000
    username = ""
    password = ""
  }
  consul {
    cluster = "default"
    serverAddr = "127.0.0.1:8500"
    aclToken = ""
  }
  etcd3 {
    cluster = "default"
    serverAddr = "http://localhost:2379"
  }
  sofa {
    serverAddr = "127.0.0.1:9603"
    application = "default"
    region = "DEFAULT_ZONE"
    datacenter = "DefaultDataCenter"
    cluster = "default"
    group = "SEATA_GROUP"
    addressWaitTime = "3000"
  }
  file {
    name = "file.conf"
  }
}
 
config {
  # file、nacos 、apollo、zk、consul、etcd3
  type = "nacos"
 
  nacos {
    serverAddr = "192.168.0.128:8848"
    namespace = ""
    group = "1.4"
    username = ""
    password = ""
    dataId = "seata.properties"
  }
  consul {
    serverAddr = "127.0.0.1:8500"
    aclToken = ""
  }
  apollo {
    appId = "seata-server"
    ## apolloConfigService will cover apolloMeta
    apolloMeta = "http://192.168.1.204:8801"
    apolloConfigService = "http://192.168.1.204:8080"
    namespace = "application"
    apolloAccesskeySecret = ""
    cluster = "seata"
  }
  zk {
    serverAddr = "127.0.0.1:2181"
    sessionTimeout = 6000
    connectTimeout = 2000
    username = ""
    password = ""
    nodePath = "/seata/seata.properties"
  }
  etcd3 {
    serverAddr = "http://localhost:2379"
  }
  file {
    name = "file.conf"
  }
}
```









## skywalking
### skywalkingAgent

构建agent镜像
```dockerfile
FROM eclipse-temurin:8-jdk
ADD apache-skywalking-apm-bin/agent /app/
WORKDIR /app
EOF
```

```shell
#构建agent镜像
docker build -t /jdk8-agent:1 .
```
###　skywalkingServer

```shell
#启动skywalking服务器
#为了去掉redis追踪以及增加jdbc驱动直接挂载了本地的oap-libs目录
docker run -d --name skywalking-oap-server --restart=always \
  -p 8080:8080 -p 11800:11800 -p 12800:12800 \
  -e SW_STORAGE=mysql \
  -e SW_JDBC_URL="jdbc:mysql://192.168.10.103:3306/skywalking?useSSL=false" \
  -e SW_DATA_SOURCE_USER=root \
  -e SW_DATA_SOURCE_PASSWORD=fingard1\
  -e SW_DATA_SOURCE_CACHE_PREP_STMTS="true" \
  -e SW_DATA_SOURCE_PREP_STMT_CACHE_SQL_SIZE=250 \
  -e SW_DATA_SOURCE_PREP_STMT_CACHE_SQL_LIMIT=2048 \
  -e SW_DATA_SOURCE_USE_SERVER_PREP_STMTS="true" \
  -e SW_STORAGE_MYSQL_QUERY_MAX_SIZE=5000 \
  -e SW_CORE_RECORD_DATA_TTL=2 \
  -e SW_CORE_METRICS_DATA_TTL=3 \
  -e JAVA_OPTS="-Xms64m -Xmx512m" \
  -v /data/luna-lixp-dev/skywalking/apache-skywalking-apm-bin/oap-libs:/skywalking/oap-libs \
apache/skywalking-oap-server:8.9.1

#启动skywalking ui
docker run --name skywalking-ui \
--restart=always \
-d -p 8088:8080  \
-e SW_OAP_ADDRESS=http://192.168.10.103:12800  \
apache/skywalking-ui:8.9.1 
```


## es
```shell
#启动命令
#--privileged用来保证权限的最大化
#加入-e ES_JAVA_OPTS="-Xms64m -Xmx512m"来限制内存
docker run -d --name luna-lixp-dev-es \
 -p 9200:9200  \
 -p 9300:9300  \
 -e "discovery.type=single-node"  \
 -e ES_JAVA_OPTS="-Xms64m -Xmx512m"  \
 -v /data/luna-lixp-dev/es/docker/data:/usr/share/elasticsearch/data  \
 -v /data/luna-lixp-dev/es/docker/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml  \
 --privileged=true \
 --restart=always  \
 docker.elastic.co/elasticsearch/elasticsearch:7.16.0
 
#挂载目录自己创建，elasticsearch.yml配置如下
cat > /data/luna-lixp-dev/es/docker/config/elasticsearch.yml<<EOF
network.host: 0.0.0.0
http.port: 9200
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
EOF
```

## kibana
```shell
#启动命令
docker run -d -p 5601:5601  \
--name=luna-lixp-dev-kibana  \
--restart=always  \
-v /data/luna-lixp-dev/kibana/docker/config/kibana.yml:/usr/share/kibana/config/kibana.yml \
docker.elastic.co/kibana/kibana:7.16.0
 
#kibana.yml配置文件
cat > /data/luna-lixp-dev/kibana/docker/config/kibana.yml<<EOF
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://192.168.10.103:9200"]
i18n.locale: "zh-CN"
EOF
```
## filebeat
```shell
#配置filebeat的挂载目录
mkdir -p /data/luna-lixp-dev/filebeat/docker/config
 
#配置文件
cp /data/luna-lixp-dev/filebeat/filebeat-7.16.1-linux-x86_64/filebeat.yml /data/luna-lixp-dev/filebeat/docker/config/
 
#启动
docker run -d --name luna-lixp-dev-filebeat \
  --restart=always \
  --user=root \
  -v /data/luna-lixp-dev/filebeat/docker/config/filebeat.yml:/usr/share/filebeat/filebeat.yml \
  -v /data/docker-logs:/data/docker-logs \
  docker.elastic.co/beats/filebeat:7.16.0
```



## 通用的docker应用

```dockerfile
FROM jdk8-agent
ENV TZ=Asia/Shanghai 
ENV JAVA_OPTS="-Xms512m -Xmx512m"
WORKDIR /app
CMD /bin/bash  /app/start.sh
```

```shell
docker run -d --name luna-jar-gateway \
-p 8800:8080 \
-e TZ=Asia/Shanghai \
-e JAVA_OPTS="-Xms2012m -Xmx2012m"  \
--restart always \
-v /home/data/tool/msApp/bin/gateway/ats-gateway.jar:/app/ats-gateway.jar \
-v /home/data/tool/msApp/bin/gateway/start.sh:/app/start.sh  \
luna-jar
```


start.sh
```shell
ENV_JVM_FLAGS="$ENV_JVM_FLAGS -Dspring.cloud.nacos.server-addr=192.168.0.128:8848
-Dspring.cloud.nacos.username=nacos
-Dspring.cloud.nacos.password=nacos
-Dspring.cloud.nacos.config.group=1.4
-Dspring.cloud.nacos.config.shared-configs[0].data-id=PUBLIC-COMMON.properties
-Dspring.cloud.nacos.config.shared-configs[0].refresh=false
-Dspring.cloud.nacos.config.shared-configs[0].group=1.4
-Dluna.framework.starter.configcenter.nacos.enable=true"
ENV_SKYWALKING_AGENT="$ENV_SKYWALKING_AGENT -javaagent:/app/skywalking-agent.jar
-Dskywalking.agent.namespace=fg
-Dskywalking.agent.service_name=fg-gateway
-Dskywalking.agent.span_limit_per_segment=30000
-Dskywalking.collector.backend_service=192.168.0.128:11800
-Dskywalking.logging.file_name=skywalking-agent-avat.log
-Dskywalking.logging.level=INFO -Dskywalking.trace.ignore_path=/eureka/**"
java  $ENV_SKYWALKING_AGENT $ENV_JVM_FLAGS -Dserver.port=8080 -jar /app/ats-gateway.jar
```





```shell
#某应用服务
FROM jdk8-agent:1
ENV ENV_JVM_FLAGS="-Dspring.cloud.nacos.server-addr=192.168.10.103:8848 \
 -Dspring.cloud.nacos.username=nacos 
 -Dspring.cloud.nacos.password=nacos 
 -Dspring.cloud.nacos.config.group=1.3 
 -Dspring.cloud.nacos.config.shared-configs[0].data-id=PUBLIC-COMMON.properties 
 -Dspring.cloud.nacos.config.shared-configs[0].refresh=false 
 -Dspring.cloud.nacos.config.shared-configs[0].group=1.3 
 -Dspring.cloud.nacos.discovery.namespace=luna-wangpc-dev 
 -Dspring.cloud.nacos.config.namespace=luna-wangpc-dev 
 -Dluna.framework.starter.configcenter.nacos.enable=true"
ENV ENV_SKYWALKING_AGENT="-javaagent:/app/skywalking-agent.jar 
-Dskywalking.agent.namespace=fg 
-Dskywalking.agent.service_name=fg-workflow  
-Dskywalking.agent.span_limit_per_segment=30000 
-Dskywalking.collector.backend_service=192.168.10.103:11800 
-Dskywalking.logging.file_name=skywalking-agent-avat.log 
-Dskywalking.logging.level=INFO 
-Dskywalking.trace.ignore_path=/eureka/**"
ADD luna-workflow.jar /app/
WORKDIR /app
CMD bash -c "java $ENV_SKYWALKING_AGENT $ENV_JVM_FLAGS -Dserver.port=8080 -jar /app/luna-workflow.jar"
```













