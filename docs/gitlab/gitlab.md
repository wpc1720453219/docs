## gitlab安装
```shell
yum -y install policycoreutils openssh-server openssh-clients postfix
systemctl enable postfix && systemctl start postfix
```

wegt https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-14.9.4-ce.0.el7.x86_64.rpm

wget http://mirror.centos.org/centos/7/os/x86_64/Packages/policycoreutils-python-2.5-33.el7.x86_64.rpm

rpm -ivh gitlab-ce-14.9.4-ce.0.el7.x86_64.rpm  --force --nodeps
强制安装  
gitlab配置文件 /etc/gitlab/gitlab.rb 修改  
external_url 'http://192.168.10.100:8888'  
启动：
[gitlab中文设置](https://blog.csdn.net/qq1554778535/article/details/120503109)  
[GitLab备份与恢复/迁移方案](https://blog.csdn.net/qq_44930876/article/details/129581849)
BACKUP后的值不是备份文件的文件名，不写后面的“_gitlab_backup.tar”，否则会提示“The back file XXX_gitlab_backup.tar does not exist!”。如下图：
或者不要BACKUP=

[共享文件夹显示](https://blog.csdn.net/RSFeegg/article/details/128986518)

问题二：/mnt/hgfs 文件夹为空
问题背景和问题一 一样

问题现象：
设置了共享文件目录，并且启用，但在/mnt/hgfs目录下没有共享的文件。

解决方案：
终端输入 vmware-hgfsclient，查看之前在共享文件夹设置的共享目录
如果输出正确，则输入 sudo vmhgfs-fuse .host:/刚输出的文件名 /mnt/hgfs
此时 /mnt/hgfs目录下就会出现之前设置的共享文件！
