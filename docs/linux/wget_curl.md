## curl
curl 是常用的命令行工具，用来请求 Web 服务器。它的名字就是客户端（client）的 URL 工具的意思。  
它的功能非常强大，命令行参数多达几十种。如果熟练的话，完全可以取代 Postman 这一类的图形界面工具。

[curl 的用法指南](https://www.ruanyifeng.com/blog/2019/09/curl-reference.html)
[curl命令详解](https://blog.csdn.net/mao_xiaoxi/article/details/97764814)

-H  参数添加 HTTP 请求的标头。

-o/–output  把输出写到该文件中。

-O/–remote-name 把输出写到该文件中，保留远程文件的文件名。

-s   参数将不输出错误和进度信息。
命令执行，一旦发生错误，不会显示错误信息。不发生错误的话，会正常显示运行结果。

-S  参数指定只输出错误信息，通常与-s一起使用，如果正常不输出任何信息，发生错误只输出错误信息

-L(--location) — 参数会让 HTTP 请求跟随服务器的重定向。curl 默认不跟随重定向。

-f(--fail) — 表示在服务器错误时，阻止一个返回的表示错误原因的 HTML 页面，而由 curl 命令返回一个错误码 22 来提示错误。

curl -sfL "http://10.60.44.54:8001/s/fEPk974xAc7HE3n/download/test.sh" | sh

curl -sSO http://download.bt.cn/install/install_panel.sh && bash install_panel.sh

下载文件后执行
yum install -y wget && wget -O install.sh https://download.bt.cn/install/install_6.0.sh && sh install.sh ed8484bec
