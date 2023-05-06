## sysctmd

```shell
# 使配置生效
systemctl daemon-reload
# 添加开机自启，反向操作的话把enable改成disable
systemctl enable luna-sunht-dev-ats-basicdata
# 启动ats-basicdata  重启包含了启动
systemctl restart luna-sunht-dev-ats-basicdata
#显示某个 Unit 的所有底层参数
$ systemctl show httpd.service
# 查看启动状态
systemctl status luna-sunht-dev-ats-basicdata


#查看历史日志
journalctl -exu luna-sunht-dev-ats-basicdata
# -e  --pager-end   Immediately jump to the end in the pager  立即跳到寻呼机的末尾
#  -f  --follow  Follow the journal  关注期刊, 最新的
# -x  --catalog   Add message explanations where available  添加消息说明（如果有）
# -u  --unit=UNIT   Show logs from the specified unit   显示指定单位的日志
#跟踪日志
journalctl -exfu luna-sunht-dev-ats-basicdata
```



```shell
[Unit]
Description=${systemdFileName}
After=network.target

[Service]
Restart=always  ##always 总是重新启动
RestartSec=5    ##重新启动服务前的睡眠时间（以秒为单位）
StartLimitInterval=10  ##限制该服务的启动频率。默认值是每10秒内不得超过5次(StartLimitInterval=10s StartLimitBurst=5)。
StartLimitBurst=5
LimitNOFILE=655350
LimitNPROC=655350
Type=forking
User=avatar
Group=avatar
ExecStart=${this.installPath(appMeta.startPathInSoftware)}
ExecStop=${this.installPath(appMeta.stopPathInSoftware)}

[Install]
WantedBy=multi-user.target
```


[system.service | 参数解析](https://blog.csdn.net/stone_fall/article/details/108630115)  
[Systemd 技术原理](https://blog.csdn.net/UbuntuKylinOS/article/details/120997854)


## /etc/init.d
service 文件是使用 systemd 作为初始化程序的 Linux 系统才有的服务文件，叫“服务配置单元文件”，  
用来取代旧初始化系统中的脚本文件，但是他们可能会同时存在系统中。  

如果同时存在的话，在目录 /etc/init.d/ 下的脚本文件的优先级会高于目录 /etc/systemd/system/ 下的 service 文件。

service xxxx start|stop|restart 相当于是对 /etc/init.d/ 下的 xxxx 的封装，相当于是一个管理命令，实际执行的是 /etc/init.d/下的可执行程序   
如果 /etc/init.d/下没有该服务的可执行程序，则会查找对应的 service 文件  


mysqld 是针对mysql的一个shell脚本，里面有start | stop | restart 等方法
分配执行权限，并加入到开机启动中
chmod +x /etc/init.d/mysqld		//添加执行权限
chkconfig --add mysqld		    //添加到服务启动项
chkconfig  --list mysqld		//查看服务启动列表

[Linux chkconfig 命令](https://www.runoob.com/linux/linux-comm-chkconfig.html)











