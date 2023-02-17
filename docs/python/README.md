# Python学习

## 链接
1. [flask官方文档](https://flask.palletsprojects.com/)
    1. [flask中文文档（官方文档翻译）](https://dormousehole.readthedocs.io/)
    1. [flask输出json格式数据中文的问题](https://blog.51cto.com/387249/1907536)
        1. [JSON_AS_ASCII](https://flask.palletsprojects.com/en/1.1.x/config/#JSON_AS_ASCII)
1. [TinyDB官方文档](https://tinydb.readthedocs.io/)
    1. [创建TinyDB对应的json.dump参数](https://docs.python.org/3/library/json.html#json.dump)
1. [Python awesome](https://awesome-python.com/)
1. [菜鸟教程 - Python 3 教程](http://www.runoob.com/python3/python3-tutorial.html)
1. [廖雪峰 - Python 3 教程](https://www.liaoxuefeng.com/wiki/1016959663602400)
1. [Fabric文档](http://www.fabfile.org/)
1. [pyinvoke/Invoke文档](http://www.pyinvoke.org/)
1. [python函数的注解：装饰器](https://www.liaoxuefeng.com/wiki/1016959663602400/1017451662295584)
1. [python 多行字符串怎么写才能不破坏缩进](https://ilmvfx.wordpress.com/2014/05/21/python-multiline-string-how-proper-indentation/)
1. [dependency-injector python ioc 工具](https://pypi.org/project/dependency-injector/)
    1. [文档](http://python-dependency-injector.ets-labs.org/)
1. [jinja2文档](http://jinja.pocoo.org/docs/)
    1. [Jinja2中文文档 - w3cschool](https://www.w3cschool.cn/yshfid/)
    1. [Python模板引擎——jinja2的基本用法集锦](https://www.jianshu.com/p/3bd05fc58776)
1. [mysql使用官方文档](https://dev.mysql.com/doc/connector-python/en/)
    
## faq
### 依赖的python包

1. [Python项目生成所有依赖包的清单](https://blog.csdn.net/zhu_19930414/article/details/92701419)

解析python依赖
```bash
pip install pipreqs
pipreqs --encoding=utf-8 --ignore=node_modules --savepath=py_packages.txt ./
```
生成的文件在`./py_packages.txt`，之后再这样安装依赖即可：
```bash
pip install -r py_packages.txt
```

