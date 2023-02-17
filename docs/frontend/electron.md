# Electron学习

## 链接
1. [Electron官网](https://electronjs.org/)
    1. [Electron API 示例程序 中文版](https://github.com/demopark/electron-api-demos-Zh_CN)
    1. [Electron Fiddle 快速小段程序学习](https://electronjs.org/fiddle)
    1. [Electron 文档 - 开发工具扩展程序](https://electronjs.org/docs/tutorial/devtools-extension)
        1. [vue-devtools 这个不必翻墙](https://www.npmjs.com/package/vue-devtools)
1. [electron-vue 脚手架，可以避免很多问题](https://simulatedgreg.gitbooks.io/electron-vue/content/cn/)
    1. [这一页的`vue 路由 > 注意`里面有提到，只能用vue router的hash模式，不能用历史模式](https://simulatedgreg.gitbooks.io/electron-vue/content/cn/renderer-process.html)
1. [electron-debug](https://github.com/sindresorhus/electron-debug)
1. [webstorm debug render进程](https://blog.jetbrains.com/webstorm/2016/05/getting-started-with-electron-in-webstorm/)

## faq
### electron下载慢
或者直接install失败。

#### 解决办法
如果已经有下载，先删掉文件夹`node_modules/electron`。

操作系统、或install命令设置这个环境变量。
```properties
ELECTRON_MIRROR=http://npm.taobao.org/mirrors/electron/
```
### ts下的使用
1. [Electron使用TypeScript](https://www.jianshu.com/p/63710a444827)
    - 项目搭建可参考这个
1. [vue+ts+electron踩坑记录](https://www.jianshu.com/p/c1ce10fb4ca6)
    - 项目写代码遇到问题可参考这个

其他：
1. [配置|electron+vue+ts+sqlite配置](https://segmentfault.com/a/1190000015559639)


## 一些总结
1. 可用`ipcRenderer.once(channel, listener)`做不同请求的区分，可以是类似一个url的不同请求
1. 一个electron应用写好后，或许可以考虑下兼容处理，做成chrome插件
1. [4、渲染线程renderer中引入Electron报错](https://www.cnblogs.com/wonyun/p/10991984.html)

### 使用`module-alias`包
解决main进程不能识别@符的问题
```typescript
const moduleAlias = require('module-alias')

// 在package.json里面配置的方式，electron-builder并不认识，采用高级方式，可使两种环境都能用
// https://www.npmjs.com/package/module-alias
// https://github.com/ilearnio/module-alias/issues/50#issuecomment-515705625
moduleAlias.addAlias('@', __dirname + '/../')

moduleAlias()
```
