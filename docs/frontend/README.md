# 前端技术

## mozilla文档
1. [mozilla开发者首页](https://developer.mozilla.org/zh-CN/)
1. [JavaScript 文档](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript)
    - 包含es6，里面有详细的教程，标准手册，可搜索
    1. [Promise使用教程](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Using_promises)
1. [HTTP 文档](https://developer.mozilla.org/zh-CN/docs/Web/HTTP)
    - http标准教程、各请求头含义与支持等手册
    1. [HTTP Status code（状态码）和 Status text（状态文本）](https://www.cnblogs.com/tanweiwei/p/10563714.html)
1. [Web 图形开发](https://developer.mozilla.org/zh-CN/docs/Web/Guide/Graphics)
    1. [SVG](https://developer.mozilla.org/zh-CN/docs/Web/SVG)
    1. [WebGL 文档](https://developer.mozilla.org/zh-CN/docs/Web/API/WebGL_API)
    
## node.js
1. [Node.js官网(中文)](https://nodejs.org/zh-cn/)
1. [nodejs中文文档](http://nodejs.cn/api/)
1. [webpack中文网](https://webpack.docschina.org/)
1. [TypeScript](http://www.typescriptlang.org/)
1. [List of languages that compile to JS 可以编译为js的语言](https://github.com/jashkenas/coffeescript/wiki/List-of-languages-that-compile-to-JS)
1. [nvm node版本管理](https://github.com/nvm-sh/nvm)

### node环境运行的包
1. [ssh2](https://yarnpkg.com/zh-Hans/package/ssh2)
    - ssh、sftp工具包
    - 异步，各种操作需要传回调函数，用起来不方便
    1. [一个ssh2的Channel回调使用示例，处理ssh执行过程中的各种事件，很简洁完善](https://stackoverflow.com/questions/28002103/display-ssh2-stdout-and-stderr-in-textarea)
1. [ssh2-promise](https://yarnpkg.com/zh-Hans/package/ssh2-promise)
    - ssh2的使用promise封装，方便使用es6的async/await语法

### 包管理
1. [npm](https://www.npmjs.com/)
1. [Yarn](https://yarnpkg.com/zh-Hans/)
    1. [npm yarn 命令对比](https://yarnpkg.com/zh-Hans/docs/migrating-from-npm#toc-cli-commands-comparison)
1. [npm trends 不同npm包下载量趋势对比](https://www.npmtrends.com/)
1. [什么是前端模块规范AMD，CMD，CommonJS和UMD？](https://www.jianshu.com/p/00ee4e45c0cd)
1. [module-alias 包](https://www.npmjs.com/package/module-alias)
    - 可用于node下，import的`@`符形式替换`../../`形式，教程：[typescript路径映射踩坑](http://www.gaofeiyu.com/blog/893.html)

公司内网代理源，里面有缓存，尽量用这个：`http://10.60.44.127:8083/nexus3/repository/npm-group/`


## 单元测试
在不怎么写单元测试覆盖代码的情况下，`单元测试`是一种在单个文件写多个main方法的方式，方便学习、测试一小段代码。
1. [jest官网 (中文版) (Facebook开源的)](https://jestjs.io/zh-Hans)
1. [如何用jest测试ts文件](https://segmentfault.com/q/1010000014108219)
1. [jest与异步](https://www.jianshu.com/p/815b3d56b68d)

## 页面框架
1. [angular-vs-react-vs-vue](https://www.npmtrends.com/@angular/core-vs-angular-vs-react-vs-vue)

## 工具包
类似java下Hutool、Guava、apache commons的工具包。
1. [Lodash](https://lodash.com/)
    1. [Lodash仿官网的中文网](https://www.lodashjs.com/)
1. [ESLint忽略指定文件夹办法](https://blog.csdn.net/mhbsoft/article/details/85245316)
1. [handlebars 中文版官网](https://handlebarsjs.com/zh/)
    - 类似jinja2语法的模板引擎
1. [mz](https://classic.yarnpkg.com/zh-Hans/package/mz)
    - node.js的fs等api的现代化封装，特点是全面支持promise，可用await/async语法而不用自己封装
1. [serve-static](https://classic.yarnpkg.com/zh-Hans/package/serve-static)
    - 开放一个端口，起静态资源服务器，和命令行的`serve`作用类似
1. [toposort](https://classic.yarnpkg.com/zh-Hans/package/toposort)
    - 图排序，对于已有工具的算法，就不要尝试手写了，会出莫名其妙的错

