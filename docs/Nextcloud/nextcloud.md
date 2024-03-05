## nextcloud开源网盘  
1. [Nextcloud官网](https://nextcloud.com/)
2. [入坑教程：Pandownload作者被抓后，我决定用docker搭建一款私有网盘](https://mp.weixin.qq.com/s?__biz=MzIzMzgxOTQ5NA==&mid=2247492122&idx=1&sn=5e94dcbfec8a54c719537c3faa926145&chksm=e8fd7e13df8af70512a6c2981ff72db73a66f46064d1b2d3632f0dc5ec074d4019c2a51fa0ea&mpshare=1&scene=1&srcid=&sharer_sharetime=1587203681346&sharer_shareid=3273f8a3416873dc9c8237f5bff497de##)
3. [docker hub官方镜像](https://hub.docker.com/_/nextcloud)

### 部署
20+ 必须mysql8  
```shell
docker pull nextcloud:24.0.5
docker rm -f nextcloud
docker run -d   --privileged=true \
    --name nextcloud \
    --restart=always \
    -e TZ=Asia/Shanghai \
    -v /data4t/nextcloud/data:/var/www/html \
    -p 8001:80 \
    nextcloud:24.0.5
docker logs -f nextcloud
```

### nextcloud支持外部存储，比如ftp  
[FTP/FTPS — Nextcloud latest Administration Manual latest documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/external_storage/ftp.html)

### 扫描同步本地文件  
添加了外部存储之后，已有的文件需要扫描同步才能关联到nextcloud  
[Using the occ command — Nextcloud latest Administration Manual latest documentation](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html#file-operations)  
[Nextcloud 自动扫描文件 (ismy.fun)](https://it.ismy.fun/2018/11/12/nextcloud-auto-files-scan/)
```shell
# 注意：需要用和nextcloud相同的用户
docker exec -it -u 33 nextcloud bash
php occ files:scan --help
 
php occ files:scan  -- admin
 
 
命令行帮助：
www-data@7c70d52c126c:~/html$  php occ files:scan --help
Description:
  rescan filesystem
 
Usage:
  files:scan [options] [--] [<user_id>...]
 
Arguments:
  user_id                will rescan all files of the given user(s)
 
Options:
      --output[=OUTPUT]  Output format (plain, json or json_pretty, default is plain) [default: "plain"]
  -p, --path=PATH        limit rescan to this path, eg. --path="/alice/files/Music", the user_id is determined by the path and the user_id parameter and --all are ignored
      --all              will rescan all files of all known users
      --unscanned        only scan files which are marked as not fully scanned
      --shallow          do not scan folders recursively
      --home-only        only scan the home storage, ignoring any mounted external storage or share
  -h, --help             Display this help message
  -q, --quiet            Do not output any message
  -V, --version          Display this application version
      --ansi             Force ANSI output
      --no-ansi          Disable ANSI output
  -n, --no-interaction   Do not ask any interactive question
      --no-warnings      Skip global warnings, show command output only
  -v|vv|vvv, --verbose   Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
```

### 画图 draw.io  
[Draw.io - 应用 - 应用商店 - 下一云 (nextcloud.com)](https://apps.nextcloud.com/apps/drawio)  
### 版本升级  

挂网升级文档：[How to upgrade — Nextcloud latest Administration Manual latest documentation](https://docs.nextcloud.com/server/latest/admin_manual/maintenance/upgrade.html)  
[基于docker部署nextcloud及其升级和问题修复_qiwip的博客-CSDN博客_nextcloud 修复](https://blog.csdn.net/qi_w_ip/article/details/114624078)

官网说，一次只能升级一个大版本，也就是从19到21，要先升级到20，再从20到21



### nextcloud 对接

[[置顶\] LDAP集成Nextcloud 部署教程-橙叶博客 (orgleaf.com)](https://www.orgleaf.com/2839.html)

nextcloud自带ldap插件，不过默认是禁用状态，在应用管理里面启用即可。

nextcloud已经和云效的ldap对接，用jira用户密码登录过一次云效后，可以用jira用户密码登录nextcloud。 云效地址：<http://avatar.luna.xyyweb.cn/> nextcloud地址：<http://10.60.44.54:8001/>

![Snipaste_2022-09-03_15-45-03](.\img\Snipaste_2022-09-03_15-45-03.png)

## 其他网盘

供人使用的，有权限、可分享的随便一台机器就能搭的网盘；而不是minio这样主要是给程序提供api的那种；

1. [知乎：有哪些好用的开源网盘？](https://www.zhihu.com/question/40064203)
2. [Pandownload作者被抓后，我决定用docker搭建一款私有网盘](https://mp.weixin.qq.com/s?__biz=MzIzMzgxOTQ5NA==&mid=2247492122&idx=1&sn=5e94dcbfec8a54c719537c3faa926145&chksm=e8fd7e13df8af70512a6c2981ff72db73a66f46064d1b2d3632f0dc5ec074d4019c2a51fa0ea&mpshare=1&scene=1&srcid=&sharer_sharetime=1587203681346&sharer_shareid=3273f8a3416873dc9c8237f5bff497de##)
3. [2019开源企业网盘大盘点](https://bbs.huaweicloud.com/blogs/113364)
4. [开源网盘云存储 Seafile](https://www.seafile.com/home/)

可道云

[利用可道云搭建个人网盘/云桌面 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/62830311)

![img](https://pic3.zhimg.com/80/v2-bd483132555058a9a9c86504a139d786_1440w.jpg)

