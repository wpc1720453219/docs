# Groovy

1. [Groovy 官网](http://www.groovy-lang.org/)
1. [groovy 的强断言](https://www.cnblogs.com/alighie/p/8253780.html)

## faq

### 多行字符串修建缩进
```groovy
    '''
        a
        b
    '''.stripIndent()
```

### 转java
groovy文件在idea里面可以直接 `右键 -> Refactor -> Convert to Java` 转成java文件。

## 字符串拼接对比
java:

com.nbcb.tmsforexservice.common.util.CommonUtil
```java
	/**
	 * 时间转换为oracle适用时间
	 * @Title: toOracleDateTime
	 * @Description: 转换成oracle所需要的日期格式("yyyy-MM-dd HH24:mi:ss")
	 * @param date 待转换时间
	 * @return . String 返回类型
	 * @throws
	 * @version 创建时间：2010-9-28 上午11:15:33
	 */
	public static String toOracleDateTime(Date date) {
		StringBuffer bf = new StringBuffer();
		bf.append("to_date('");
		bf.append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		bf.append("','");
		bf.append("yyyy-MM-dd HH24:mi:ss");
		bf.append("')");
		return bf.toString();
	}
	public static String toMysqlDateTime(Date date) {
		StringBuffer bf = new StringBuffer();
		bf.append("str_to_date('");
		bf.append(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date));
		bf.append("','");
		bf.append("%Y-%m-%d %H:%i:%s");
		bf.append("')");
		return bf.toString();
	}

```

groovy:

```groovy
    // 这个的逻辑和上面那个java的对应，连声明日期转换的地方也差不多对应
    @Test
    public void testStr() throws Exception {
        Date date = new Date()
        println("to_date('${new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date)}','%Y-%m-%d %H:%i:%s')")
    }

    String getDefaultEnvClause() {
        return """
        export JAVA_HOME=${javaHome}
        export PATH=\$JAVA_HOME/bin:\$PATH
        export TZ=Asia/Shanghai
        """.stripIndent()
    }

    def writeTextFile(String filePathInBase, String fileContent) {
        def absolutePath = getRemoteAbsolutePath(filePathInBase)
        ensureRemoteDir(PathUtil.dir(absolutePath))
        exec("""
        cat << EOF > ${absolutePath}
        ${fileContent.stripIndent()}
        EOF
        """.stripIndent())
    }
```

### 克隆对象
1. [@AutoClone 文档](http://docs.groovy-lang.org/latest/html/api/groovy/transform/AutoClone.html)
1. [更简便的克隆（cloning）与具体化（externalizing）](https://blog.csdn.net/weixin_34248849/article/details/91814571)

### Closure闭包递归
call代表自身。
- [Groovy 中的funtion 和 Closure：方法递归与闭包递归](https://blog.csdn.net/Allocator/article/details/84860885)
