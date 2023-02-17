# Zookeeper
1. [ZooKeeper-3.4.10 源码的一个Bug:创建临时节点时数据不能为空](https://blog.csdn.net/hikeboy/article/details/86029882)
    - 建议用3.5以上的版本

## Zookeeper安装
### zookeeper单机版安装
首先确保正确安装了java 8。`JAVA_HOME`、`JRE_HOME`环境变量指向正常。
`java -version`能正确输出。

解压安装：
```bash
tar -zxf zookeeper-3.4.14.tar.gz
```
配置：
```bash
export zookeeperSoftwarePath="你安装zookeeper的路径"
export zookeeper_port="2181"
cat << EOF > $zookeeperSoftwarePath/conf/zoo.cfg
tickTime=2000
initLimit=10
syncLimit=5
maxClientCnxns=10000
dataDir=$zookeeperSoftwarePath/data
dataLogDir=$zookeeperSoftwarePath/dataLog
clientPort=$zookeeper_port
autopurge.snapRetainCount=3
autopurge.purgeInterval=1
EOF
```
启动：
```bash
bin/zkServer.sh start
```
状态：
```bash
bin/zkServer.sh status
```
关闭：
```bash
bin/zkServer.sh stop
```

### zookeeper集群安装
zookeeper一般用3节点集群保证高可用。

除配置外，其他步骤与单机版相同。

配置：
```bash
# 改配置
export zookeeper_port="当前节点的zookeeper端口"
export myid="当前zookeeper节点的id，如：1、2、3"
export zookeeperSoftwarePath="你安装zookeeper的路径"

mkdir -p $zookeeperSoftwarePath/dataLog
mkdir -p $zookeeperSoftwarePath/data
echo $myid > $zookeeperSoftwarePath/data/myid
cat << EOF > $zookeeperSoftwarePath/conf/zoo.cfg
tickTime=2000
initLimit=10
syncLimit=5
maxClientCnxns=10000
dataDir=$zookeeperSoftwarePath/data
dataLogDir=$zookeeperSoftwarePath/dataLog
clientPort=$zookeeper_port
autopurge.snapRetainCount=3
autopurge.purgeInterval=1

server.1=${env_zookeeper_cluster_1_host}:${env_zookeeper_cluster_1_port1}:${env_zookeeper_cluster_1_port2}
server.2=${env_zookeeper_cluster_2_host}:${env_zookeeper_cluster_2_port1}:${env_zookeeper_cluster_2_port2}
server.3=${env_zookeeper_cluster_3_host}:${env_zookeeper_cluster_3_port1}:${env_zookeeper_cluster_3_port2}
EOF

echo "zookeeper集群节点${myid}安装成功"
```
ip端口示例：
```
server.1=10.60.44.54:2881:3881
server.2=10.60.44.54:2882:3882
server.3=10.60.44.54:2883:3883
```

