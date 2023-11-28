## vuepress
###与其他区别
* Nuxt
  VuePress 能做的事情，Nuxt 理论上确实能够胜任，但 Nuxt 是为构建应用程序而生的，  
  而 VuePress 则专注在以内容为中心的静态网站上，同时提供了一些为技术文档定制的开箱即用的特性。
  
* Docsify / Docute  
  这两个项目同样都是基于 Vue，然而它们都是完全的运行时驱动，因此对 SEO 不够友好。如果你并不关注 SEO，同时也不想安装大量依赖，它们仍然是非常好的选择！

* Hexo
  Hexo 一直驱动着 Vue 的文档 —— 事实上，在把我们的主站从 Hexo 迁移到 VuePress 之前，我们可能还有很长的路要走。  
  Hexo 最大的问题在于他的主题系统太过于静态以及过度地依赖纯字符串，而我们十分希望能够好好地利用 Vue 来处理我们的布局和交互，同时，Hexo 的 Markdown 渲染的配置也不是最灵活的。
  
* GitBook
  我们的子项目文档一直都在使用 GitBook。GitBook 最大的问题在于当文件很多时，每次编辑后的重新加载时间长得令人无法忍受。  
  它的默认主题导航结构也比较有限制性，并且，主题系统也不是 Vue 驱动的。GitBook 背后的团队如今也更专注于将其打造为一个商业产品而不是开源工具。

### 目录结构
```shell
.
├── docs
│   ├── .vuepress (可选的)    #用于存放全局的配置、组件、静态资源等。
│   │   ├── components (可选的) # 该目录中的 Vue 组件将会被自动注册为全局组件。
│   │   ├── theme (可选的)       #用于存放本地主题。
│   │   │   └── Layout.vue 
│   │   ├── public (可选的)     #静态资源目录。
│   │   ├── styles (可选的)    #用于存放样式相关的文件。
│   │   │   ├── index.styl    #将会被自动应用的全局样式文件，会生成在最终的 CSS 文件结尾，具有比默认样式更高的优先级。
│   │   │   └── palette.styl   #  用于重写默认颜色常量，或者设置新的 stylus 颜色常量。
│   │   ├── templates (可选的, 谨慎配置)  # 存储 HTML 模板文件。
│   │   │   ├── dev.html                   #用于开发环境的 HTML 模板文件。
│   │   │   └── ssr.html                #构建时基于 Vue SSR 的 HTML 模板文件。
│   │   ├── config.js (可选的)         #配置文件的入口文件，也可以是 YML 或 toml
│   │   └── enhanceApp.js (可选的)      #客户端应用的增强。
│   │ 
│   ├── README.md
│   ├── guide
│   │   └── README.md
│   └── config.md
│ 
└── package.json
```
