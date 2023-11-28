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