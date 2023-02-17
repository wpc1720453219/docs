# TypeScript

## 链接
1. [TypeScript](http://www.typescriptlang.org/)
1. [官网文档翻译（有即时跟着版本做同步）](https://zhongsp.gitbook.io/typescript-handbook/)
1. [ts编译选项](http://www.typescriptlang.org/docs/handbook/compiler-options.html)
    - --module可以切换导包方式，在electron下有用，原生不支持import: 
        Specify module code generation: "None", "CommonJS", "AMD", "System", "UMD", "ES6", "ES2015" or "ESNext".
    
### 帖子
1. [typescript路径映射踩坑](http://www.gaofeiyu.com/blog/893.html)
    - 于node下，import的`@`符形式替换`../../`形式的问题


## 包
### ts-dedent
- [ts-dedent](https://www.npmjs.com/package/ts-dedent)
解决多行字符串缩进问题

## faq
### string replaceAll
必须使用正则表达式替换，加`g`
```ts
_.replace("abcabc", /ab/g, 'dd')
```
