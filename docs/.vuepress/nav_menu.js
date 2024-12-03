module.exports = [
    {text: 'java', link: '/microservice/'},
    {
        text: 'devops', items: [
            {
                    {text: 'sshd', link: '/linux/0.ssh&&sshd_config.md'},
                    {text: 'iptables', link: '/linux/iptables.md'},
                    {text: 'systemd', link: '/linux/2.systemd.md'},
                    {text: 'rpm与yum', link: '/linux/1.yum_rpm_apt.md'},
                    {text: 'wget与curl', link: '/linux/wget_curl.md'},

                    {text: '软连接数据迁移', link: '/linux/软连接数据迁移.md'},
                    {text: 'DNS', link: '/linux/DNS.md'},
                    {text: 'centos7服务器初始化', link: '/linux/Centos 7 服务器初始化脚本.md'},
                    {text: 'Almalinux8服务器初始化', link: '/linux/Almalinux 8 服务器初始化脚本.md'},
                    {text: '硬盘分区', link: '/linux/硬盘分区.md.md'},
                ]
            },
            {
                text: 'docker', link: '/docker/docker.md', items: [
                    {text: 'docker', link: '/docker/docker.md'},
                    {text: 'docker配置', link: '/docker/docker_config.md'},
                ]
            },
            {
                text: 'kubernetes', link: '/kubernetes/k8s总结.md', items: [
                    {text: 'k8s', link: '/kubernetes/k8s总结.md'},
                    {text: 'k8s配置', link: '/kubernetes/k8s.md'},
                    {text: 'k3s', link: '/kubernetes/k3s.md'}
                ]
            }
        ]
    },

    {
        text: '中间件', items: [
            {text: 'jdk', link: '/jdk/jdk.md'},
            {text: 'zookeeper', link: '/zookeeper/'},
            {text: 'mysql', link: '/mysql/mysql.md'},
            {
                text: 'redis', link: '/redis/redis.md', items: [
                    {text: 'redis', link: '/redis/redis.md'},
                    {text: 'redis配置', link: '/redis/redis_conf.md'},
                    {text: 'docker-redis', link: '/redis/docker-redis.md'}
                ]
            },
            {
                text: 'nginx', link: '/nginx/', items: [
                    {text: 'nginx', link: '/nginx/'},
                    {text: '性能优化', link: '/nginx/性能优化.md'},
                    {text: '证书', link: '/nginx/证书.md'}
                ]
            },


            {
                text: 'jdk', link: '/jdk/jdk.md', items: [
                    {text: 'jdk', link: '/jdk/jdk.md'},
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
                    {text: '扩展项目gitlab地址', link: 'http://gitlab.xyyweb.cn/rdp/skywalking-FG'},
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
        text: '问题排查', items: [
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
        text: '其他软件', items: [
            {
                text: 'Linux', link: '/linux/', items: [
                    {text: 'iptables', link: '/linux/iptables.md'},
                    {text: 'systemd', link: '/linux/systemd.md'},
                    {text: 'rpm与yum的区别', link: '/linux/yan_rpm_apt.md'},
                    {text: 'ssh详情', link: '/linux/ssh&&sshd_config.md'},
                    {text: '远程操作wget与curl', link: '/linux/wget_curl.md'},
                    {text: '硬盘分区', link: '/linux/硬盘分区.md.md'},
                ]
            },
            {text: 'shell', link: '/shell/'},
            {text: 'docker', link: '/docker/'}
        ]
    },
]
