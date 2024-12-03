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

### avatar-cd下
安装：
1. 上传安装包解压
2. 生成my.cnf文件
3.初始化：
this.execInInstallDir("${this.installPath}/bin/mysqld --defaults-file=${this.installPath}/my.cnf  --initialize-insecure")
--initialize ：默认安全”安装（即 包括生成随机初始密码）。在这种情况下， 密码被标记为已过期，您必须选择一个新密码。root

--initialize-insecure：    生成无密码。这是 不安全的;假设您打算分配密码 在放置服务器之前及时到帐户 投入生产使用。root

配置：
运行时候  初始化sql语句
```shell
/home/avatar/fg-deploy/software/mysql/mysql-8.0.16-linux-glibc2.12-x86_64/bin/mysql --defaults-file=/home/avatar/fg-deploy/software/mysql/mysql-8.0.16-linux-glibc2.12-x86_64/my.cnf \
                                -u root --skip-password -vv -e \
                                "show databases;CREATE USER 'root'@'%' IDENTIFIED BY 'xyyweb123';GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';  flush privileges;"
```
--skip-password 跳过密码

mysql -uroot -e 'select * from mydb.user'
-v 显示语句本身
-vv 增加显示查询结果行数


开始进行同步
start slave;

```shell

[mysqld]
port=3304
#这个存疑，设置字符集比较规则，兼容企金保险，参数暴露
collation_server=utf8mb4_general_ci
#普通用户连接时执行这个语句，不知道为啥，参数暴露
init_connect='SET NAMES utf8'
#默认字符集
character-set-server=${this.getDeployConfig(env_mysql_character_set)}
#这个配置高版本已经弃用了
#default-character-set=utf8
basedir=/home/avatar/fg-deploy/software/mysqlMaster/mysql-8.0.16-linux-glibc2.12-x86_64
datadir=/home/avatar/fg-deploy/software/mysqlMaster/mysql-8.0.16-linux-glibc2.12-x86_64/data
socket=/home/avatar/fg-deploy/software/mysqlMaster/mysql-8.0.16-linux-glibc2.12-x86_64/mysql.sock
 
# mysqlx，禁用或者换路径
mysqlx=OFF
mysqlx_port=14404
mysqlx_socket=/home/avatar/fg-deploy/software/mysqlMaster/mysql-8.0.16-linux-glibc2.12-x86_64/mysqlx.sock
 
#设置忽略大小写(简单来说就是sql语句是否
严格)，默认库名表名保存为小写, 不区分大小写
lower_case_table_names=1
 
##创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
#官网说8.0.27版本之后会被废弃
default_authentication_plugin=mysql_native_password
##设置数据库事务隔离级别
transaction_isolation=READ-COMMITTED
##设置sql_mode
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
#禁止域名/主机名解析，写了就代表开启，不写默认为OFF，可以根据域名进行访问校验
skip-name-resolve
#mysql单次传送包的大小限制
max_allowed_packet=512M
 
#MySQL数据库及表(仅MyISAM)可以存储在my.cnf中指定datadir之外的分区或目录，在8.0.2以后就被废弃了
symbolic-links=0
#跳过授权表，不知道要不要，默认不要
##skip-grant-tables
##设置字符串拼接的最大长度
group_concat_max_len=102400
 
##connection conf
#能打开的最大文件数
open_files_limit=65535
##设置可连接IP：0.0.0.0是不限制IP
bind-address=0.0.0.0
##允许最大连接数,最大用户连接数
max_connections=3600
max_user_connections=3600
##允许连接失败的次数。这是为了防止有人从该主机试图攻击数据库系统
max_connect_errors=10
##服务端使用的字符集默认为UTF8
character_set_server=utf8
#只影响写入文件的时区，不影响写入表中记录的时区，默认是UTC
log_timestamps=SYSTEM
#防止binlog过多，设置超时时间，这个存疑
#skip-log-bin
 
##memory
thread_cache_size = 128
#内存表最大值
max_heap_table_size = 128M
#超过这个值会采用非内存方式存储
tmp_table_size = 128M
#存储联表时候的外表字段值
join_buffer_size = 16M
#全局的（非单个连接），只针对MyISAM引擎的索引缓存，对MyISAM表性能影响较大
key_buffer_size = 64M
#不明白干啥的，貌似只对MyISAM表生效
bulk_insert_buffer_size = 16M
 
#开启慢查询，少了一个慢查询日志文件地址
slow_query_log=1
slow_query_log_file=/home/avatar/fg-deploy/software/mysqlMaster/mysql-8.0.16-linux-glibc2.12-x86_64/slowquery.log
#查询时长超过这个值的查询会被记在慢查询日志
long_query_time=10
#未使用索引的查询是否写入慢日志
log_queries_not_using_indexes=1
#每分钟写入慢日志中的不走索引的SQL语句个数
log_throttle_queries_not_using_indexes=10
#查询扫描过的最少记录数
min_examined_row_limit=100
#慢速管理语句是否写入慢日志中
log_slow_admin_statements=1
 
##binlog conf
#主从复制的格式（mixed,statement,row，默认格式是statement）
binlog_format=row
#binlog文件过期时间
binlog_expire_logs_seconds=604800
#可以让行格式的binlog展示具体的sql
binlog_rows_query_log_events=1
#简化binlog，也就是只展示有改动的日志
binlog_row_image=minimal
#binlog缓存
binlog_cache_size=8M
#缓存的临时文件，事务提交后会释放
max_binlog_cache_size=2G
#binlog最大值
max_binlog_size=1G
#是否可以信任存储函数创建者
log_bin_trust_function_creators=1
#记录所有到达MySQL Server的sql语句
general_log=0
 
##innodb conf
#貌似这么改会报错，验证一下
innodb_data_file_path=ibdata1:1G:autoextend
##数据库服务内存缓冲空间，建议：单数据库情况下，总内存的50%，混合使用的情况下总内存的30%，取整，比如32G内存服务器30%就是9.6G取整10G
innodb_buffer_pool_size=10G
innodb_io_capacity=400
innodb_io_capacity_max=2000
#读/写操作都会跳过OS cache，直接在device（disk）上读/写，然后fsync()刷元数据
innodb_flush_method=O_DIRECT
#刷脏页的时候不带上边上的脏页
innodb_flush_neighbors=0
#控制最大 undo tablespace 文件的大小
innodb_max_undo_log_size=2G
#和下面的innodb_log_files_in_group一起控制redo log的空间
innodb_log_file_size=2G
innodb_log_files_in_group=4
#定义InnoDB用于写入磁盘上的日志文件的缓冲区的大小
innodb_log_buffer_size=32M
#最多使用线程数
innodb_thread_concurrency=16
#将死锁信息打印到错误日志中
innodb_print_all_deadlocks=1
#数据写入内存,排序后,再一次写入到磁盘的缓冲区的大小
innodb_sort_buffer_size=16M
#写线程个数
innodb_write_io_threads=4
innodb_read_io_threads=8
#将表空间分别单独存放
innodb_file_per_table=1
#允许打开文件数
innodb_open_files=65535
#配置持久化统计信息采样的页数
innodb_stats_persistent_sample_pages=64
innodb_autoinc_lock_mode=2
 
##innodb_rollback_on_timeout=1
##innodb_lock_wait_timeout=10
 
 
##master配置
##mysql数据库id
server_id=100
#因为MYSQL是基于二进制的日志来做同步的,每个日志文件大小为 1G
log-bin=mysql-bin
log-slave-updates=1
#当每进行1次事务提交之后，MySQL将进行一次fsync之类的磁盘同步指令来将binlog_cache中的数据强制写入磁盘。
sync_binlog=1
##二进制日志自动删除/过期的天数。默认值为0，表示不自动删除。
expire_logs_days=14
 
#从节点需要
#中继日志配置
#relay_log=mysql-relay-bin
#限制只读，从库的用户只能读数据，无法改变数据，数据的更新交给主库
#read_only=1
#relay-log-recovery=1
#max-relay-log-size=1G
 
#主库自增长偏移量,主库1,备库2
#自增字段的起始值
#auto_increment_offset=1
#自增字段的增长值
#auto_increment_increment=2
 
#进行镜像处理的数据库
#replicate-do-db=atsdb
#replicate-do-db=ts_mid
 
 
[mysqld_safe]
log-error=/home/avatar/fg-deploy/software/mysqlMaster/mysql-8.0.16-linux-glibc2.12-x86_64/mysqld.log
pid-file=/home/avatar/fg-deploy/software/mysqlMaster/mysql-8.0.16-linux-glibc2.12-x86_64/data/mysqld.pid
mysqld-safe-log-timestamps=SYSTEM
 
 
[client]
#指定客户端连接mysql时的socket通信文件路径
socket=/home/avatar/fg-deploy/software/mysqlMaster/mysql-8.0.16-linux-glibc2.12-x86_64/mysql.sock
default-character-set=utf8
```
## 配置简单了解
事务隔离级别：read-commited  
skip-bin-log是否配置  

## 补充  
mysql字符集比较规则中utf8_bin和utf8_general_ci的区别在于比较时是否区分大小写

## mysql 回复数据
问题：误操作将线上数据库进行了覆盖,且没有完整备份
```shell
## 查看数据库的binlog日志
SHOW BINARY LOGS;
## 通过binlog查看执行的日志
mysqlbinlog  --base64-output=decode-rows --verbose --start-datetime="2024-10-20 16:00:00" --stop-datetime="2024-10-20 17:07:59" binlog.000002

# 恢复到前面某一节点位置 
mysqlbinlog --no-defaults  binlog.000002  --stop-position=33792420  | mysql  -uroot -pxyy



2774078

# 如果后面的操作继续数据保留，仅仅误操作的中间时间节点部分，可以通过位置区间恢复 
mysqlbinlog --no-defaults /var/lib/mysql/mysql_bin.000006 --start-position=232 --stop-position=2220 | mysql -h127.0.0.1 -P3306 -uroot -p123456
```

[MySQL 开启配置binlog以及通过binlog恢复数据](https://blog.csdn.net/weixin_44606481/article/details/133344235)




  



