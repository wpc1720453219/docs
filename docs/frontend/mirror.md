# 国内镜像
npm yarn 设置国内镜像：
```bash
npm set registry https://registry.npm.taobao.org/
yarn config set registry https://registry.npm.taobao.org/
```

## mirror-config-china
使用[mirror-config-china](https://www.npmjs.com/package/mirror-config-china)包，这个会进行更全面的设置，
如`electron`、`node-sass`之类的包都会进行设置。
在`~/.npmrc`里面。
```bash
npm i -g mirror-config-china --registry=https://registry.npm.taobao.org
# 检查是否安装成功 
npm config list
```
产生如下配置：
```bash
chromedriver-cdnurl = "https://npm.taobao.org/mirrors/chromedriver"
couchbase-binary-host-mirror = "https://npm.taobao.org/mirrors/couchbase/v{version}"
debug-binary-host-mirror = "https://npm.taobao.org/mirrors/node-inspector"
disturl = "https://npm.taobao.org/dist"
electron-mirror = "https://npm.taobao.org/mirrors/electron/"
flow-bin-binary-host-mirror = "https://npm.taobao.org/mirrors/flow/v"
fse-binary-host-mirror = "https://npm.taobao.org/mirrors/fsevents"
fuse-bindings-binary-host-mirror = "https://npm.taobao.org/mirrors/fuse-bindings/v{version}"
git4win-mirror = "https://npm.taobao.org/mirrors/git-for-windows"
gl-binary-host-mirror = "https://npm.taobao.org/mirrors/gl/v{version}"
grpc-node-binary-host-mirror = "https://npm.taobao.org/mirrors"
hackrf-binary-host-mirror = "https://npm.taobao.org/mirrors/hackrf/v{version}"
leveldown-binary-host-mirror = "https://npm.taobao.org/mirrors/leveldown/v{version}"
leveldown-hyper-binary-host-mirror = "https://npm.taobao.org/mirrors/leveldown-hyper/v{version}"
mknod-binary-host-mirror = "https://npm.taobao.org/mirrors/mknod/v{version}"
node-sqlite3-binary-host-mirror = "https://npm.taobao.org/mirrors"
node-tk5-binary-host-mirror = "https://npm.taobao.org/mirrors/node-tk5/v{version}"
nodegit-binary-host-mirror = "https://npm.taobao.org/mirrors/nodegit/v{version}/"
operadriver-cdnurl = "https://npm.taobao.org/mirrors/operadriver"
phantomjs-cdnurl = "https://npm.taobao.org/mirrors/phantomjs"
profiler-binary-host-mirror = "https://npm.taobao.org/mirrors/node-inspector/"
puppeteer-download-host = "https://npm.taobao.org/mirrors"
python-mirror = "https://npm.taobao.org/mirrors/python"
rabin-binary-host-mirror = "https://npm.taobao.org/mirrors/rabin/v{version}"
registry = "https://registry.npm.taobao.org/"
sass-binary-site = "https://npm.taobao.org/mirrors/node-sass"
sodium-prebuilt-binary-host-mirror = "https://npm.taobao.org/mirrors/sodium-prebuilt/v{version}"
sqlite3-binary-site = "https://npm.taobao.org/mirrors/sqlite3"
utf-8-validate-binary-host-mirror = "https://npm.taobao.org/mirrors/utf-8-validate/v{version}"
utp-native-binary-host-mirror = "https://npm.taobao.org/mirrors/utp-native/v{version}"
zmq-prebuilt-binary-host-mirror = "https://npm.taobao.org/mirrors/zmq-prebuilt/v{version}"
```

### 为项目生成镜像配置
```bash
cd ~/my-project
mirror-config-china --registry=https://registry.npm.taobao.org
```

## yrm切换yarn源
[yarn 国内加速，修改镜像源](https://learnku.com/articles/15976/yarn-accelerate-and-modify-mirror-source-in-china)
