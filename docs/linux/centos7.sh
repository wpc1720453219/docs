#!/bin/sh
. /etc/rc.d/init.d/functions
export LANG=zh_CN.UTF-8

#更改挂载目录
kyh="/home"
k=$kyh

#一级菜单
menu1()
{
curPath=$(dirname $(readlink -f "$0"))


        clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |****   ********【Centos7】********* ****|";echo
msgbox "pam" "  |****    ****【企金技术支持组】****  ****|";echo
msgbox "pam" "  |****     ****---------------****    ****|";echo
msgbox "pam" "  |****        【 $curPath 】             ****|";echo
msgbox "pam" "  └----------------------------------------┘";echo
        cat <<EOF
0. h-目录结构-------------
1. h-一键优化-------------
2. h-自定义优化-----------
3. h-中间件安装部署-------
4. h-中间件启动-----------
5. h-中间件关闭-----------
6. h-微服务安装部署-------
7. h-微服务启动----------
8. h-微服务关闭----------
9. h-健康检查------------
10.h-端口释放------------
11.h-其他服务------------
12.h-打扫战场------------
EOF
        read -p "选项1-11，自己看着选[1-11]:" num1
}

#二级菜单
menu2()
{
    clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |**** 选项1-13，自己看着选:[0-13]   ****||";echo
msgbox "pam" "  └----------------------------------------┘";echo
    cat <<EOF
1. 优化-修改字符集
2. 优化-关闭selinux
3. 优化-防火墙操作
4. 优化-精简开机启动
5. 优化-修改文件描述符
6. 优化-安装常用工具及修改yum源
7. 优化-优化系统内核
8. 优化-加快ssh登录速度
9. 优化-禁用ctrl+alt+del重启
10.优化-设置时间同步
11.优化-history优化
12.返回上级菜单
13.退出
EOF
    read -p "选择[1-13]:" num2

}

#二级菜单
menu3()
{
    clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |**** 选项0-6，自己看着选:[0-6]   ****||";echo
msgbox "pam" "  └----------------------------------------┘";echo
    cat <<EOF
0. 安装部署-jdk
1. 安装部署-mysql
2. 安装部署-redis
3. 安装部署-zookeeper
4. 安装部署-rabbitmq
5. 安装部署-seata
6. 安装部署-nacos
7. 安装部署-ngnix
8. 安装部署-Tomcat
EOF
    read -p "选择[0-8]:" num3
}


menu4()
{
    clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |**** 选项0-6，自己看着选:[0-6]   ****||";echo
msgbox "pam" "  └----------------------------------------┘";echo
    cat <<EOF
0. 启动-mysql
1. 启动-redis
2. 启动-zookeeper
3. 启动-rabbitmq
4. 启动-seat
5. 启动-nacos
6. 启动-nginx
EOF
    read -p "选择[0-6]:" num4
}



#二级菜单
menu5()
{
    clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |**** 选项1-9，自己看着选:[0-9]   ****||";echo
msgbox "pam" "  └----------------------------------------┘";echo
    cat <<EOF
0. 关闭-mysql
1. 关闭-redis
2. 关闭-zookeeper
3. 关闭-rabbitmq
4. 关闭-seata
5. 关闭-nacos
6. 关闭-nginx
EOF
    read -p "选择[0-6]:" num5
}

#二级菜单
menu6()
{
    clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |**** 选项1-3，自己看着选:[0-3]   ****||";echo
msgbox "pam" "  └----------------------------------------┘";echo
    cat <<EOF
1. Redis关闭
2. zookeeper关闭
3. uniquecode关闭
EOF
    read -p "选择[1-3]:" num6
}

#二级菜单
menu8()
{
    clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |**** 选项1-5，自己看着选:[0-5]   ****||";echo
msgbox "pam" "  └----------------------------------------┘";echo
    cat <<EOF
1. Tomcat-center安装
2. Tomcat-front安装
3. Tomcat-report安装
4. Tomcat-task安装
5. Tomcat-webservice安装
EOF
    read -p "选择[1-5]:" num8
}

#二级菜单
menu11()
{
    clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |**** 选项1-5，自己看着选:[0-5]   ****||";echo
msgbox "pam" "  └----------------------------------------┘";echo
    cat <<EOF
1. ftp服务安装(被动模式)
2. python环境搭建(干掉默认的了)
EOF
    read -p "选择[1-1]:" num11
}



pythoninstall()
{
# 更新yum
yum -y update
# 一些必要的安装
yum -y install epel-release openssl-devel bzip2-devel libffi-devel xz-devel wget net-tools
# 创建python安装目录和临时文件夹
mkdir /usr/local/python3.9.10 /tempfolder
# 进入临时文件夹
cd /tempfolder
# 下载指定版本的Python包
wget http://npm.taobao.org/mirrors/python/3.9.10/Python-3.9.10.tgz
# 解压下载的Python包
tar xvf Python-3.9.10.tgz

# 进入解压后的Python文件夹
cd Python-3.9.10
# 配置编辑安装Python
./configure --with-ssl --prefix=/usr/local/python3.9.10 && make && make install
# 创建python和pip的软连接到/usr/bin/目录下
ln -s /usr/local/python3.9.10/bin/python3.9 /usr/bin/python3
ln -s /usr/local/python3.9.10/bin/pip3.9 /usr/bin/pip3
# 验证版本号是否正确
python3 -V
pip3 -V


 
配置pip下载镜像源：

# 创建文件夹
mkdir /root/.pip
# 创建编辑配置文件
cd /root/.pip/pip.conf

# 在pip.conf中写入以下3行内容：
aommand1='[global]'
sed -i "1 a $aommand1" pip.conf
aommand2='trusted-host = mirrors.aliyun.com'
sed -i "2 a $aommand2" pip.conf
aommand3='index-url = https://mirrors.aliyun.com/pypi/simple'
sed -i "3 a $aommand3" pip.conf

# 其他可选镜像源
#中国科技大学：https://pypi.mirrors.ustc.edu.cn/simple/
#清华大学：https://pypi.tuna.tsinghua.edu.cn/simple/
#中国科学技术大学：http://pypi.mirrors.ustc.edu.cn/simple/
#豆瓣：http://pypi.douban.com/simple/

# 更新pip
pip3 install --upgrade pip
# 删除临时文件夹
rm -rf tempfolder



# 删除默认的
rm -rf /usr/bin/python
# 设置新的软连接
ln -s /usr/bin/python3 /usr/bin/python
}

Tomcatkk()
{
msgbox "pam" "========================Tomcat安装========================";echo
msgbox "pam" "========================判断是否已经安装Tomcat========================";echo
testPath="$k/FinanceBox/Tomcat/Tomcat-kk"
if [[ -e "$testPath" ]];
then
       msgbox "alert" "Tomcat-kk已经安装了！！！";echo
else
       msgbox "pam" "========================未检测到Tomcat安装，继续安装========================";echo
       msgbox "pam" "========================解压Tomcat中========================";echo
#日志目录
log="$k/kk.log"
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
               echo "操作文件名：apache-tomcat-7.0.105.tar ">>$log;
# 将文件解压到指定目录
               tar zxvf $k/source/apache-tomcat-7.0.105.tar -C $k/;
           done
       echo "$curtime ,执行成功,操作数目: $count">>$log
else
    echo "$curtime nuodongiot is empty.">>$log
fi
      rm -rf $k/home/apache-tomcat-7.0.105/webapps/*
      for i in {1..1}
          do 
            cp -r $k/home/apache-tomcat-7.0.105 $k/FinanceBox/k-$i
          done 
      rename k-1 Tomcat-kk $k/FinanceBox/*
fi
}


killmysql()
{
service mysql stop
}

killredis()
{
sp_pid=`ps -ef | grep redis | grep -v grep | awk '{print $2}'`
if [ -z "$sp_pid" ];
then
 echo "[ not find Tomcat-center pid ]"
msgbox "pam" "========================你这根本就没起啊大哥========================";echo
else
 echo "find result: $sp_pid "
 kill -9 $sp_pid
msgbox "pam" "========================没问题，是干掉了的========================";echo
fi
}

killzookeeper()
{
sp_pid=`ps -ef | grep zookeeper | grep -v grep | awk '{print $2}'`
if [ -z "$sp_pid" ];
then
 echo "[ not find Tomcat-center pid ]"
msgbox "pam" "========================你这根本就没起啊大哥========================";echo
else
 echo "find result: $sp_pid "
 kill -9 $sp_pid
msgbox "pam" "========================没问题，是干掉了的========================";echo
fi
}

killrabbitmq()
{
sp_pid=`ps -ef | grep rabbitmq | grep -v grep | awk '{print $2}'`
if [ -z "$sp_pid" ];
then
 echo "[ not find Tomcat-center pid ]"
msgbox "pam" "========================你这根本就没起啊大哥========================";echo
else
 echo "find result: $sp_pid "
 kill -9 $sp_pid
msgbox "pam" "========================没问题，是干掉了的========================";echo
fi
}

killseata()
{
sp_pid=`ps -ef | grep seata | grep -v grep | awk '{print $2}'`
if [ -z "$sp_pid" ];
then
 echo "[ not find Tomcat-center pid ]"
msgbox "pam" "========================你这根本就没起啊大哥========================";echo
else
 echo "find result: $sp_pid "
 kill -9 $sp_pid
msgbox "pam" "========================没问题，是干掉了的========================";echo
fi
}

killnacos()
{
sp_pid=`ps -ef | grep nacos | grep -v grep | awk '{print $2}'`
if [ -z "$sp_pid" ];
then
 echo "[ not find Tomcat-center pid ]"
msgbox "pam" "========================你这根本就没起啊大哥========================";echo
else
 echo "find result: $sp_pid "
 kill -9 $sp_pid
msgbox "pam" "========================没问题，是干掉了的========================";echo
fi
}

killnginx()
{
sp_pid=`ps -ef | grep nginx | grep -v grep | awk '{print $2}'`
if [ -z "$sp_pid" ];
then
 echo "[ not find Tomcat-center pid ]"
msgbox "pam" "========================你这根本就没起啊大哥========================";echo
else
 echo "find result: $sp_pid "
 kill -9 $sp_pid
msgbox "pam" "========================没问题，是干掉了的========================";echo
fi
}


duankoufangxin()
{
read -p "请输入要放行的端口:" ip_s
echo "正在放行..."
firewall-cmd --zone=public --add-port=$ip_s/tcp --permanent
firewall-cmd --reload
echo "提示:端口: $ip_s 已放行"
msgbox "pam" "========================提示:端口: $ip_s 已放行========================";echo
firewall-cmd --zone=public --list-port
}

duankoujiance()
{
#输入你要检测的端口
port_array=(8200 8300 3306 5672 15672 25672 8089 8848)
service_array=(zookeeper redis mysql rabbitmq rabbitmq rabbitmq nginx nacos )
for(( i=0;i<${#port_array[@]};i++)) do
    time=$(date "+%Y-%m-%d %H:%M:%S")
    port=${port_array[i]};
    service_name=${service_array[i]};
    port_status=`netstat -nlt|grep ${port_array[i]}|wc -l`
    service_process_num=`pgrep -l $service_name | wc -l`
 
    if [ $port_status -lt 1 ]
    then
        echo -e "\033[32m[未占用] $time $service_process_num $service_name:$port\033[0m"
    else
        echo -e "\033[31m[已占用] $time $service_process_num $service_name:$port\033[0m"
    fi
done;#输入你要检测的端口
port_array=(8100 8200 8300 8000 8001 8002 8003 8005 8080 8081 8082 8083 8085)
service_array=(nginx nginx nginx nginx nginx nginx nginx nginx nginx nginx nginx nginx nginx)
}


nginx()
{
msgbox "pam" "========================nginx安装nginx-1.20.1.tar.gz========================";echo
msgbox "pam" "========================判断是否已经安装nginx========================";echo
testPath1="$k/FinanceBox/nginx"
if [[ -e "$testPath1" ]];
then
       msgbox "alert" "nginx已经安装了！！！";echo
else
       msgbox "pam" "========================未检测到nginx安装，继续安装========================";echo
       msgbox "pam" "========================解压nginx中========================";echo
#日志目录
log="$k/nginx.log"
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
               echo "操作文件名：nginx-1.20.1.tar.gz">>$log;
# 将文件解压到指定目录
               tar zxvf $k/source/nginx-1.20.1.tar.gz -C $k/FinanceBox;
           done
       echo "$curtime ,执行成功,操作数目: $count">>$log
else
    echo "$curtime nuodongiot is empty.">>$log
fi
fi
chown -R root $k/FinanceBox/nginx-1.20.1
chown -R root $k/FinanceBox/nginx-1.20.1/*
}



nginxqidong()
{
cd $k/FinanceBox/nginx-1.20.1/bin/sbin
chmod 777 ./nginx
./nginx -c /home/FinanceBox/nginx-1.20.1/bin/conf/nginx.conf
}



dasao()
{
cd $k
mkdir $k/ats-tools
mkdir $k/ats-tools/logs
mv $k/*.zip $k/ats-tools/
mv $k/*.tar $k/ats-tools/
mv $k/*.gz $k/ats-tools/
mv $k/*.xz $k/ats-tools/
mv $k/*.docx $k/ats-tools/
mv $k/*.out $k/ats-tools/
mv $k/*.log $k/ats-tools/logs/
}

rabbitmq()
{
mkdir $k/FinanceBox/rabbitmq
mv $k/source/erlang-23.3-2.el7.x86_64.rpm $k/FinanceBox/rabbitmq
mv $k/source/rabbitmq-server-3.8.23-1.el7.noarch.rpm $k/FinanceBox/rabbitmq
cd $k/FinanceBox/rabbitmq/
rpm -Uvh erlang-23.3-2.el7.x86_64.rpm
yum install -y socat
rpm -Uvh rabbitmq-server-3.8.23-1.el7.noarch.rpm
systemctl start rabbitmq-server
rabbitmq-plugins enable rabbitmq_management
rabbitmqctl add_user admin fg
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
}

rabbitmqqidong()
{
systemctl start rabbitmq-server
}

rabbitmqguanbi()
{
systemctl stop rabbitmq-server
}

#1.修改字符集
localeset()
{
    echo "========================修改字符集========================="
    cat > /etc/locale.conf <<EOF
LANG="zh_CN.UTF-8"
#LANG="en_US.UTF-8"
SYSFONT="latarcyrheb-sun16"
EOF
    source /etc/locale.conf
    echo "#cat /etc/locale.conf"
    cat /etc/locale.conf
    action "完成修改字符集" /bin/true
    echo "==========================================================="
    sleep 2
}

#2.关闭selinux
selinuxset() 
{
    selinux_status=`grep "SELINUX=disabled" /etc/sysconfig/selinux | wc -l`
    echo "========================禁用SELINUX========================"
    if [ $selinux_status -eq 0 ];then
        sed  -i "s#SELINUX=enforcing#SELINUX=disabled#g" /etc/sysconfig/selinux
        setenforce 0
        echo '#grep SELINUX=disabled /etc/sysconfig/selinux'
        grep SELINUX=disabled /etc/sysconfig/selinux
        echo '#getenforce'
        getenforce
    else
        echo 'SELINUX已处于关闭状态'
        echo '#grep SELINUX=disabled /etc/sysconfig/selinux'
                grep SELINUX=disabled /etc/sysconfig/selinux
                echo '#getenforce'
                getenforce
    fi
        action "完成禁用SELINUX" /bin/true
    echo "==========================================================="
    sleep 2
}

#3.关闭firewalld
firewalldset()
{
    echo "=======================防火墙操作========================"
    echo "===调用========"
exec ./iptable.sh

    echo "====谁让你禁用防火墙的，实施规范里面咋规定的！！！========================"
    echo "====怕你们误点了，我先把这个关掉了！！！！=============================="
    echo "==========================================================="
    sleep 5
}

#4.精简开机启动
chkset()
{
    echo "=======================精简开机启动========================"
    systemctl disable auditd.service
    systemctl disable postfix.service
    systemctl disable dbus-org.freedesktop.NetworkManager.service
    echo '#systemctl list-unit-files | grep -E "auditd|postfix|dbus-org\.freedesktop\.NetworkManager"'
    systemctl list-unit-files | grep -E "auditd|postfix|dbus-org\.freedesktop\.NetworkManager"
    action "完成精简开机启动" /bin/true
    echo "==========================================================="
    sleep 2
}

#5.修改文件描述符
limitset()
{
    echo "======================修改文件描述符======================="
    echo '* - nofile 65535'>/etc/security/limits.conf
    ulimit -SHn 65535
    echo "#cat /etc/security/limits.conf"
    cat /etc/security/limits.conf
    echo "#ulimit -Sn ; ulimit -Hn"
    ulimit -Sn ; ulimit -Hn
    action "完成修改文件描述符" /bin/true
    echo "==========================================================="
    sleep 2
}

#6.安装常用工具及修改yum源
yumset()
{
    echo "=================安装常用工具及修改yum源==================="
    yum install wget -y &> /dev/null
    if [ $? -eq 0 ];then
        cd /etc/yum.repos.d/
        \cp CentOS-Base.repo CentOS-Base.repo.$(date +%F)
        ping -c 1 mirrors.aliyun.com &> /dev/null
        if [ $? -eq 0 ];then
            wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &> /dev/null
            yum clean all &> /dev/null
            yum makecache &> /dev/null
        else
            echo "无法连接网络"
                exit $?
        fi
    else
        echo "wget安装失败"
        exit $?
    fi
    yum -y install lsof lrzsz vim lrzsz tree nmap nc sysstat &> /dev/null
    action "完成安装常用工具及修改yum源" /bin/true
    echo "==========================================================="
    sleep 2
}

#7. 优化系统内核
kernelset()
{
    echo "======================优化系统内核========================="
    chk_nf=`cat /etc/sysctl.conf | grep conntrack |wc -l`
    if [ $chk_nf -eq 0 ];then
        cat >>/etc/sysctl.conf<<EOF
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syncookies = 1

net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 4000 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 18000

net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 0
net.ipv4.tcp_max_orphans = 16000
net.ipv4.tcp_timestamps = 0

net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144

net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
EOF
    sysctl -p
    else
        echo "优化项已存在。"
    fi
    action "内核调优完成" /bin/true
    echo "==========================================================="
    sleep 2
}

#8.加快ssh登录速度
sshset()
{
    echo "======================加快ssh登录速度======================"
    sed -i 's#^GSSAPIAuthentication yes$#GSSAPIAuthentication no#g' /etc/ssh/sshd_config
    sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
    systemctl restart sshd.service
    echo "#grep GSSAPIAuthentication /etc/ssh/sshd_config"
    grep GSSAPIAuthentication /etc/ssh/sshd_config
    echo "#grep UseDNS /etc/ssh/sshd_config"
    grep UseDNS /etc/ssh/sshd_config
    action "完成加快ssh登录速度" /bin/true
    echo "==========================================================="
    sleep 2
}

#9. 禁用ctrl+alt+del重启
restartset()
{
    echo "===================禁用ctrl+alt+del重启===================="
    rm -rf /usr/lib/systemd/system/ctrl-alt-del.target
    action "完成禁用ctrl+alt+del重启" /bin/true
    echo "==========================================================="
    sleep 2
}

#10. 设置时间同步
ntpdateset()
{
    echo "=======================设置时间同步========================"
    yum -y install ntpdate &> /dev/null
    if [ $? -eq 0 ];then
        /usr/sbin/ntpdate time.windows.com
        echo "*/5 * * * * /usr/sbin/ntpdate ntp1.aliyun.com &>/dev/null" >> /var/spool/cron/root
    else
        echo "ntpdate安装失败"
        exit $?
    fi
    action "完成设置时间同步" /bin/true
    echo "==========================================================="
    sleep 2
}

#11. history优化
historyset()
{
    echo "========================history优化========================"
    chk_his=`cat /etc/profile | grep HISTTIMEFORMAT |wc -l`
    if [ $chk_his -eq 0 ];then
        cat >> /etc/profile <<'EOF'
#设置history格式
export HISTTIMEFORMAT="[%Y-%m-%d %H:%M:%S] [`whoami`] [`who am i|awk '{print $NF}'|sed -r 's#[()]##g'`]: "
#记录shell执行的每一条命令
export PROMPT_COMMAND='\
if [ -z "$OLD_PWD" ];then
    export OLD_PWD=$PWD;
fi;
if [ ! -z "$LAST_CMD" ] && [ "$(history 1)" != "$LAST_CMD" ]; then
    logger -t `whoami`_shell_dir "[$OLD_PWD]$(history 1)";
fi;
export LAST_CMD="$(history 1)";
export OLD_PWD=$PWD;'
EOF
        source /etc/profile
    else
        echo "优化项已存在。"
    fi
    action "完成history优化" /bin/true
    echo "==========================================================="
    sleep 2
}
#12. 解压缩
installation()
{
msgbox "pam" "========================Tomcat安装========================";echo
msgbox "pam" "========================判断是否已经安装Tomcat========================";echo
testPath="$k/FinanceBox/Tomcat/Tomcat-center"
if [[ -e "$testPath" ]];
then
       msgbox "alert" "Tomcat已经安装了！！！";echo
else
       msgbox "pam" "========================未检测到Tomcat安装，继续安装========================";echo
       msgbox "pam" "========================解压Tomcat中========================";echo
#日志目录
log="$k/kk.log"
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
               echo "操作文件名：apache-tomcat-7.0.105.tar ">>$log;
# 将文件解压到指定目录
               tar zxvf $k/apache-tomcat-7.0.105.tar -C $k/;
           done
       echo "$curtime ,执行成功,操作数目: $count">>$log
else
    echo "$curtime nuodongiot is empty.">>$log
fi
      rm -rf $k/home/apache-tomcat-7.0.105/webapps/*
      cd $k/home/apache-tomcat-7.0.105/conf 
      sed -i '164 a db2jcc-7.0.jar,\\' catalina.properties
      echo 'tomcat.util.http.parser.HttpParser.requestTargetAllow=|'>>$k/home/apache-tomcat-7.0.105/conf/catalina.properties
      str1='redirectPort="8443"'
      str2='redirectPort="8443" maxPostSize="-1"'
      command=s@$str1@$str2@
      sed -i "{$command}" server.xml
      for i in {1..5}
          do 
            cp -r $k/home/apache-tomcat-7.0.105 $k/FinanceBox/Tomcat/k-$i
          done 
      rename k-1 Tomcat-center $k/FinanceBox/Tomcat/*
      rename k-2 Tomcat-front $k/FinanceBox/Tomcat/*
      rename k-3 Tomcat-task $k/FinanceBox/Tomcat/*
      rename k-4 Tomcat-webservice $k/FinanceBox/Tomcat/*
      rename k-5 Tomcat-report $k/FinanceBox/Tomcat/*
fi
}


#13.Soft mysql zip版本安装
softzip()
{
msgbox "pam" "========================Soft安装========================";echo
msgbox "pam" "========================判断是否已经安装Soft========================";echo
testPath1="$k/FinanceBox/Soft/config-center-server"
if [[ -e "$testPath1" ]];
then
       msgbox "alert" "Soft已经安装了！！！";echo
else
       msgbox "pam" "========================未检测到Soft安装，继续安装========================";echo
       msgbox "pam" "========================解压Soft中========================";echo
#日志目录
log="$k/Soft.log"
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
               echo "操作文件名：V_2.*.zip ">>$log;
# 将文件解压到指定目录
done
       echo "$curtime ,执行成功,操作数目: $count">>$log
else
    echo "$curtime nuodongiot is empty.">>$log
fi
               unzip -o V_2.*.zip
               mv ats_report_server_fr.zip $k/FinanceBox/Soft
               mv ats-web-front.zip $k/FinanceBox/Soft
               mv ats-web-task.zip $k/FinanceBox/Soft
               mv ats-web-webservice.zip $k/FinanceBox/Soft
               mv config-center-server.zip $k/FinanceBox/Soft
cd $k/FinanceBox/Soft
unzip ats_report_server_fr.zip
unzip ats-web-front.zip
unzip ats-web-task.zip
unzip ats-web-webservice.zip
unzip config-center-server.zip
sed -i "s/jats001/atsdb/g" $k/FinanceBox/Soft/config-center-server/WEB-INF/classes/common-config.properties
sed -i "s/root/jats001/g" $k/FinanceBox/Soft/config-center-server/WEB-INF/classes/common-config.properties
fi
}



#14.redis安装
redis()
{
msgbox "pam" "========================redis安装 redis-4.0.11========================";echo
msgbox "pam" "========================判断是否已经安装redis========================";echo
testPath1="$k/FinanceBox/redis-4.0.11"
if [[ -e "$testPath1" ]];
then
       msgbox "alert" "redis已经安装了！！！";echo
else
       msgbox "pam" "========================未检测到redis安装，继续安装========================";echo
       msgbox "pam" "========================解压redis中========================";echo
#日志目录
log="$k/redis.log"
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
               echo "操作文件名：Linux-redis-4.0.11.tar.gz">>$log;
# 将文件解压到指定目录
               tar zxvf $k/source/Linux-redis-4.0.11.tar.gz -C $k/home;
           done
       echo "$curtime ,执行成功,操作数目: $count">>$log
else
    echo "$curtime nuodongiot is empty.">>$log
fi
            cp -r $k/home/redis-4.0.11 $k/FinanceBox
             cd $k/FinanceBox/redis-4.0.11
              yum -y install gcc
              make MALLOC=libc
              mkdir -p $k/FinanceBox/redis-4.0.11/etc
              mkdir -p $k/FinanceBox/redis-4.0.11/bin
              cp $k/FinanceBox/redis-4.0.11/redis.conf $k/FinanceBox/redis-4.0.11/etc
              cd $k/FinanceBox/redis-4.0.11/src
cp mkreleasehdr.sh redis-benchmark redis-check-aof redis-check-rdb redis-cli redis-server redis-sentinel $k/FinanceBox/redis-4.0.11/bin
          sed -i "s/bind 127.0.0.1/bind 0.0.0.0/g" $k/FinanceBox/redis-4.0.11/etc/redis.conf
          sed -i "s/port 6379/port 8300/g" $k/FinanceBox/redis-4.0.11/etc/redis.conf

fi
}

#14.nacos安装
nacosinstall()
{
msgbox "pam" "========================nacos安装 nacos-server-1.4.2========================";echo
msgbox "pam" "========================判断是否已经安装redis========================";echo
testPath1="$k/FinanceBox/nacos"
if [[ -e "$testPath1" ]];
then
       msgbox "alert" "nacos已经安装了！！！";echo
else
       msgbox "pam" "========================未检测到nacos安装，继续安装========================";echo
       msgbox "pam" "========================解压nacos中========================";echo
#日志目录
log="$k/nacos.log"
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
               echo "操作文件名：nacos-server-1.4.2.tar.gz">>$log;
# 将文件解压到指定目录
               tar zxvf $k/source/nacos-server-1.4.2.tar.gz -C $k/FinanceBox;
           done
       echo "$curtime ,执行成功,操作数目: $count">>$log
else
    echo "$curtime nuodongiot is empty.">>$log
fi
fi
}



#16.redis后台运行启动
redishoutaiinitiata()
{
nohup $k/FinanceBox/redis-4.0.11/bin/redis-server /home/FinanceBox/redis-4.0.11/etc/redis.conf &
}

#17.zookeeper启动
zookeeperinitiata()
{
PID=$(cat /tmp/zookeeper/zookeeper_server.pid)
kill -9 $PID
cd $k/FinanceBox/zookeeper-*/bin
./zkServer.sh start &
}




#20.zookeeper安装
zookeeper()
{
msgbox "pam" "======================== zookeeper安装 zookeeper-3.4.10========================";echo
msgbox "pam" "========================判断是否已经安装 zookeeper========================";echo
testPath1="$k/FinanceBox/zookeeper-3.4.10"
if [[ -e "$testPath1" ]];
then
       msgbox "alert" "zookeeper已经安装了！！！";echo
else
       msgbox "pam" "========================未检测到 zookeeper安装，继续安装========================";echo
       msgbox "pam" "========================解压 zookeeper中========================";echo
#日志目录
log="$k/zookeeper.log"
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
               echo "操作文件名：zookeeper-3.4.10.tar.gz">>$log;
# 将文件解压到指定目录
               tar zxvf $k/source/zookeeper-3.4.10.tar.gz -C $k/home;
           done
       echo "$curtime ,执行成功,操作数目: $count">>$log
       echo 安装成功
else
    echo "$curtime nuodongiot is empty.">>$log
fi
     cp -r $k/home/zookeeper-3.4.10 $k/FinanceBox
     cd $k/FinanceBox/zookeeper-3.4.10/conf
     mv zoo_sample.cfg zoo.cfg
l=/tmp
sed -i 's#'''$l'''#'''$k'''#g' $k/FinanceBox/zookeeper-3.4.10/conf/zoo.cfg
sed -i "s/zookeeper/FinanceBox\/zookeeper-3.4.10\/tmp/g" $k/FinanceBox/zookeeper-3.4.10/conf/zoo.cfg
sed -i "s/clientPort=2181/clientPort=8200/g" $k/FinanceBox/zookeeper-3.4.10/conf/zoo.cfg
fi
}



#23.关闭redis
off_redis()
{
    ISCHECK=${1}
APP='redis'
BASE_DIR='$k/FinanceBox/redis-4.0.11'
PASS='123456'
count=`ps -ef | grep redis | grep -v grep | wc -l`
if [ ${count} != 0]; then
echo "${APP} 服务关闭中..."
if [ ${ISCHECK}]; then
sleep 2s
off_redis true
else
# 进入该应用根目录下
cd ${BASE_DIR}
    # 关闭服务
    ./bin/redis-cli -a ${PASS} shutdown
# 检查是否已关闭
off_redis true
fi
else
echo "${APP} 服务已关闭！"
fi
PID=$(cat /var/run/redis_6379.pid)
echo $PID
kill -9 $PID
echo "已杀掉"
}

zookeeperkill()
{
PID=$(cat /tmp/zookeeper/zookeeper_server.pid)
kill -9 $PID
echo "已杀掉"
}


##jdk安装
installjdk()
{
ipath="/usr/local"
installpath=$(cd `dirname $0`; pwd)
jdkpath=""
msgbox "pam" "========================jdk安装========================";echo
msgbox "pam" "========================判断是否已经部署jdk========================";echo
j=`whereis java`
java=$(echo ${j} | grep "jdk")
if [[ "$java" != "" ]]
then
    msgbox "alert" "jdk已经安装了！！！";echo
else
    msgbox "pam" "未检测jdk安装，继续进行安装";echo
    msgbox "pam" "解压jdk中";echo
tar -zxvf $k/source/jdk-*-linux-x64.tar.gz >/dev/null 2>&1
cd jdk* && jdkname=`pwd | awk -F '/' '{print $NF}'`
    msgbox "alert" "获取jdk版本: ${jdkname}";echo
    msgbox "alert" "。。******。。";echo
cd ${installpath}
    msgbox "alert" "获取当前目录:${installpath}";echo

if [ -d "${ipath}/${jdkname}" ];then
    msgbox "alert" "检测到${ipath}${jdkname}目录已存在！！！！";echo
    msgbox "alert" "停止并退出jdk安装";echo
jdkpath=${ipath}/${jdkname}

#测试
#jdkpath=${ipath}/${jdkname}
#echo ${jdkpath}

break
else
    msgbox "pam" "未检测到${ipath}${jdkname}目录";echo
    msgbox "pam" "开始进行转移${jdkname}文件到${ipath}安装目录";echo
mv ${jdkname} ${ipath}
    msgbox "pam" "jdk安装完毕！！！！";echo
    msgbox "pam" "jdk安装目录：【  ${ipath}/${jdkname}   】";echo
jdkpath=${ipath}/${jdkname}

#测试
#传递jdk安装路径参数
#jdkpath=${ipath}/${jdkname}
#echo ${jdkpath}

    action "完成jdk程序安装" /bin/true
fi




    msgbox "pam" "开始进行java环境变量安装检测！！！";echo
 
    chk_nf=`cat /etc/profile | grep JAVA_HOME |wc -l`
    if [ $chk_nf -eq 0 ];then
    msgbox "pam" "JAVA_HOME路径【${jdkpath}】注入中......";echo
    sleep 1
    echo "#设置JAVA_HOME变量" >> /etc/profile
    echo "export JAVA_HOME=${jdkpath}" >> /etc/profile
    echo 'export JRE_HOME=${JAVA_HOME}/jre'>> /etc/profile
    echo 'export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib' >> /etc/profile
    echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> /etc/profile

    msgbox "pam" "JAVA_HOME路径【${jdkpath}】注入完毕......";echo
    else
    msgbox "alert" "jdk环境变量已存在，停止设置！！";echo
fi

fi
     action "完成java环境变量配置" /bin/true
     action "完成JAVA安装" /bin/true
    
    msgbox "pam" "============手工运行【 source /etc/profile】生效环境变量=====================";echo

    sleep 2

}



#目录结构
mulujiegou()
{
mkdir $k/FinanceBox
mkdir $k/home
cd $k
unzip -o $k/source.zip
}





###mysql数据库------------------------------
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
source /etc/profile
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
               echo "操作文件名：mysql-*-linux-*-x86_64.tar.xz ">>$log;
# 将文件解压到指定目录
               tar xvf $k/source/mysql-*-linux-*-x86_64.tar.xz -C $k/tool;
       echo "$curtime ,执行成功,操作数目: $count">>$log
     msgbox "pam" "========================解压完成========================";echo
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
server_id=100
#因为MYSQL是基于二进制的日志来做同步的,每个日志文件大小为 1G
log-bin=mysql-bin
log-slave-updates=1
sync_binlog=1

#主库自增长偏移量,主库1,备库2
auto_increment_offset=1
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

mysqlguanbi()
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
msgbox "pam" "手动执行【source /etc/profile】";echo
cat $k/DB/log/mysqld.log | grep password
msgbox "pam" "====初始密码在上方，请依次执行以下操作，更改密码和修改为远程操作";echo
msgbox "pam" "====1.登录mysql：mysql -uroot -p //回车后输入初始密码";echo
msgbox "pam" "====2.ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '密码';用户密码自己定义，用户此处为root";echo
msgbox "pam" "====3.use mysql; //要访问那个库都先use 库名";echo
msgbox "pam" "====4.update user set host='%' where user='root';  //修改root用户允许远程访问 ";echo
msgbox "pam" "====5.select user,host from mysql.user;  //查看是否更改为% ";echo
msgbox "pam" "====6.flush privileges;  //刷新权限 ";echo
}



ftpinstall()
{
#ftp用户名
zz="ftp"
z=$zz
useradd $z
passwd $z
mkdir $k
mkdir $k/ftp
chown $z $k/ftp
chmod 777 -R $k/ftp
setenforce 0
yum install vsftpd -y
cd /etc/vsftpd
cp vsftpd.conf vsftpd.conf.bak
cd /etc/vsftpd
sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" /etc/vsftpd/vsftpd.conf
sed -i "s/#chroot_local_user=YES/chroot_local_user=YES/g" /etc/vsftpd/vsftpd.conf
echo "local_root=$k/ftp" >> /etc/vsftpd/vsftpd.conf
echo "pasv_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "pasv_min_port=30000" >> /etc/vsftpd/vsftpd.conf
echo "pasv_max_port=30100" >> /etc/vsftpd/vsftpd.conf
echo "reverse_lookup_enable=NO" >> /etc/vsftpd/vsftpd.conf
echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf
str1='auth       required	pam_shells.so'
str2="#auth       required	pam_shells.so"
command=s@$str1@$str2@
sed -i "$command" /etc/pam.d/vsftpd
str12='auth       required	pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed'
str22="#auth       required	pam_listfile.so item=user sense=deny file=/etc/vsftpd/ftpusers onerr=succeed"
command=s@$str12@$str22@
sed -i "$command" /etc/pam.d/vsftpd
firewall-cmd --zone=public --add-port=30000-30100/tcp --permanent
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --reload
systemctl start vsftpd
systemctl status vsftpd.service
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
          mulujiegou
          ;;
        1)
            #localeset
            selinuxset
            #firewalldset
            chkset
            limitset
            yumset
            kernelset
            sshset
            restartset
            ntpdateset
            historyset
            ;;
        2)
            menu2
            case $num2 in
                        1)
                            localeset
                            ;;
                        2)
                            selinuxset
                            ;;
                        3)
                            firewalldset
                            ;;
                        4)
                            chkset
                            ;;
                        5)
                            limitset
                            ;;
                        6)     
                        yumset
                            ;;
                        7)
                            kernelset
                            ;;
                        8)
                            sshset
                            ;;
                        9)
                            restartset
                            ;;
                        10)
                            ntpdateset
                            ;;
                11)
                     historyset
                     ;;
                12)
                     main
                     ;;
                13)
                     exit
                     ;;
                *)
                     echo '只能选 [1-13]，不玩了退了.'
                     ;;
            esac
            ;;
        3) menu3
           case $num3 in
                      0)
                       installjdk
                       ;;
                      1)
                       huanjing
            mysqldirectoryinstallation
            unzip
            permissions
            mycnf
            chushihua
            shouquan
            qidong
            zhuangtai
            chakan                       ;;

                      2)
                       redis
                       redishoutaiinitiata
                       ;;
                      3)
                       zookeeper
                       zookeeperinitiata
                       ;;
                      4)
                       rabbitmq
                       ;;
                      5)
                       nacosinstall
                       ;;
                      6)
                       nacosinstall
                       ;;
                      7)
                       nginx
                                              nginxqidong
                       ;;
                      8)
                       Tomcatkk
                                       ;;
                      9)
                        qiantao
                         ;;
                     *)
                     echo '只能选 [1-9]，不玩了退了.'
                     ;;

            esac
            ;;


        4)menu4
           case $num4 in
            0)
            qidong
            ;;
            1)
            redishoutaiinitiata
            ;;
            2)
            zookeeperinitiata
            ;;
            3)
            rabbitmqqidong
                       ;;
              *)
                     echo '只能选 [1-4]，不玩了退了.'
                     ;;

            esac
            ;;

            

        5) menu5
           case $num5 in
                       0)
                       killmysql
                                    ;;
                       1)  
                       killredis
                                    ;;
                       2)
                       killzookeeper
                                    ;;
                       3)
                       killrabbitmq
                                    ;;
                       4)
                       killseata
                                    ;;
                       5)
                       killnacos
                                    ;;
                       6)
                       killnginx
                                    ;;
                       *)
                     echo '只能选 [0-6]，不玩了退了.'
                                    ;;

            esac
            ;;
        6) menu6
           case $num6 in
                       1)
                       off_redis
                             ;;
                       2)
                       zookeeperkill
                             ;;
                       3)
                       proc_id
                             ;;
                       *)
                     echo '只能选 [1-3]，不玩了退了.'
                                    ;;

            esac
            ;;
        7)
            mulujiegou
            ;;
        8) menu8
           case $num8 in
                       1)
                       Tomcatcenter
                             ;;
                       2)
                       Tomcatfront
                             ;;
                       3)
                       Tomcatreport
                             ;;
                       4)
                       Tomcattask
                             ;;
                       5)
                       Tomcatwebservice
                             ;;
                       *)
                     echo '只能选 [1-5]，不玩了退了.'
                                    ;;

            esac
            ;;
         9)
           duankoujiance
            ;;
        10)  
           duankoufangxin
           ;;
        11)menu11
           case $num11 in
           1)
           ftpinstall
                      ;;
           2)
           pythoninstall
                      ;;
                      *)
                     echo '只能选 [1-2]，不玩了退了.'
                                    ;;
            esac
            ;;  
        12)
          dasao
                    ;;       
          *)
            msgbox "alert" "####别乱按，想搞事情？？？只能选【1-12】选项!!!!!";echo
            sleep 3
            main
            ;;
    esac
}
main $*

