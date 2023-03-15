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









