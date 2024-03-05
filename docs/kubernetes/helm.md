# Helm

> 这里只放helm3的内容

## 链接
1. [Helm官网](https://helm.sh/)
1. [旧版本 helm 2 的内容](./old/helm2.md)
1. [helm官方维护的chart](https://github.com/helm/charts)
1. chart语法参考
    1. [Helm 2 中文文档](http://www.coderdocument.com/docs/helm/v2/index.html)
        - 就使用的细节而言，语法、模板、目录等，2和3是大体上差不多的，可以直接看这个中文文档
    1. [一些链接收集](http://www.coderdocument.com/docs/helm/v2/developing_templates/wrapping_up.html)
    1. [sprig函数库文档](http://masterminds.github.io/sprig/)
        1. [关于map的模板里面没有的操作可以用这个dict的函数](http://masterminds.github.io/sprig/dicts.html)
    1. [go模板字符串文档](https://godoc.org/text/template)


## 安装

```bash
helm completion bash > /usr/share/bash-completion/completions/helm
# 微软中国源（目前采用这个）
helm repo add stable https://mirror.azure.cn/kubernetes/charts/
# 中科大源
# helm repo add stable https://kubernetes-charts.proxy.ustclug.org
# xyyweb源
helm repo add xyyweb http://devops.gitlab.xyyweb.cn/helm-charts
```


## 命令备忘
1. 简单命令
    ```bash
    helm list
    helm install clunky-serval ./mychart/ 
    helm uninstall clunky-serval
    helm ls --all
    helm show values xyyweb/tfp-war
    helm search repo xyyweb
    ```
1. 试验chart
    ```bash
    helm install --debug --dry-run clunky-serval ./mychart/
    ```
1. 获取已部署的详细信息
    ```bash
    helm get manifest clunky-serval
    ```
## Helm 仓库
1. [官方教程：The Chart Repository Guide](https://helm.sh/docs/topics/chart_repository/)

关于怎么打包、发布参考这个。

### nexus3 helm仓库
1. [nexus 版本 3.21 中的新增功能](https://help.sonatype.com/repomanager3/formats/helm-repositories)

可以为helm新起一个nexus，docker仓库比较大，不好备份，升级失败还是比较麻烦的。

### 官方helm自带仓库
1. [docker镜像：alpine/helm](https://hub.docker.com/r/alpine/helm)

可以用这个的命令+docker/k8s的自动重启，来做一个helm源，不过对客户端来说过于复杂了。

### gitlab
直接用gitlab的ci构建，不用源，直接链接取chart文件，指向最新的release即可。
目前这种方式最简单，先采用这个。
具体应用上也没那么多版本控制的概念，已经到应用的最终端了。没必要纠结这个。

默认没缓存，只有最新版。

#### 完整解决方案示例
项目示例：[helm-charts](http://gitlab.xyyweb.cn/devops/helm-charts.git)

添加这个xyyweb源
```bash
helm repo add xyyweb http://devops.gitlab.xyyweb.cn/helm-charts
```

`.gitlab-ci.sh`内容：
```bash
#!/usr/bin/env sh

helm version

mkdir public

# 遍历文件夹，打包chart
for i in `ls`; do
    if [ -f $i/Chart.yaml ]; then
        helm package $i -d public
    fi
done

# 建索引
helm repo index public

ls -alhR public
```

`.gitlab-ci.yml`
```yaml
stages:
  - pages
  - deploy
image:
  name: alpine/helm:3.0.0
  entrypoint: [ "" ]

pages:
  stage: pages
  script:
    - "sh .gitlab-ci.sh"
  artifacts:
    paths:
      - public
  tags:
    - document
  only:
    - master

```
