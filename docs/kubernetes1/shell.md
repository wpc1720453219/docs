# k8s操作脚本收藏
### 停掉一个命名空间的所有deploy
```bash
function stop_namespace() {
    export namespace=$1
    for d in `kubectl get deploy -n $namespace -o name` ; do
    kubectl -n $namespace scale $d --replicas=0
    done
}
```