# Git(或其他VCS)

1. [git官方中文参考书](https://www.git-scm.com/book/zh/v2)


## GitLab
1. [gitlab重建master分支](https://blog.csdn.net/xiaolegeaizy/article/details/103925355)
1. [git提交格式建议（内含emoji表情）](https://momodiy.github.io/blog/git-commit-standard/)

```
命令行指引
您还可以按照以下说明从计算机中上传现有文件。


Git 全局设置
git config --global user.name "孙"
git config --global user.email "pc@xyyweb.com"

创建一个新仓库
git clone http://gitlab.xyyweb.cn/pc/push-test.git
cd push-test
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master

推送现有文件夹
cd existing_folder
git init
git remote add origin http://gitlab.xyyweb.cn/pc/push-test.git
git add .
git commit -m "Initial commit"
git push -u origin master
```
推送现有的 Git 仓库
```bash
cd existing_repo
git remote rename origin old-origin
git remote add origin http://gitlab.xyyweb.cn/pc/push-test.git
git push -u origin --all
git push -u origin --tags

```

### gitlab ci
- [gitlab ci 用户手册](http://gitlab.xyyweb.cn/help/ci/variables/README.md)
里面包含示例、及注入runner的环境变量

## faq
### git仓库同步
试验成功的同步仓库命令：
- 密码必须urlencode，并且!号在linux bash命令行会转义成特殊字符
- --bare 克隆为纯仓库，和远程保持完全一致，并且分支不带remote字样，不检出文件树
- --mirror 把本地所有的分支都推送上去
```bash
git clone --bare http://fg-sunhengtao:shXXX\!%40%23@bitbucket.mstech.com.cn:7990/scm/cmbs/acccore.git tfs
cd tfs
git push --mirror http://pc:XXXXX@gitlab.xyyweb.cn/pc/push-test2.git
```
其他可能成功的方式的参考：
1. [Sync two git repositories Jenkins Pipeline](https://stackoverflow.com/questions/46530742/sync-two-git-repositories-jenkins-pipeline)
    - 这种取认证的方式我没试验成功，但除此之外其他课参考，也有可能是jenkins子pod容器环境比较特殊
1. [Git clone、git reset、git push --mirror 等操作整理](https://www.cnblogs.com/developer-qin/p/6068531.html)

### `\r\n`与`\n`
一般git走默认设置时，windows下会自动转成`\r\n`，普通的文本文件没什么影响，但涉及操作系统的linux `*.sh` 脚本文件，已`\r\n`换行是不能运行的。
解决：
- [git提交后，代码里的\r\n和\n相关](https://blog.csdn.net/u013600225/article/details/53523304)
- [git: 行尾crlf换行符\n与\r\n处理，文件属性(转)](https://blog.csdn.net/weixin_33918114/article/details/86238172)

基本上，执行这个命令可以解决，要用什么格式自己决定，而不是靠git自动转换。
```bash
git config -lobal core.autocrlf false
```

### Github查看issue close掉的版本
在issue的右边有一个Milestone。
![image-20200527155901476](./README.assets/image-20200527155901476.png)

### 子模块
[7.11 Git 工具 - 子模块](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97)

效果像[skywalking](https://github.com/apache/skywalking)主仓库引用ui仓库那样

![image-20200609085714182](./README.assets/image-20200609085714182.png)

### 分支策略
1. [GithubFlow 模式：大厂的第一堂课，完整的git流程](https://www.jianshu.com/p/8b7d025a81dc)
1. [AoneFlow模式](https://www.infoq.cn/article/EaC4c6yiJrzZ_Gtaf9Ne)
