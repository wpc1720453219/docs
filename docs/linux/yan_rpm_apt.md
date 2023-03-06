centos(redhat系) 与 ubuntu(debain系)  

redhat系:  
rpm 只能安装已经下载到本地机器上的rpm 包. yum能在线下载并安装rpm包,能更新系统,且还能自动处理包与包之间的依赖问题,这个是rpm 工具所不具备的。  
yum是在rpm的基础上建立的一个工具，在配置好yum源之后很多功能比rpm命令更强大，更方便。rpm可以查询包安装后生成的配置文件等，查询未安装软件包中的内容，查询软件包相关的脚本。一般情况下软件包的查询，安装，卸载，和软件属于的软件包等命令用yum的相关命令来完成更好  

rpm与yum的区别
rpm命令和yum命令都可以用来安装软件
但与yum命令最大的区别为yum命令在安装软件时如果碰到了依赖性的问题，yum会去主动尝试解决依赖性，如果解决不了才会反馈给用户。而rpm命令一旦遇到了依赖性的问题不会去解决依赖性，而是直接反馈给用户，让用户自行解决。

rpm适用于所有环境，而yum要搭建本地yum源才可以使用！yum是上层管理工具，自动解决依赖性，而rpm是底层管理工具。




x86：32位系统专用
x86-64 = x86/64：64位系统专用
amd64 = amd-64 = x64：64位系统专用

debain系:  
apt 与 dpkg 均为 ubuntu 下面的包管理工具。
dpkg 侧重于本地软件的管理。类似rpm
apt 基于dpkg，侧重于远程包的下载和依赖管理，类似 yum


yum源：/etc/yum.conf  
main 部分定义了全局配置选项，整个yum 配置文件应该只有一个main。常位于/etc/yum.conf中

```shell
[main]
cachedir=/var/cache/yum/$basearch/$releasever   // yum 缓存的目录，yum 在此存储下载的rpm 包和数据库，默认设置为/var/cache/yum
keepcache=0                                     // 安装完成后是否保留软件包，0为不保留（默认为0），1为保留
debuglevel=2                                    // Debug 信息输出等级，范围为0-10，默认是2 貌似只记录安装和删除记录
logfile=/var/log/yum.log                        // yum 日志文件位置。用户可以到/var/log/yum.log 文件去查询过去所做的更新。                
exactarch=1                                     // 有1和0两个选项，设置为1，则yum 只会安装和系统架构匹配的软件包，例如，yum 不会将i686的软件包安装在适合i386的系统中。默认为1。
obsoletes=1                                  　 // 这是一个update 的参数，具体请参阅yum(8)，简单的说就是相当于upgrade，允许更新陈旧的RPM包。
gpgcheck=1                                      // 有1和0两个选择，分别代表是否进行gpg(GNU Private Guard) 校验，以确定rpm 包的来源是有效和安全的。这个选项如果设置在[main]部分，则对每个repository 都有效。默认值为0。
plugins=1                                       //是否启用插件，默认1为允许，0表示不允许。我们一般会用yum-fastestmirror这个插件。
installonly_limit=5
bugtracker_url=http://bugs.centos.org/set_project.php?project_id=23&ref=http://bugs.centos.org/bug_report_page.php?category=yum
distroverpkg=centos-release   　  //指定一个软件包，yum 会根据这个包判断你的发行版本，默认是redhat-release，也可以是安装的任何针对自己发行版的rpm 包。

# exclude=selinux*　　// 排除某些软件在升级名单之外，可以用通配符，列表中各个项目要用空格隔开，这个对于安装了诸如美化包，中文补丁的朋友特别有用

retries=20
#retries，网络连接发生错误后的重试次数，如果设为0，则会无限重试。
tolerant=1
#tolerent，也有1和0两个选项，表示yum是否容忍命令行发生与软件包有关的错误，比如你要安装1,2,3三个包，而其中3此前已经安装了，如果你设为1,则yum不会出现错误信息。默认是0。

pkgpolicy=newest
#pkgpolicy： 包的策略。一共有两个选项，newest和last，这个作用是如果你设置了多个repository，而同一软件在不同的repository中同时存 在，yum应该安装哪一个，如果是newest，则yum会安装最新的那个版本。如果是last，则yum会将服务器id以字母表排序，并选择最后的那个 服务器上的软件安装。一般都是选newest。


reposdir=[包含 .repo 文件的目录的绝对路径]
#　　该选项用户指定 .repo 文件的绝对路径。.repo 文件包含软件仓库的信息 (作用与 /etc/yum.conf 文件中的 [repository] 片段相同)。

#  This is the default, if you make this bigger yum won't see if the metadata
# is newer on the remote and so you'll "gain" the bandwidth of not having to
# download the new metadata and "pay" for it by yum not having correct
# information.
#  It is esp. important, to have correct metadata, for distributions like
# Fedora which don't keep old packages around. If you don't like this checking
# interupting your command line usage, it's much better to have something
# manually check the metadata once an hour (yum-updatesd will do this).
# metadata_expire=90m

# PUT YOUR REPOS HERE OR IN separate files named file.repo
# in /etc/yum.repos.d
```



repository 部分定义了每个源/服务器的具体配置，可以有一到多个。常位于/etc/yum.repo.d 目录下的各文件中  

CentOS-Base 这个是联网后基础的源，一般都用这个  
CentOS-Media 这个是使用光盘挂载后调用的文件 ，本地源的配置文件   
CentOS-Vault 这个是最近新版本的加入的老版本的yum源配置  
CentOS-Debuginfo debug包尤其和内核相关的更新和软件安装   


[serverid]
name=Some name for this server
baseurl=url://path/to/repository/

* serverid 是用于区别各个不同的repository，必须有一个独一无二的名称；  
* name 是对repository 的描述，支持像$releasever $basearch这样的变量；
* baseurl 是服务器设置中最重要的部分，只有设置正确，才能从上面获取软件。它的格式是：
    baseurl=url://server1/path/to/repository/
    url://server2/path/to/repository/
    url://server3/path/to/repository/

CentOS-Base.repo:
```shell
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the 
# remarked out baseurl= line instead.
#
#
 
[base]
name=CentOS-$releasever - Base - mirrors.aliyun.com

#name，是对repository的描述，支持像$releasever $basearch这样的变量; name=Fedora Core $releasever - $basearch - Released Updates

failovermethod=priority


#failovermethode 有两个选项roundrobin和priority，意思分别是有多个url可供选择时，yum选择的次序，roundrobin是随机选择，如果连接失 败则使用下一个，依次循环，priority则根据url的次序从第一个开始。如果不指明，默认是roundrobin


baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
		
#其中url支持的协议有 http:// ftp:// file://三种。baseurl后可以跟多个url，你可以自己改为速度比较快的镜像站，但baseurl只能有一个
		
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
 
#released updates 
[updates]
name=CentOS-$releasever - Updates - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/updates/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
 
#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/extras/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/extras/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
 
#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
 
#contrib - packages by Centos Users
[contrib]
name=CentOS-$releasever - Contrib - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/contrib/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/contrib/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/contrib/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
```





