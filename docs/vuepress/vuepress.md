## vuepress
SPA的好处：    
1.减少页面加载时间：传统的多页面应用程序在每次页面切换时都会重新加载整个页面，  
造成不必要的浪费。而SPA只需加载一次页面，之后的内容切换通过AJAX技术局部刷新，减少了服务器的压力，并提升了页面加载速度。  

### 目录结构
```shell
.
├── docs                        
│   ├── .vuepress (可选的)       ## 用于存放全局的配置、组件、静态资源
│   │   ├── components (可选的)  ## 该目录中的 Vue 组件将会被自动注册为全局组件。
│   │   ├── theme (可选的)       ## 用于存放本地主题
│   │   │   └── Layout.vue    
│   │   ├── public (可选的)      ##  静态资源目录。
│   │   ├── styles (可选的)      ##  用于存放样式相关的文件
│   │   │   ├── index.styl      ##  将会被自动应用的全局样式文件，会生成在最终的 CSS 文件结尾，具有比默认样式更高的优先级
│   │   │   └── palette.styl    ##  用于重写默认颜色常量，或者设置新的 stylus 颜色常量。
│   │   ├── templates (可选的, 谨慎配置)   ## 存储 HTML 模板文件
│   │   │   ├── dev.html                ## 用于开发环境的 HTML 模板文件
│   │   │   └── ssr.html                ##  构建时基于 Vue SSR 的 HTML 模板文件
│   │   ├── config.js (可选的)           ##  配置文件的入口文件，也可以是 YML 或 toml
│   │   └── enhanceApp.js (可选的)      ##  客户端应用的增强
│   │  
│   ├── README.md
│   ├── guide
│   │   └── README.md
│   └── config.md
│ 
└── package.json
```

