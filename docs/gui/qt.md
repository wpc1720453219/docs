# Qt

1. [开源qt官网](https://www.qt.io/download-open-source)
1. [Qt for Python (官方qt binding)](https://doc.qt.io/qtforpython/)
1. [支持的语言 Language Bindings](https://wiki.qt.io/Language_Bindings)
1. [Qt维基百科 有更详细的语言支持程度信息](https://zh.wikipedia.org/wiki/Qt)
1. [使用qt写的软件](https://github.com/JesseTG/awesome-qt#software-that-uses-qt)
1. [Awesome Qt](https://github.com/JesseTG/awesome-qt)
1. [qt各版本下载](http://download.qt.io/archive/qt/)
1. [qt设置临时储存库](https://www.cnblogs.com/SaveDictator/p/8532664.html)

## go qt
1. [golang qt binding](https://github.com/therecipe/qt)
2. [一个中文博客，可以参考着入门](https://www.cnblogs.com/apocelipes/tag/Qt/)
3. [安装bug解决](https://github.com/therecipe/qt/issues/939)

### 安装步骤
设置git代理、命令行代理
```cmd
set https_proxy=http://127.0.0.1:38088
set http_proxy=http://127.0.0.1:38088
```
安装文档指定的qt版本，下载全量安装包，除android、x86之类一看就没用的，全部勾选上，包括Deprecated的组件，否则可能安装失败
执行：
下载go包，注意：这里会访问google.com、github.com、golang.org至少这三个网站，代理是必须的，否则失败
```cmd
go get -v  -u github.com/therecipe/qt/cmd/...
```
测试qt
```cmd
%GOPATH%\bin\qtsetup test
```
编译安装
```cmd
%GOPATH%\bin\qtsetup -test=false
```