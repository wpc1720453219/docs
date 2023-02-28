#!/bin/sh
. /etc/rc.d/init.d/functions
export LANG=zh_CN.UTF-8
#ftp挂载目录
kk="/home"
k=$kk
#ftp用户名
zz="ftp"
z=$zz
#一级菜单
menu1()
{
curPath=$(dirname $(readlink -f "$0"))


        clear
msgbox "pam" "  ┌----------------------------------------┐";echo
msgbox "pam" "  |****   欢迎使用FTP安装工具   ****|";echo
msgbox "pam" "  |****   技术支持组YYDS ****|";echo
msgbox "pam" "  |****   1.按一下1                                         ****|";echo
msgbox "pam" "  |****   2.按一下2 ****|";echo
msgbox "pam" "  |****   当前目录【 $curPath 】           ****|";echo
msgbox "pam" "  └----------------------------------------┘";echo
        cat <<EOF
1.创建用户
2.FTP一键安装
3.启动
4.关闭
5.重启
6.查看状态
EOF
        read -p "选项1-6，自己看着选[1-6]:" num1
}


a()
{
useradd $z
passwd $z
mkdir $k
mkdir $k/ftp
chown $z $k/ftp
chmod 777 -R $k/ftp
}

b()
{
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

#启动
c()
{
systemctl start vsftpd
}
#关闭
d()
{
systemctl stop vsftpd
}
#重启
e()
{
systemctl restart vsftpd
}

f()
{
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
            1)
            a
            ;;
            2)
            b
            ;;
            3) 
            c
            ;;
            4)
            d
            ;;
            5)
            e
            ;;
            6)
            f
            ;;
          *)
            msgbox "alert" "####别乱按，想搞事情？？？只能选【1-6】选项!!!!!";echo
            sleep 3
            main
            ;;
    esac
}
main $*