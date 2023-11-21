## linux 核心命令
快速在一个文件夹起一个http服务器：  
npm i -g -d serve ; serve -p 5000  
python2 -m SimpleHTTPServer 5000  
python3 -m http.server 5000

cp 命令
[Linux 使用 cp 命令强制覆盖功能](https://blog.csdn.net/xinluke/article/details/52229431)
-p : 保留复制前文件的用户属性    -r : 递归复制
```shell
[root@cxm test]# cp -p 1.txt 3.txt
[root@cxm test]# ll
总用量 0
-rw-r--r--. 1 cxm  cxm  0 3月   6 19:55 1.txt    （源文件）
-rw-r--r--. 1 root root 0 3月   6 19:59 2.txt    （没保留属性）
-rw-r--r--. 1 cxm  cxm  0 3月   6 19:55 3.txt    （保留属性）
```
[Linux 使用 cp 命令强制覆盖功能](https://blog.csdn.net/xinluke/article/details/52229431)

### pid 1  
[Linux中的特殊进程：idle进程(0号进程)、init进程(1号进程，被systemd 取代 )、kthreadd进程(2号进程)](https://blog.csdn.net/m0_45406092/article/details/130657532)  


tee  —— 兼顾打印输出屏幕内容并且内容还会重定向到文件内。（通常和管道符连用）  
| tee           相当于  cat  和  >      重定向  
| tee  -a     相当于  cat  和  >>   追加重定向  
[shell-12- tee 重定向 tr字符替换 split文件分割](https://blog.csdn.net/lwj457700209/article/details/99646223)
[管道、xargs、-exec的介绍与区别](https://huaweicloud.csdn.net/635643aed3efff3090b5cc76.html)
[linux xargs,-exec,|管道的区别](https://www.jianshu.com/p/788fb4d66410)
[Linux下多个命令串联执行(管道/xargs/exec)](https://blog.csdn.net/langeldep/article/details/127746040)


```shell
free -h
df -h
du -sh /*
ps -ef 和ps -aux的区别：查询用ef，详细信息以及更多进程用aux
| tee > xxx.txt     将标准输出结果输出到文件
2>&1 | tee > xxx.txt  将标准错误转化成标准输出 再输出到文件
jps -v 查看启动参数
rsync  远程和本地文件备份      
```

### netstat 命令输出
[netstat命令输出详解](https://www.jianshu.com/p/443e6267dc47)

### rsync 与 cp、scp 区别
cp是一种典型的将文件完整的拷贝或者复制到其他位置，不管里面改了多少东西  
rsync是第一次在目标地址没有（复制到这后的同步源没有）的时候，全量备份。
但是第二次的时候只会对其中的增加项（差异项）来进行同步，所以这样的话对于一个更改过的文件进行二次备份的话rsync会比cp快，只备份同步更新部分。  
cp支持本地 rsync支持远程  
(rsync与cp的区别)[https://blog.csdn.net/wanghaoyang0324/article/details/122212814]

rsync的使用（可做异地冷备）
为/home/avatar目录建立软连接
```shell
#在/data下面创建一个目录
mkdir -p /data/avatar-true
#分配权限
chown -R avatar:avatar /data/avatar-true
#使用rsync进行备份，这边的avatar可以不写，会自动建一个avatar的目录
rsync -av /home/avatar /data/avatar-true/avatar
#把home目录删除，删除前记得先关闭所有这个目录下启动的服务，不然会不断写日志删不掉
rm -rf /home/avatar
#建立软连接
ln -s /data/avatar-true/avatar/avatar /home/avatar
```
## 查看文件具体信息  
stat xxx  
[stat命令详解](https://www.lxlinux.net/1960.html)
```shell
[root@TENCENT64 ~]# stat Changelog
  File: ‘Changelog'
  Size: 1598     Blocks: 8     IO Block: 4096  regular file
 Device: fd01h/64769d    Inode: 1579435   Links: 1
 Access: (0644/-rw-r--r--) Uid: (  0/  root)  Gid: (  0/  root)
 Access: 2018-11-06 22:39:54.110931887 +0800
 Modify: 2018-11-06 22:39:54.110931887 +0800
 Change: 2018-11-06 23:07:14.428548887 +0800
```
File: ‘Changelog’:文件名称为Changelog  
Size: 1598:文件大小1598字节  
Blocks: 8：文件占用的块数  
Block size: 4096：块大小为4096字节  
regular file：文件类型（普通文件） 
Device: fd01h/64769d：文件所在设备号，分别以十六进制和十进制显示  
Inode: 1579435：文件节点号  
Links: 1：硬链接数  
Access: (0644/-rw-r–r–)：访问权限  
Uid：所有者ID与名称   
Gid：所有者用户组ID与名称
access time：表示我们最后一次访问（仅仅是访问，没有改动）文件的时间
modify time：表示我们最后一次修改文件的时间
change time：表示我们最后一次对文件属性改变的时间，包括权限，大小，属性等等
Birth time : 文件创建时间，crtime，不过据查此属性linux已废弃，目前状态显示结果均为-
[linux系统下如何获取文件的创建时间](https://blog.csdn.net/qq_37989070/article/details/134413866)