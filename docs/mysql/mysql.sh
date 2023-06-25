#!/bin/sh
. /etc/rc.d/init.d/functions
export LANG=zh_CN.UTF-8

#更改挂载目录
kk="/home"
k=$kk

#一级菜单
menu1()
{
curPath=$(dirname $(readlink -f "$0"))


        clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |****   欢迎使用mysql安装工具   ****|";echo
msgbox "pam" "  |****   适用于 mysql-8.0.16-linux-glibc2.12-x86_64版本 ****|";echo
msgbox "pam" "  |****   注意：                                         ****|";echo
msgbox "pam" "  |****   1.确保/etc 下有my.cnf 没有可以创建一个空的 ****|";echo
msgbox "pam" "  |****   当前目录【 $curPath 】           ****|";echo
msgbox "pam" "  └----------------------------------------┘";echo
        cat <<EOF
0. mysql环境变量
1. 目录安装
2. 压缩包安装
3. 权限赋予
4. 修正my.cnf
5. mysql初始化
6. 授权查看服务启动列表
7. 启动
8. 查看mysql状态
9. 查看初始化密码
10. 一键安装
11. 卸载
12. 退出
EOF
        read -p "选项0-10，自己看着选[0-10]:" num1
}



huanjing()
{
chk_nf=`cat /etc/profile | grep MYSQL_HOME |wc -l`
    if [ $chk_nf -eq 0 ];then
        cat >>/etc/profile<<EOF
export MYSQL_HOME=$k/DB/mysql
export PATH=$PATH:$k/DB/mysql/bin
EOF
    sysctl -p
    else
        echo "环境变量已存在，请手动修改。"
    fi
}

#mysql
mysqldirectoryinstallation()
{
mkdir -p $k/DB/mysql
mkdir -p $k/DB/atsdb
mkdir -p $k/DB/log
mkdir -p $k/DB/temp
mkdir -p $k/tool
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload
echo "====目录安装完成！！！========================"
}

unzip()
{
echo "========================mysql安装========================"
echo "========================判断是否已经安装mysql========================"
testPath1="$k/DB/mysql/bin"
if [[ -e "$testPath1" ]];
then
       msgbox "alert" "mysql已经安装了！！！";echo
else
       msgbox "pam" "========================未检测到mysql安装，继续安装========================";echo
       msgbox "pam" "========================解压mysql中========================";echo
#日志目录
log="$k/mysqll.log"
exec 2>>$log
#获取当前时间
curtime=`date +"%Y/%m/%d  %H:%M:%S"`
#打开指定目录
cd $k
#获取目录中的文件数
count=`ls -l|grep '^-'|wc -l`
#对目录中的每个文件进行操作，判断目录中是否有文件
if [ $count -ne  0  ];then
       for i in `ls -1`
           do
               echo "操作文件名：mysql-*-linux-*-x86_64.tar.xz ">>$log;
# 将文件解压到指定目录
               tar xvf $k/mysql-*-linux-*-x86_64.tar.xz -C $k/tool;
           done
       echo "$curtime ,执行成功,操作数目: $count">>$log
else
    echo "$curtime nuodongiot is empty.">>$log
     msgbox "pam" "========================解压完成========================";echo
fi
mv $k/tool/mysql-*-linux-*-x86_64/* $k/DB/mysql
fi
}

permissions()
{
groupadd mysql
useradd -g mysql mysql
chown -R mysql.mysql $k/DB
msgbox "pam" "========================权限赋予成功========================";echo
}

mycnf()
{
cat << EOF > /etc/my.cnf
[mysqld]
##base conf

user=mysql
port=3306

basedir=$k/DB/mysql
datadir=$k/DB/atsdb
tmpdir=$k/DB/temp
socket=$k/DB/atsdb/mysql.sock
pid-file=$k/DB/atsdb/mysqld.pid


lower_case_table_names=1

##创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
default_authentication_plugin=mysql_native_password
##设置数据库事务隔离级别
transaction_isolation=READ-COMMITTED
##设置sql_mode
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
skip-name-resolve 
max_allowed_packet=512M

symbolic-links=0
##skip-grant-tables
##设置最大长度
group_concat_max_len=102400


##connection conf
open_files_limit=65535
##设置可连接IP：0.0.0.0是不限制IP
bind-address=0.0.0.0
##允许最大连接数,最大用户连接数
max_connections=3600
max_user_connections=3600
##允许连接失败的次数。这是为了防止有人从该主机试图攻击数据库系统
max_connect_errors=10
##服务端使用的字符集默认为UTF8
character-set-server=utf8



##memory
thread_cache_size = 128
max_heap_table_size = 128M
tmp_table_size = 128M
join_buffer_size = 16M
key_buffer_size = 64M
bulk_insert_buffer_size = 16M


##log conf
log-error=$k/DB/log/mysqld.log
slow_query_log_file=$k/DB/log/slowquery.log

slow_query_log=1
long_query_time=10
log_queries_not_using_indexes=1
log_throttle_queries_not_using_indexes=10
min_examined_row_limit=100
log_slow_admin_statements=1

##binlog conf
log_bin=$k/DB/atsdb/mysql-bin
binlog_format=row
binlog_expire_logs_seconds=604800
binlog_rows_query_log_events=1
binlog_row_image=minimal
binlog_cache_size=8M
max_binlog_cache_size=2G
max_binlog_size=1G
log_bin_trust_function_creators=1
general_log =0
general_log_file=$k/DB/log/general.log


##innodb conf
innodb_data_file_path=ibdata1:1G:autoextend

##数据库服务内存缓冲空间，建议：单数据库情况下，总内存的50%，混合使用的情况下总内存的30%，取整，比如32G内存服务器30%就是9.6G取整10G
innodb_buffer_pool_size=10G
innodb_io_capacity=400
innodb_io_capacity_max=2000
innodb_flush_method=O_DIRECT
innodb_flush_neighbors=0
innodb_max_undo_log_size=2G
innodb_log_file_size=2G
innodb_log_files_in_group=4
innodb_log_buffer_size=32M
innodb_thread_concurrency=16
innodb_print_all_deadlocks=1
innodb_sort_buffer_size=16M
innodb_write_io_threads=4
innodb_read_io_threads=8
innodb_file_per_table=1
innodb_open_files=65535
innodb_stats_persistent_sample_pages=64
innodb_autoinc_lock_mode=2

##innodb_rollback_on_timeout=1
##innodb_lock_wait_timeout=10

##master-master
##mysql数据库id
server_id=101
#因为MYSQL是基于二进制的日志来做同步的,每个日志文件大小为 1G
log-bin=mysql-bin
log-slave-updates=1
sync_binlog=1

#主库自增长偏移量,主库1,备库2
auto_increment_offset=2
auto_increment_increment=2

#进行镜像处理的数据库
#replicate-do-db=atsdb
#replicate-do-db=ts_mid
relay_log=/data/DB/atsdb/relay-bin
log-bin-trust-function-creators=1

###双主同步设置##结束###

[mysql]
prompt="(\\u@\\h)[\\d]> "
# 设置mysql客户端默认字符集
default-character-set=utf8
socket=$k/DB/atsdb/mysql.sock

[client]
# # 设置mysql客户端连接服务端时默认使用的端口
port=3306
# 设置mysql客户端默认字符集
default-character-set=utf8
socket=$k/DB/atsdb/mysql.sock
EOF
}


chushihua()
{
  msgbox "pam" "=======================时间较长请耐心等待========================";echo
 $k/DB/mysql/bin/mysqld --initialize --user=mysql --basedir=$k/DB/mysql --datadir=$k/DB/atsdb
   msgbox "pam" "========================初始化完成========================";echo
}

shouquan()
{
cp $k/DB/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig  --list mysqld
}

qidong()
{
service mysql start
}

zhuangtai()
{
msgbox "pam" "=======================启动成功是running，快去改密码========================";echo
service mysql status
}

chakan()
{
cat $k/DB/log/mysqld.log | grep password
msgbox "pam" "====初始密码在上方，请依次执行以下操作，更改密码和修改为远程操作";echo
msgbox "pam" "====1.登录mysql：mysql -uroot -p //回车后输入初始密码";echo
msgbox "pam" "====2.ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '密码';用户密码自己定义，用户此处为root";echo
msgbox "pam" "====3.use mysql; //要访问那个库都先use 库名";echo
msgbox "pam" "====4.update user set host='%' where user='root';  //修改root用户允许远程访问 ";echo
msgbox "pam" "====5.select user,host from mysql.user;  //查看是否更改为% ";echo
msgbox "pam" "====6.flush privileges;  //刷新权限 ";echo


}

xiezai()
{
service mysqld stop
#删除用户
userdel -r  mysql
#删除数据目录工具目录
rm -rf $k/DB
rm -rf $k/tool
}



#####展示函数====================================
function msgbox()
{
	case $1 in
		text ) color="\e[34;1m"
		;;
		alert ) color="\e[31;1m"
		;;
		result ) color="\e[33;1m"
		;;
		jump ) color="\e[35;1m"
		;;
		pam ) color="\e[32;1m"
		;;
		normal ) color="\e[37;1m"
	esac
	echo -e "${color}${2}\e[0m\c"
}


#控制函数========================================
main()
{
            menu1
            case $num1 in
            0)
            huanjing
            ;;
            1)
            mysqldirectoryinstallation
            ;;
            2)
            unzip
            ;;
            3) 
            permissions
            ;;
            4)
            mycnf
            ;;
            5)
            chushihua
            #echo '初始化中。。。'
            ;;
            6)
            shouquan
            ;;
            7)
            qidong
            ;;
            8)
            zhuangtai
            ;;
            9)
            chakan
            ;;
            10)
            huanjing
            mysqldirectoryinstallation
            unzip
            permissions
            mycnf
            chushihua
            shouquan
            qidong
            zhuangtai
            chakan
            ;;
            11)
            xiezai
            ;;
            12)  
            exit
            ;;
          *)
            msgbox "alert" "####别乱按，想搞事情？？？只能选【1-9】选项!!!!!";echo
            sleep 3
            main
            ;;
    esac
}
main $*