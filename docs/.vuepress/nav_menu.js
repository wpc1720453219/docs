module.exports = [
    {text: '总结', link: '/admin/'},
    {text: '微服务', link: '/microservice/'},
    {
        text: '中间件', items: [
            {
                text: 'ELK', link: '/elk/', items: [
                    {text: 'ELK', link: '/elk/'},
                    {text: 'ELK简要安装文档', link: '/elk/install.md'},
                    {text: 'Filebeat', link: '/elk/filebeat_install.md'},
                    {text: 'logstash', link: '/elk/logstash.md'},
                    {text: '截图及功能说明', link: '/elk/manual.md'},
                    {text: 'faq', link: '/elk/faq.md'},
                    {text: '日志顺序精确到毫秒级以下', link: '/elk/order_under_ms.md'},
                ]
            },
            {
                text: 'Skywalking', items: [
                    {text: 'Skywalking', link: '/skywalking/'},
                    {text: '安装文档', link: '/skywalking/install.md'},
                    {text: '界面功能截图', link: '/skywalking/manual.md'},
                    {text: 'java代码端的使用', link: '/skywalking/use-in-java.md'},
                    {text: 'FAQ', link: '/skywalking/faq.md'},
                    {text: '扩展项目gitlab地址', link: 'http://gitlab.fingard.cn/rdp/skywalking-FG'},
                ]
            },
            {
                text: '配置中心', items: [
                    {text: 'Apollo', link: '/apollo/'},
                ]
            },
            {
                text: '数据库', items: [
                    {text: 'MySQL', link: '/database/mysql.md'},
                    {text: 'Cassandra', link: '/database/cassandra.md'},
                    {text: 'MongoDB', link: '/database/MongoDB.md'},
                    {text: 'Redis', link: '/database/redis.md'},
                    {text: 'Oracle', link: '/database/oracle.md'},
                ]
            },
            {
                text: 'http', items: [
                    {text: 'Nginx安装', link: '/nginx/'},
                ]
            },
            {
                text: 'ftp', items: [
                    {text: 'vsftpd安装', link: '/ftp/vsftpd-install.md'},
                    {text: 'stfp', link: '/ftp/stfp.md'},
                ]
            },
            {
                text: 'RabbitMQ', items: [
                    {text: 'RabbitMQ', link: '/rabbitmq/'},
                    {text: '安装文档-图文版', link: '/rabbitmq/install_with_picture.md'},
                    {text: '安装文档-超精简版', link: '/rabbitmq/install.md'},
                    {text: '安装文档-rabbitmq集群安装', link: '/rabbitmq/rabbitmq主从.md'},
                    {text: 'Spring amqp faq', link: '/rabbitmq/faq_rabbit_template.md'},
                    {text: '延时队列', link: '/rabbitmq/delay.md'},
                ]
            },
            {text: 'Zookeeper', link: '/zookeeper/'},
        ]
    },
    {
        text: 'Jenkins', items: [
            {text: 'Jenkins', link: '/jenkins/'},
            {text: '截图及功能说明', link: '/jenkins/manual.md'},
            {text: '插件介绍', link: '/jenkins/plugins.md'},
            {text: 'jenkins kubernetes插件', link: '/jenkins/kubernetes.md'},
            {text: '问题解决备忘', link: '/jenkins/faq.md'},
            {text: '环境变量参考：env-vars', link: '/jenkins/env-vars.md'},
            {text: '单元测试相关', link: '/jenkins/unit-test.md'},
            {text: 'jenkins docker镜像相关', link: '/jenkins/docker.md'},
        ]
    },
    {
        text: 'Kubernetes', items: [
            {
                text: 'Linux', items: [
                    {text: 'Linux相关', link: '/linux/'},
                    {text: 'Windows相关', link: '/linux/windows.md'},
                    {text: 'wsl', link: '/linux/wsl.md'},
                    {text: '各语言ssh工具', link: '/linux/ssh-program.md'},
                    {text: 'HAProxy', link: '/linux/HAProxy.md'},
                ]
            },
            {
                text: 'Docker', items: [
                    {text: 'Docker', link: '/kubernetes/docker.md'},
                    {text: 'Docker镜像制作', link: '/kubernetes/make_image.md'},
                ]
            },
            {
                text: 'Kubernetes', items: [
                    {text: 'Kubernetes', link: '/kubernetes/'},
                    {text: '连接k8s内网vpn教程', link: '/kubernetes/vpn.md'},
                    {text: 'Dashboard截图及功能说明', link: '/kubernetes/manual.md'},
                    {text: 'K8s + Docker 分享', link: '/kubernetes/k8s_docker_share.md'},
                    {text: 'Helm', link: '/kubernetes/helm.md'},
                    {text: 'k8s操作脚本收藏', link: '/kubernetes/shell.md'},
                    {text: 'essen项目部署文档', link: '/kubernetes/essen_deploy.md'},
                    {text: 'k8s涉及组件清单', link: '/kubernetes/components_list.md'},
                    {text: 'k8s架构、各组件介绍', link: '/kubernetes/architecture.md'},
                    {text: 'Kubernetes核心概念', link: '/kubernetes/concepts.md'},
                    {text: 'faq', link: '/kubernetes/faq.md'},
                    {text: 'etcd', link: '/kubernetes/etcd.md'},
                ]
            },
            {
                text: '独立软件', items: [
                    {text: '开源网盘', link: '/kubernetes/cloud_storage.md'},
                    {text: 'Nexus 3', link: '/nexus/'},
                ]
            },
        ]
    },
    {
        text: '前端', items: [
            {text: '前端技术', link: '/frontend/'},
            {text: 'VuePress', link: '/frontend/vuepress.md'},
            {text: 'Vue', link: '/frontend/vue.md'},
            {text: 'Electron', link: '/frontend/electron.md'},
            {text: 'amis', link: '/frontend/amis.md'},
            {text: 'Echarts', link: '/frontend/echarts.md'},
            {text: 'TypeScript', link: '/frontend/TypeScript.md'},
            {text: '国内镜像', link: '/frontend/mirror.md'},
            {text: '持久化', link: '/frontend/persistent.md'},
            {text: 'Markdown', link: '/frontend/markdown.md'},
            {text: '图形、动画', link: '/frontend/graphics.md'},
        ]
    },
    {
        text: '技术学习', items: [
            {
                text: '反应式', items: [
                    {text: '反应式', link: '/actor/'},
                    {text: 'WebFlux', link: '/actor/webflux.md'},
                    {text: 'Reactor中文文档', link: 'http://devops.gitlab.fingard.cn/docs/actor/spring-reactor-core-zh-doc/reference.html', target:'_blank'},
                ]
            },
            {
                text: 'Java', items: [
                    {text: 'jvm相关', link: '/jvm/'},
                    {text: 'Java', link: '/jvm/java/'},
                    {text: 'Spring', link: '/jvm/java/spring'},
                    {text: 'Groovy', link: '/jvm/groovy/'},
                    {text: 'Kotlin', link: '/jvm/kotlin/'},
                    {text: 'Scala', link: '/scala/'},
                    {text: 'JProfiler', link: '/jvm/jprofiler/'},
                ]
            },
            {
                text: '工作流', items: [
                    {text: '工作流', link: '/workflow/'},
                    {text: 'Activiti 5.16 用户手册', link: '/workflow/activiti5/doc_zh/'},
                    {text: 'jBpm 4 中文文档', link: '/workflow/jbpm4/doc_zh/'},
                ]
            },

            {
                text: '各语言', items: [
                    {text: 'Python', link: '/python/'},
                    {text: 'Golang', link: '/go/'},
                    {text: 'Erlang', link: '/erlang/'},
                ]
            },
            {
                text: '其他单独', items: [
                    {text: '区块链', link: '/blockchain/'},
                    {text: 'IDEA', link: '/ide/idea.md'},
                    {text: 'Git(或其他VCS)', link: '/vcs/'},
                    {text: 'Wiki(知识库、文档管理)', link: '/wiki/'},
                ]
            },
            {
                text: 'GUI', items: [
                    {text: 'GUI', link: '/gui/'},
                    {text: 'wxWidgets', link: '/gui/wxWidgets.md'},
                    {text: 'Qt', link: '/gui/qt.md'},
                ]
            },
        ]
    },
]
