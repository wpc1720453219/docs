# 问题汇总

### filebeat后台进程挂掉
参考[systemctl启动filebeat](https://blog.51cto.com/3922078/2383158)

[官网systemctl启动教程](https://www.elastic.co/guide/en/beats/filebeat/master/running-with-systemd.html)


### 解决日志的时间戳被filebeat的读取时间戳覆盖的问题

[解决filebeat的@timestamp无法被json日志的同名字段覆盖的问题](https://blog.csdn.net/cja_java/article/details/84903676)

[官网配置文档：Log input](https://www.elastic.co/guide/en/beats/filebeat/6.4/filebeat-input-log.html)

关键是在`input`里面添加以下两行

```yaml
json.keys_under_root: true
json.overwrite_keys: true
```
示例：
```yaml{6,7}
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /data/gardpay/logs/*/filebeat/**/*.log
    json.keys_under_root: true
    json.overwrite_keys: true
setup.template.name: "gardpay"
setup.template.pattern: "gardpay-*"
setup.kibana:
  host: "10.60.45.174:5601"
output.elasticsearch:
  hosts: ["10.60.45.174:9200"]
  index: "gardpay-test-%{[beat.version]}-%{+yyyy.MM.dd}"
xpack.monitoring.enabled: true

```

### filebeat部署了，es没收到日志
可能产生这种现象的原因：
- filebeat运行的进程，没有读取日志目录的权限；
- filebeat版本号不对，比如`elk`系列用的`6.4.2`，`filebeat`却用的`7.2.0`，这个会造成版本不兼容。
    - `elastic`系列组件的版本应该保持一致（至少版本号的前两个数字必须相同）
- filebeat的配置文件时`yml`格式的，必须严格遵守格式规则，`空格`不能换`tab`，空格不能多也不能少。
    - 至于配置的内容，参考[`filebeat.reference.yml`](https://www.elastic.co/guide/en/beats/filebeat/6.4/filebeat-reference-yml.html)文件内容：


### 解决es只读问题
遇到了es判断硬盘空间占用超过95%的情况，然后把所有的索引写入禁用了，
es端报这样的错：
```
[2020-02-26T10:55:41,839][INFO ][o.e.c.r.a.DiskThresholdMonitor] [es-58] rerouting shards: [high disk watermark exceeded on one or more nodes]
[2020-02-26T10:56:11,881][WARN ][o.e.c.r.a.DiskThresholdMonitor] [es-58] high disk watermark [90%] exceeded on [JY0u14THQS23XJUexUJEcg][es-58][/usr/share/elasticsearch/data/nodes/0] free: 28.3gb[6.5%], shards will be relocated away from this node
```
即使硬盘空间清理出来以后，也还是只读状态，filebeat报如下的错：
```
{"type":"cluster_block_exception","reason":"blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];
```
这时就需要手动解除只读锁定，比如用idea发rest请求：
```http request
### 去除只读模式
PUT http://10.60.44.58:9200/_all/_settings
Content-Type: application/json

{
  "index.blocks.read_only_allow_delete": null
}
```
[参考链接](https://blog.csdn.net/qq_14965807/article/details/79400481)


