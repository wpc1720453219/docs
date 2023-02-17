module.exports = {
    title: '工作总结文档',
    base: '/docs/',
    dest: 'public',
    description: 'Just playing around',
    head: [
        // add jquert and fancybox
        // ['script', { src: 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.slim.min.js' }],
        // ['script', { src: 'https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.2/jquery.fancybox.min.js' }],
        // ['link', { rel: 'stylesheet', type: 'text/css', href: 'https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.2/jquery.fancybox.min.css' }]
    ],
    markdown: {
        lineNumbers: true
    },
    plugins: {
        '@vuepress/back-to-top': {},
        '@vuepress/medium-zoom': {
            selector: 'img',
            // medium-zoom options here
            // See: https://github.com/francoischalifour/medium-zoom#options
            options: {
                margin: 16
            }
        },
        // 'vuepress-plugin-helper-live2d': {
        //     live2d: {
        //         // 是否启用(关闭请设置为false)(default: true)
        //         enable: false,
        //         // 模型名称(default: hibiki)>>>取值请参考：
        //         // https://github.com/JoeyBling/hexo-theme-yilia-plus/wiki/live2d%E6%A8%A1%E5%9E%8B%E5%8C%85%E5%B1%95%E7%A4%BA
        //         model: 'shizuku',
        //         display: {
        //             position: "right", // 显示位置：left/right(default: 'right')
        //             width: 200, // 模型的长度(default: 135)
        //             height: 300, // 模型的高度(default: 300)
        //             hOffset: 65, //  水平偏移(default: 65)
        //             vOffset: 0, //  垂直偏移(default: 0)
        //         },
        //         mobile: {
        //             show: false // 是否在移动设备上显示(default: false)
        //         },
        //         react: {
        //             opacity: 0.8 // 模型透明度(default: 0.8)
        //         }
        //     }
        // }
    },
    themeConfig: {
        //导航栏：`items`表示嵌套，`link`表示链接
        nav: require('./nav_menu'),
        lastUpdated: '更新时间', // string | boolean
        //右上角那个查看源码
        repo: 'http://gitlab.fingard.cn/devops/docs',
        repoLabel: '查看源码',
        docsRepo: 'http://gitlab.fingard.cn/devops/docs',
        docsDir: 'docs',
        sidebarDepth: 5,
        //侧边栏自动显示当前页面的目录
        sidebar: 'auto',
        serviceWorker: {
            updatePopup: true // Boolean | Object, 默认值是 undefined.
            // 如果设置为 true, 默认的文本配置将是:
            // updatePopup: {
            //    message: "New content is available.",
            //    buttonText: "Refresh"
            // }
        },
        // 默认是 false, 设置为 true 来启用
        editLinks: true,
        // 默认为 "Edit this page"
        editLinkText: '帮助我们改善此页面！',
        displayAllHeaders: true // 默认值：false
    }

};
