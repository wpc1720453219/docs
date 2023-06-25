## mysql部署

### 单机
查看word文档 执行mysql.sh脚本部署

### 主从
mysql双主和主从最大区别是
主从是对主操作数据，从会实时同步数据。反之对从操作，主不会同步数据，还有可能造成数据紊乱，导致主从失效 。
主主则是无论对那一台操作，另一个都会同步数据。一般用作高容灾方案 .（操作起来比较容易出现数据不一致双主断掉同步）

二.原理：
通过执行binlog日志里的sql语句进行复制。
db1 192.168.0.128
db2 192.168.0.127

db2 从表 获取db1 主表的数据
change master to master_host='10.0.10.43', master_user='slave', 
master_password='Hz123456', master_log_file='mysql-bin.000002', master_log_pos=2048;

开始进行同步
start slave;




  



