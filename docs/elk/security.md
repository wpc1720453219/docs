# elk其他安全、认证

#### Search Guard
弃用，7.x的xpack免费版比这个的免费版功能多，还带ui。

第三方插件，配置复杂、麻烦；
1. [Search Guard](https://search-guard.com/)
    - elk系列插件，及时更新，社区版就支持了登录、rbac、索引级权限控制等，其他收费版本只是提供了更精细的功能而已，如文档级、多租户。
    1. [各版本功能对比](https://search-guard.com/licensing/)
    1. [6.x-25 文档](https://docs.search-guard.com/6.x-25/)
    1. [社区版](https://docs.search-guard.com/6.x-25/search-guard-community-edition)
1. [ELK之ElasticSearch 6.4.x安全认证Search Guard6](https://blog.51cto.com/passed/2287142)
    - 这个是非常细致的elk+Search Guard部署教程
1. [ELK权限控制开源方案（6.6.2版本）](https://blog.csdn.net/specter11235/article/details/89199796)
    - elk多种权限认证方案对比，Search Guard是免费/社区版中做的最好的（elk7.1之前）
    - x-pack只有一个月的免费试用权限；elk7.1版本之后免费了部分功能，够用了
1. [searchguard-6的安装和配置 内有禁用https的配置](https://www.jianshu.com/p/42e278c3b1bf)
1. [Optimizing and caching browser bundles... 一直卡在这里是因为内存不足](https://www.cnblogs.com/yeyu1314/p/10358622.html)

#### nginx反向代理
最简单粗暴的方案，在kibana外面再套一层，这一层可以添加诸如ssl、用户登录等功能。
1. [你的Elasticsearch在“裸奔”吗？](https://blog.csdn.net/laoyang360/article/details/86347480) 
