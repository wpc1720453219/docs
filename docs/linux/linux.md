## linux 核心命令
快速在一个文件夹起一个http服务器：  
npm i -g -d serve ; serve -p 5000  
python2 -m SimpleHTTPServer 5000  
python3 -m http.server 5000


tee  —— 兼顾打印输出屏幕内容并且内容还会重定向到文件内。（通常和管道符连用）  
| tee           相当于  cat  和  >      重定向  
| tee  -a     相当于  cat  和  >>   追加重定向  
[shell-12- tee 重定向 tr字符替换 split文件分割](https://blog.csdn.net/lwj457700209/article/details/99646223)
[管道、xargs、-exec的介绍与区别](https://huaweicloud.csdn.net/635643aed3efff3090b5cc76.html)
[linux xargs,-exec,|管道的区别](https://www.jianshu.com/p/788fb4d66410)
[Linux下多个命令串联执行(管道/xargs/exec)](https://blog.csdn.net/langeldep/article/details/127746040)
