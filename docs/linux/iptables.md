## iptables详解  
### NAT 网络地址转换  
[网络地址转换NAT（详细）](https://blog.csdn.net/qq_983030560/article/details/128449410)     
[NAT网络地址转换与配置](https://blog.csdn.net/wang_dian1/article/details/129715450)  
传统NAT技术 不带端口号的, 私网ip和目的ip地址的 一一映射  
后面发展，通过端口的方式， 可以让私网的多个ip相同端口对接目的ip的多个端口进行转发  

### iptables  
Linux平台下的 包过滤防火墙、免费、完成封包过滤、封包重定向和网络地址转换（NAT）等功能

[iptables基础知识详解](https://blog.csdn.net/u011537073/article/details/82685586?spm=1001.2101.3001.6650.5&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-5-82685586-blog-109674599.pc_relevant_recovery_v2&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-5-82685586-blog-109674599.pc_relevant_recovery_v2&utm_relevant_index=10)



iptables 规则

> 规则一般的定义为“如果数据包头符合这样的条件，就这样处理这个数据包”。规则存储在内核空间的信息 包过滤表中，这些规则分别指定了源地址、目的地址、传输协议（如TCP、UDP、ICMP）和服务类型（如HTTP、FTP和SMTP）等。当数据包与规则匹配时， iptables就根据规则所定义的方法来处理这些数据包，如放行（accept）、拒绝（reject）和丢弃（drop）等。配置防火墙的 主要工作就是添加、修改和删除这些规则。

iptables和netfilter的关系：

iptables只是Linux防火墙的管理工具而已，位于/sbin/iptables。真正实现防火墙功能的是 netfilter，它是Linux内核中实现包过滤的内部结构。


iptables的规则表和链：
表（tables）提供特定的功能，iptables内置了4个表，即filter表、nat表、mangle表和raw表，分别用于实现包过滤，网络[地址转换](https://so.csdn.net/so/search?q=%E5%9C%B0%E5%9D%80%E8%BD%AC%E6%8D%A2&spm=1001.2101.3001.7020) 、包重构(修改)、数据跟踪处理。
链（chains）是数据包传播的路径，每一条链其实就是众多规则中的一个检查清单，每一条链中可以有一 条或数条规则。









