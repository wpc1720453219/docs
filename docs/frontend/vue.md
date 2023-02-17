# Vue学习

## 链接
1. [Vue.js 中文官网](https://cn.vuejs.org/)
1. [尤雨溪 新手向：Vue 2.0 的建议学习顺序](https://zhuanlan.zhihu.com/p/23134551)

### vue-cli
1. [使用vue-cli 3+构建的vue项目实现保存时按eslint规则自动格式化代码格式](https://blog.csdn.net/qq_39217871/article/details/89390666)
1. [vue的三个模式：环境变量和模式](https://cli.vuejs.org/zh/guide/mode-and-env.html#%E6%A8%A1%E5%BC%8F)

### ts支持
1. [Vue Class Component 官方英文文档](https://class-component.vuejs.org/)
1. [Vue 3.0前的 TypeScript 最佳入门实践](https://mp.weixin.qq.com/s/Zj-QXvAbd7yRnkUv_drHSw)
1. [[Vue + TS] Use Dependency Injection in Vue Using @Inject and @Provide Decorators with TypeScript](https://www.cnblogs.com/Answer1215/p/7522484.html)


### demo项目
1. [vue-element-admin](https://panjiachen.gitee.io/vue-element-admin-site/zh/)
    1. [在线预览](https://panjiachen.gitee.io/vue-element-admin)
1. [vue-typescript-admin](https://armour.github.io/vue-typescript-admin-docs/zh/)
    - 这一系列项目的ts版本
    1. [在线预览](https://armour.github.io/vue-typescript-admin-template)
    1. [便于二次开发的模板项目，在`minimal`分支](https://github.com/Armour/vue-typescript-admin-template/blob/minimal/README-zh.md)
1. [electron-vue-admin](https://github.com/PanJiaChen/electron-vue-admin)
    - 这一系列项目使用electron的模板项目

### Element
1. [element官网](https://element.eleme.cn/#/zh-CN)
1. [在项目中引入element](https://element.eleme.cn/#/zh-CN/component/quickstart#yin-ru-element)
   - 注意不要漏掉css的那一行的引入

### 其他组件
1. [axios](https://github.com/axios/axios)

### Ant Design of Vue
1. [Ant Design of Vue](https://www.antdv.com/docs/vue/introduce-cn/)

### 小组件
1. [vue 瀑布流组件](https://www.jianshu.com/p/f20b35adad24)

## live2d
1. [VuePress集成Live2D看板娘 Live2D plugin for VuePress. 【真正的使用参考这个】](https://github.com/JoeyBling/vuepress-plugin-helper-live2d) 
    1. [这个插件所支持几种模型](https://github.com/JoeyBling/hexo-theme-yilia-plus/wiki/live2d%E6%A8%A1%E5%9E%8B%E5%8C%85%E5%B1%95%E7%A4%BA)
1. [源头：一篇博客的效果](https://www.cnblogs.com/zjfjava/p/7639535.html)
1. [live2d官网](https://www.live2d.com/zh-CHS/)
1. [把萌萌哒的看板娘抱回家 | Live2D widget for web platform【最简单粗暴的用法】](https://github.com/stevenjoezhang/live2d-widget)

> 注意: vuepress页面异常并报和包相关的错误的话，把npm的清理掉，使用yarn，貌似npm对vuepress的依赖解析有问题。

## faq
### idea、webstorm识别`@`符路径地址
[让webstorm 识别vue cli3项目中的@路径别名正确解析的配置方法](https://blog.csdn.net/weixin_43343144/article/details/88668787)

在setting -> languages&frameworks -> webpack里选择配置文件路径为 node_modules/@vue/cli-service/webpack.config.js即可。

需要注意的是如果在scss中使用@别名则需要加~号。比如在src目录下有一个var.scss文件，其他文件引用时则需写成：
```vue
@import "~@/var.scss";
```

### ide识别vue的jsx语法
[webstorm如何支持识别vue的jsx语法。](https://segmentfault.com/q/1010000010111321)


### eslint自动修复
在package.json里面加上这两句可以自动检查、修复的命令。
```json
{
    "lint": "eslint --ext .js,.vue src",
    "lint:fix": "eslint --ext .js,.vue --fix src"
}
```
### vue/vuepress构建莫名其妙失败
涉及vue时，[不要随意改动NODE_ENV环境变量](https://github.com/vuejs/vuepress/issues/2194)，会产生莫名其妙的问题的。

### vuex设置对象报错
在vuex里面定义一个非简单类型的对象时，set会报错，如下：
```
Uncaught (in promise) Error: ERR_ACTION_ACCESS_UNDEFINED: Are you trying to access this.someMutation() or this.someGetter inside an @Action? 
That works only in dynamic modules. 
If not dynamic use this.context.commit("mutationName", payload) and this.context.getters["getterName"]
Error: Could not perform action fetchDtoMetas
    at Store.eval (webpack-internal:///./node_modules/vuex-module-decorators/dist/esm/index.js:334:37)
    at step (webpack-internal:///./node_modules/vuex-module-decorators/dist/esm/index.js:114:23)
    at Object.eval [as throw] (webpack-internal:///./node_modules/vuex-module-decorators/dist/esm/index.js:95:53)
    at rejected (webpack-internal:///./node_modules/vuex-module-decorators/dist/esm/index.js:86:65)
TypeError: Cannot set property dtoMetas of #<Object> which has only a getter
    at Object._callee$ (webpack-internal:///./src/store/modules/app.ts:143:31)
    at tryCatch (webpack-internal:///./node_modules/regenerator-runtime/runtime.js:45:40)
    at Generator.invoke [as _invoke] (webpack-internal:///./node_modules/regenerator-runtime/runtime.js:271:22)
    at Generator.prototype.<computed> [as next] (webpack-internal:///./node_modules/regenerator-runtime/runtime.js:97:21)
    at asyncGeneratorStep (webpack-internal:///./node_modules/@babel/runtime-corejs2/helpers/esm/asyncToGenerator.js:9:24)
    at _next (webpack-internal:///./node_modules/@babel/runtime-corejs2/helpers/esm/asyncToGenerator.js:31:9)
    at Store.eval (webpack-internal:///./node_modules/vuex-module-decorators/dist/esm/index.js:328:35)
    at step (webpack-internal:///./node_modules/vuex-module-decorators/dist/esm/index.js:114:23)
    at Object.eval [as throw] (webpack-internal:///./node_modules/vuex-module-decorators/dist/esm/index.js:95:53)
    at rejected (webpack-internal:///./node_modules/vuex-module-decorators/dist/esm/index.js:86:65)
```
vuex不支持对象格式字段的`set`方法，而允许更改已经初始化号的对象。

可以更改设置字段容器里面的内容来实现更改，而不是更换字段自身。比如
```typescript
import { VuexModule, Module, Mutation, Action } from 'vuex-module-decorators'
import store from '@/store'
import { DtoMeta } from '@/dto/DtoMeta'
import { dtoMetaApi } from '@/api/DtoMetaApi'

Module({ dynamic: true, store, name: 'app' })
class App extends VuexModule implements IAppState {
  public dtoMetas: Map<string, DtoMeta> = new Map()

  @Mutation
  setDtoMetas(dtoMetas:Map<string, DtoMeta>) {
    this.dtoMetas.clear()
    dtoMetas.forEach((value, key) => this.dtoMetas.set(key, value))
  }

  @Action
  public async fetchDtoMetas() {
    let map = await dtoMetaApi.all()
    this.setDtoMetas(map)
  }
}
```

### vuex使用规则
1. [Mutation](https://vuex.vuejs.org/zh/guide/mutations.html)
1. [Action](https://vuex.vuejs.org/zh/guide/actions.html)

- Mutation为同步，vuex存储的状态只能通过Mutation来改变；
- Action为异步，可以有任何异步操作，可以调用Mutation，但不能改变存储状态。

### websocket的使用
1. [Vue中使用websocket的正确使用方法](https://www.jianshu.com/p/9d8b2e42328c)
1. [利用WebSocket和EventSource实现服务端推送](https://www.jianshu.com/p/958eba34a5da)
    1. [How to read stream+json responses from Vuejs?](https://stackoverflow.com/questions/52802922/how-to-read-streamjson-responses-from-vuejs)

### vue router
1. [vue项目刷新当前页面](https://segmentfault.com/a/1190000017007631)
1. [通过url地址刷新路由的方式](https://armour.github.io/vue-typescript-admin-docs/zh/guide/essentials/router-and-nav.html#%E7%82%B9%E5%87%BB%E4%BE%A7%E8%BE%B9%E6%A0%8F-%E5%88%B7%E6%96%B0%E5%BD%93%E5%89%8D%E8%B7%AF%E7%94%B1)
