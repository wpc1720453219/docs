# 持久化

## api
### 浏览器
[IndexedDB](https://developer.mozilla.org/zh-CN/docs/Web/API/IndexedDB_API)

### node.js
fs

## 嵌入式
    
1. 纯JavaScript实现：
    - 综合对比，现在写electron应用持久化可选型`LokiJS`
    > NeDB、LokiJS和 Lowdb都是用纯 JavaScript写的，天生就适合嵌入到 Node和 Electron程序中。
    > ——《Node.js实战（第2版）》p190 第8章 存储数据
    1. [NeDB](https://github.com/louischatriot/nedb)
        - 仿MongoDB的纯js嵌入式json数据库。这个全方位异步化，没并发问题。
        - `published 1.8.0 • 4 years ago`
        1. [w3cschool教程](https://www.w3cschool.cn/nedbintro/)
    1. [LokiJS](http://techfort.github.io/LokiJS/)
        - 仿mongo api
        - 类似redis的隔段时间写硬盘，实际操作的是内存，增删改查为同步操作
        - 三个嵌入式数据库里面，只有这个保持持续更新到现在`published 1.5.8 • 3 months ago`
    1. [Lowdb](https://github.com/typicode/lowdb)
        - `published 1.0.0 • 2 years ago`
        - [Electron-vue开发实战2——引入基于Lodash的JSON数据库lowdb](https://blog.csdn.net/weixin_34116110/article/details/87975579)
1. 其他嵌入式数据库 SQLite、LevelDB、RocksDB、Aerospike、EJDB
1. 趋势对比
    1. [嵌入式nosql：lokijs-vs-lowdb-vs-nedb npm趋势对比](https://www.npmtrends.com/lokijs-vs-lowdb-vs-nedb)
    1. [嵌入式：lokijs-vs-lowdb-vs-nedb-vs-sqlite-vs-sqlite3](https://www.npmtrends.com/lokijs-vs-lowdb-vs-nedb-vs-sqlite-vs-sqlite3)
    1. [所有：lokijs-vs-lowdb-vs-nedb-vs-sqlite-vs-sqlite3-vs-mongoose-vs-mysql-vs-mongodb](https://www.npmtrends.com/lokijs-vs-lowdb-vs-nedb-vs-sqlite-vs-sqlite3-vs-mongoose-vs-mysql-vs-mongodb)

## LokiJS
使用LokiIndexedAdapter的方法：
```typescript
import Loki from 'lokijs'
    
let LokiIndexedAdapter = new Loki('').getIndexedAdapter()
let db = new Loki('absoluteDbFile.db', {
  adapter: new LokiIndexedAdapter(),
  autoload: true,
  autoloadCallback: () => {
    console.log(`db: ${this._dbPath} 已加载`)
  },
  autosave: true,
  autosaveInterval: 1000
})
```

