## k8s问题排查
排查逻辑
日志→问题
无日志→查看event后考虑可能的原因
没有头绪→考虑本地运行镜像
镜像本身没问题→考虑配置因素


k8s集群问题排查
先看k3s服务是否正常
再看节点是否ready
再排查各种资源（CPU、内存、磁盘占用）


## 通用yaml说明

### 创建命名空间
```yaml
# k8s api版本
apiVersion: v1
# k8s api类型
kind: Namespace
# api通用字段
metadata:
  # 名称
  name: luna-pc-dev
```

### redis
```yaml
---
# k8s api版本
apiVersion: v1
# k8s api类型
kind: Service
# api通用字段
metadata:
  # 名称
  name: redis
  # 命名空间
  namespace: luna-pc-dev
# 这个api特有的字段
spec:
  # NodePort类型可以提供端口映射，把k8s内部的端口映射到所有宿主机
  type: NodePort
  # 端口声明，可以有多个
  ports:
      # port是这个负载均衡器的端口
    - port: 6379
      # targetPort是容器内部应用开放的实际端口
      targetPort: 6379
      # nodePort是映射到宿主机的端口
      nodePort: 16379
  # Service的概念是负载均衡器、反向代理，要代理哪个pod要看这里的配置
  selector:
    # pod的label标签，根据k-v匹配
    app: redis
    
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: luna-pc-dev
spec:
  # 选择器，这个是固定格式，一般不变
  selector:
    # 标签匹配
    matchLabels:
      # pod的label标签，根据k-v匹配
      app: redis
  # 副本数
  replicas: 1
  # pod模板，下面的是pod api
  template:
    # 通用字段
    metadata:
      # 标签
      labels:
        # k-v结构的标签，和其他应用做区分，一般用app为key
        app: redis
        # 版本，可有可无，istio会用到这个label
        version: v1
    # pod api特有的字段
    spec:
      # 容器，可以有多个
      containers:
        # 容器名，一般和deploy名称对应
        - name: redis
          # 镜像
          image: redis:5.0.13
          # 资源声明，我们一般声明内存资源，cpu一般不做限制。
          # cpu时间片几乎可无限分，没什么限制；
          # 内存超出物理内存会导致这个节点挂掉，这个节点的其他命名空间/环境的pod也跟着挂
          resources:
            requests:
              # 内存请求，节点有至少这么多空余的内存请求、实际内存值，采会调度到这个节点
              memory: "300Mi"
            limits:
              # 内存限制：容器内部超这个内存，进程会被杀掉。而pod默认是自动重启，表现就是经常重启
              memory: "300Mi"
          # 环境变量，这里的值注意一定要是字符串，遇到数字需要加双引号
          env:
            - name: TZ
              value: Asia/Shanghai
          # 端口声明，可有可无
          ports:
            - containerPort: 6379
          # 挂载卷，也就是硬盘挂载，可以有多个
          volumeMounts:
            # 名称，需要填下面volumes字段声明过的名称
            - name: redis-data
              # 挂载路径
              mountPath: /var/lib/redis
      # 卷声明
      volumes:
        # 名称
        - name: redis-data
          # emptyDir表示空文件夹，这个唯一的作用，就是Pod内部的容器container重启后，这个路径的数据不会丢失，pod自身被删掉了还是会丢的。
          # redis挂一个这个特性的文件夹，可以一定程度保证数据的稳定性。
          emptyDir: {}
```

### zookeeper
```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: zookeeper
  namespace: luna-pc-dev
spec:
  # 这里使用默认的Service类型：ClusterIP，这个只能k8s内部访问
  ports:
    - port: 2181
      name: client
  selector:
    app: zookeeper
 
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: zookeeper
  namespace: luna-pc-dev
spec:
  selector:
    matchLabels:
      app: zookeeper
  replicas: 1
  template:
    metadata:
      labels:
        app: zookeeper
        version: v1
    spec:
      containers:
        - name: zookeeper
          image: zookeeper:3.6.3
          ports:
            - containerPort: 2181
              name: client
          env:
            - name: TZ
              value: Asia/Shanghai
            - name: ZOO_MAX_CLIENT_CNXNS
              # 数字格式的值，必需加引号，不然会报错
              value: '10000'
          resources:
            requests:
              memory: "300Mi"
            limits:
              memory: "300Mi"
          volumeMounts:
            - mountPath: /data
              name: data
            - mountPath: /datalog
              name: datalog
      volumes:
        - name: data
          emptyDir: {}
        - name: datalog
          emptyDir: {}
```

### nacos
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nacos
  namespace: luna-pc-dev
  labels:
    app: nacos
spec:
  ports:
    - port: 8848
      # 这里没写targetPort，通过port名称关联
      name: nacos-client
  selector:
    app: nacos
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nacos
  namespace: luna-pc-dev
spec:
  rules:
      # 通过这个域名，把http服务映射出去
    - host: "nacos.luna-pc-dev.pc.xyyweb.vm"
      http:
        paths:
          - backend:
              service:
                name: nacos
                port:
                  number: 8848
            path: /
            pathType: Prefix
 
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nacos
  namespace: luna-pc-dev
spec:
  selector:
    matchLabels:
      app: nacos
  replicas: 1
  template:
    metadata:
      labels:
        app: nacos
    spec:
      containers:
        - name: nacos
          image: nacos/nacos-server:1.4.2
          ports:
            - containerPort: 8848
              # 端口名称，用来关联service
              name: nacos-client
          env:
            - name: TZ
              value: Asia/Shanghai
            - name: MODE
              value: standalone
            # 通过环境变量的方式指定数据库，具体用哪些环节变量，上docker hub看镜像文档
            - name: SPRING_DATASOURCE_PLATFORM
              value: mysql
            - name: MYSQL_SERVICE_HOST
              value: "192.168.10.104"
            - name: MYSQL_SERVICE_PORT
              value: "3306"
            - name: MYSQL_SERVICE_DB_NAME
              value: "luna_pc_dev_nacos"
            - name: MYSQL_SERVICE_USER
              value: "root"
            - name: MYSQL_SERVICE_PASSWORD
              value: "xyyweb1"
          resources:
            requests:
              memory: "1200Mi"
            limits:
              memory: "1200Mi"
          # 无状态应用，这里就不做硬盘映射了
```

```shell
参考前面的nacos导入配置步骤，导入nacos配置；注意redis、zookeeper地址变了，这里直接使用k8s内部域名、也就是service名字访问。

redis：
redis:6379
简单域名，也就是service名称
redis.luna-pc-dev:6379
带上命名空间
redis.luna-pc-dev.svc.cluster.local:6379
全路径域名
zookeeper：
zookeeper:2181
```


### ui
```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ui
  namespace: luna-pc-dev
data:
  # configmap典型的k-v格式
  holder: "占位符"
  # 【|-】符号下面可以是多行文本，这段多行文本会保留换行符、自动删掉空格前缀。
  nginx.conf: |-
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
      log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                          '\$status \$body_bytes_sent "\$http_referer" '
                          '"\$http_user_agent" "\$http_x_forwarded_for"';
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
      gzip_disable "MSIE [1-6]\\.";
      
      # websocket 需要加下这个，Nginx 在 1.3 以后的版本才支持 websocket 反向代理
      map \$http_upgrade \$connection_upgrade {
        default upgrade;
        ''      close;
      }
      
      server {
        # access_log  logs/host.access.log  main;
        # 后台api接口。注意，websys的tomcat应用路径需要是/web
        location /api {
          proxy_pass http://gateway:8080;
          proxy_set_header Host \$host;
          proxy_set_header X-Real-IP \$remote_addr;
          proxy_set_header REMOTE-HOST \$remote_addr;
          proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
          proxy_read_timeout 86400; # 这个设置nginx检测的超时时间，单位秒
          proxy_send_timeout 86400;
          proxy_http_version 1.1;
        }
      
        # 前端静态页面
        location / {
          root /dist;  # 这个指向前端编译好的静态页面的文件夹地址
          index index.html;
          proxy_read_timeout 86400; # 这个设置nginx检测的超时时间，单位秒
          proxy_send_timeout 86400;
          try_files \$uri \$uri/ /index.html; # 防止页面刷新404
        }
      }
    }
---
# 为防止nginx以下报错，事先声明gateway的service
# nginx: [emerg] host not found in upstream "gateway" in /etc/nginx/nginx.conf:37
apiVersion: v1
kind: Service
metadata:
  name: gateway
  namespace: luna-pc-dev
  labels:
    app: gateway
spec:
  ports:
    - port: 8080
      name: gateway
  selector:
    app: gateway
---
apiVersion: v1
kind: Service
metadata:
  name: ui
  namespace: luna-pc-dev
  labels:
    app: ui
spec:
  ports:
    - port: 80
      name: ui
  selector:
    app: ui
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ui
  namespace: luna-pc-dev
spec:
  rules:
    - host: "ui.luna-pc-dev.pc.xyyweb.vm"
      http:
        paths:
          - backend:
              service:
                name: ui
                port:
                  number: 80
            path: /
            pathType: Prefix

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ui
  namespace: luna-pc-dev
spec:
  selector:
    matchLabels:
      app: ui
  replicas: 1
  template:
    metadata:
      labels:
        app: ui
    spec:
      containers:
        - name: ui
          # 这里填全路径的镜像名，由于不知道最新版是多少，初始化的时候一般用latest
          image: 192.168.10.104:4800/luna-pc-dev/ui:latest
          ports:
            - containerPort: 80
              name: http
          env:
            - name: TZ
              value: Asia/Shanghai
          resources:
            requests:
              memory: "100Mi"
            limits:
              memory: "100Mi"
          volumeMounts:
            # 挂载文件的路径
            - mountPath: /etc/nginx/nginx.conf
              # 卷声明的名称
              name: config
              # 配置在configMap中的key的名称
              subPath: nginx.conf
      # volumes和containers同级别
      volumes:
        # 卷名称
        - name: config
          # 使用configMap作为这个卷
          configMap:
            # configMap的名称
            name: ui

```
### 后端jar
```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: java-common-config
  namespace: luna-pc-dev
data:
  # configmap典型的k-v格式
  holder: "占位符"
  # 【>-】符号下面可以是多行文本，这段多行文本会自动删除换行符、替换为空格。参考教程：【https://ruanyifeng.com/blog/2016/07/yaml.html】
  ENV_JVM_FLAGS: >-
    -Dspring.cloud.nacos.server-addr=nacos.luna-pc-dev:8848
    -Dspring.cloud.nacos.username=nacos
    -Dspring.cloud.nacos.password=nacos
    -Dspring.cloud.nacos.config.group=1.3
    -Dspring.cloud.nacos.config.shared-configs[0].data-id=PUBLIC-COMMON.properties
    -Dspring.cloud.nacos.config.shared-configs[0].refresh=false
    -Dspring.cloud.nacos.config.shared-configs[0].group=1.3
    -Dspring.cloud.nacos.discovery.namespace=luna-pc-dev
    -Dspring.cloud.nacos.config.namespace=luna-pc-dev
    -Dluna.framework.starter.configcenter.nacos.enable=true
---

apiVersion: v1
kind: Service
metadata:
  name: gateway
  namespace: luna-pc-dev
  labels:
    app: gateway
spec:
  ports:
    - port: 8080
      name: http
  selector:
    app: gateway
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gateway
  namespace: luna-pc-dev
spec:
  rules:
    - host: "gateway.luna-pc-dev.pc.xyyweb.vm"
      http:
        paths:
          - backend:
              service:
                name: gateway
                port:
                  number: 8080
            path: /
            pathType: Prefix

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gateway
  namespace: luna-pc-dev
spec:
  selector:
    matchLabels:
      app: gateway
  replicas: 1
  template:
    metadata:
      labels:
        app: gateway
    spec:
      containers:
        - name: gateway
          image: 192.168.10.104:4800/luna-pc-dev/gateway:latest
          ports:
            - containerPort: 8080
              name: http
          env:
            - name: TZ
              value: Asia/Shanghai
            - name: ENV_JVM_FLAGS
              valueFrom:
                configMapKeyRef:
                  name: java-common-config
                  key: ENV_JVM_FLAGS
          resources:
            requests:
              memory: "500Mi"
            limits:
              memory: "500Mi"
          # 启动状态检查
          readinessProbe:
            # 检查tcp端口
            tcpSocket:
              port: 8080
            # 首次检查等待时间
            initialDelaySeconds: 5
            # 检查多少次
            failureThreshold: 5
            # 检查时间间隔
            periodSeconds: 10
```

### kibana
```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: kibana
  namespace: luna-lixp-dev
data:
  holder: "占位符"
  kibana.yml: |-
    server.host: "0.0.0.0"
    elasticsearch.hosts: ["http://192.168.10.104:9200"]
    i18n.locale: "zh-CN"
---
apiVersion: v1
kind: Service
metadata:
  name: kibana
  namespace: luna-lixp-dev
  labels:
    app: kibana
spec:
  type: NodePort
  ports:
    - port: 5601
      targetPort: 5601
      nodePort: 15601
      name: kibana
  selector:
    app: kibana
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kibana
  namespace: luna-lixp-dev
spec:
  rules:
    - host: "kibana.luna-lixp-dev.lixp.xyyweb.vm"
      http:
        paths:
          - backend:
              service:
                name: kibana
                port:
                  number: 5601
            path: /
            pathType: Prefix
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kibana
  namespace: luna-lixp-dev
spec:
  selector:
    matchLabels:
      app: kibana
  replicas: 1
  template:
    metadata:
      labels:
        app: kibana
    spec:
      containers:
        - name: kibana
          image: docker.elastic.co/kibana/kibana:7.16.0
          ports:
            - containerPort: 5601
              name: http
          env:
            - name: TZ
              value: Asia/Shanghai
          resources:
            requests:
              memory: "1000Mi"
            limits:
              memory: "1000Mi"
          readinessProbe:
            tcpSocket:
              port: 5601
            initialDelaySeconds: 5
            failureThreshold: 5
            periodSeconds: 10
          volumeMounts:
            - mountPath: /usr/share/kibana/config/kibana.yml
              name: config
              subPath: kibana.yml
      volumes:
        - name: config
          configMap:
            name: kibana
```
### filebeat
filebeat.yaml：用于创建一个配置映射，实际上filebeat在每个服务启动的时候都需要启动一个（在同一个pod中），所以主要的容器配置在各个服务的yaml中
```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: filebeat
  namespace: luna-lixp-dev
data:
  holder: "占位符"
  filebeat.yml: |-
   filebeat.inputs:
     - type: log
       enabled: true
       paths:
         - /root/luna/logs/*/*/*/*filebeat*.log
       json.keys_under_root: true
       json.overwrite_keys: true
   setup.ilm.enabled: false
   setup.template.name: "my-log"
   setup.template.pattern: "my-log-*"
   
   
   filebeat.config.modules:
   
     path: ${path.config}/modules.d/*.yml
   
   
     reload.enabled: false
   
   
   
   setup.template.settings:
     index.number_of_shards: 1
   
   setup.kibana:
   
   output.elasticsearch:
     hosts: ["192.168.10.104:9200"]
   
     index: "my-log-%{+yyyy.MM.dd}"
   
   processors:
     - add_host_metadata:
         when.not.contains.tags: forwarded
     - add_cloud_metadata: ~
     - add_docker_metadata: ~
     - add_kubernetes_metadata: ~
   
   

以gateway为例
#---
#apiVersion: v1
#kind: Service
#metadata:
#  name: gateway
#  namespace: luna-lixp-dev
#  labels:
#    app: gateway
#spec:
#  ports:
#    - port: 8080
#      name: http
#  selector:
#    app: gateway
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gateway
  namespace: luna-lixp-dev
spec:
  rules:
    - host: "gateway.luna-lixp-dev.lixp.xyyweb.vm"
      http:
        paths:
          - backend:
              service:
                name: gateway
                port:
                  number: 8080
            path: /
            pathType: Prefix

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gateway
  namespace: luna-lixp-dev
spec:
  selector:
    matchLabels:
      app: gateway
  replicas: 1
  template:
    metadata:
      labels:
        app: gateway
    spec:
      containers:
        - name: gateway
          image: 192.168.10.104:4800/luna-lixp-dev/gateway:latest
          ports:
            - containerPort: 8080
              name: http
          env:
            - name: TZ
              value: Asia/Shanghai
            - name: ENV_JVM_FLAGS
              valueFrom:
                configMapKeyRef:
                  name: java-common-config
                  key: ENV_JVM_FLAGS
          volumeMounts:
            - mountPath: /root/luna/logs
              name: logdata
          resources:
            requests:
              memory: "500Mi"
            limits:
              memory: "500Mi"
          # 启动状态检查
          readinessProbe:
            # 检查tcp端口
            tcpSocket:
              port: 8080
            # 首次检查等待时间
            initialDelaySeconds: 5
            # 检查多少次
            failureThreshold: 5
            # 检查时间间隔
            periodSeconds: 10
        - name: filebeat
          image: docker.elastic.co/beats/filebeat:7.16.0
          args: [
            "-c", "/opt/filebeat/filebeat.yml",
            "-e"
          ]
#          env:
#            - name: POD_IP
#              valueFrom:
#                fieldRef:
#                  fieldPath: status.podIP
#                  apiVersion: v1
#            - name: pod_name
#              valueFrom:
#                fieldRef:
#                  fieldPath: metadata.name
#                  apiVersion: v1
          volumeMounts:
            - mountPath: /opt/filebeat/
              name: config
            - mountPath: /root/luna/logs
              name: logdata
          resources:
            requests:
              memory: "500Mi"
            limits:
              memory: "500Mi"
      volumes:
        - name: logdata
          emptyDir: {}
        - name: config
          configMap:
            name: filebeat
            items:
              - key: filebeat.yml
                path: filebeat.yml
```




### kuboard
```yaml
# k8s api版本
apiVersion: networking.k8s.io/v1
# k8s api类型
kind: Ingress
# api通用字段
metadata:
  # 名称
  name: kuboard
  # 命名空间
  namespace: kuboard
# 这个api特有的字段
spec:
  # 映射规则，可以填多个，不过一般填一个
  rules:
      # 域名，后面必需跟上域名通配
    - host: kuboard.pc.xyyweb.vm
      # http映射
      http:
        # http的路径，可以填多个，不过一般只填根路径【/】
        paths:
            # 要转发的后端
          - backend:
              # k8s官方的服务api
              service:
                # 服务名
                name: kuboard-v3
                # 端口
                port:
                  # 端口号，其他的也可以通过端口名指定
                  number: 80
            # http转发路径，一般为根路径【/】
            path: /
            # 路径类型，一般为前缀，根路径+前缀代表转发这个域名的所有流量
            pathType: Prefix
```


