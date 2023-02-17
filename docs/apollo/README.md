# Apollo

1. [官方github代码库](https://github.com/ctripcorp/apollo)
1. [单环境快速启动文档](https://github.com/ctripcorp/apollo/wiki/Quick-Start)
    - 有了`集群`的概念，其实也就不需要多环境了
1. [集群的使用](https://github.com/ctripcorp/apollo/wiki/Java%E5%AE%A2%E6%88%B7%E7%AB%AF%E4%BD%BF%E7%94%A8%E6%8C%87%E5%8D%97#1242-cluster%E9%9B%86%E7%BE%A4)
    - apollo的`环境`的概念涉及数据库的搭建与应用的启动，一个`环境`需要起两个微服务，建一个数据库，而`集群`的概念可以解决这个问题。
    - java端区分集群只需要加一个-Dapollo.cluster=SomeCluster参数即可。
1. [faq 部署&开发遇到的常见问题](https://github.com/ctripcorp/apollo/wiki/%E9%83%A8%E7%BD%B2&%E5%BC%80%E5%8F%91%E9%81%87%E5%88%B0%E7%9A%84%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98)


## 启动apollo的简单方式

这种方式各操作系统windows、linux、mac通用。

1. [下载这个里面对应版本的sql、jar包](https://github.com/nobodyiam/apollo-build-scripts)
2. 把sql文档导入到mysql新建的两个库
3. 启动：
```bash
java -Xms256m -Xmx256m -Denv=fat -Dspring.datasource.url=jdbc:mysql://192.168.52.11:3306/appollo_config_fat?characterEncoding=utf8 -Dspring.datasource.username=root -Dspring.datasource.password=123456 -jar apollo-all-in-one.jar start --configservice --adminservice
```
配置服务端口：8080
admin服务端口：8090
```bash
java -Xms256m -Xmx256m -Dserver.port=8070 -Dfat_meta=http://localhost:8080 -Dspring.datasource.url=jdbc:mysql://192.168.52.11:3306/appollo_portal?characterEncoding=utf8 -Dspring.datasource.username=root -Dspring.datasource.password=123456 -jar apollo-all-in-one.jar start --portal
```
管理界面端口：8070

## faq

### Q: 连不上apollo本机启动
通过增加启动参数-Denv=local，可以只加载本地的apollo配置，
本地配置位于${你的用户目录}\sword\data\apollo\，
比如C:\Users\Iceberg\sword\data\apollo\USERCORE\config-cache

## apollo支持helm部署
[分布式部署指南 (apolloconfig.com)](https://www.apolloconfig.com/#/zh/deployment/distributed-deployment-guide?id=_24-kubernetes%e9%83%a8%e7%bd%b2)  
[README (apolloconfig.com)](https://charts.apolloconfig.com/)

## apollo升级版本数据库脚本
[apollo/scripts/sql/delta at master · apolloconfig/apollo (github.com)](https://github.com/apolloconfig/apollo/tree/master/scripts/sql/delta)
```sql
-- config
CREATE TABLE `AccessKey` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `AppId` varchar(500) NOT NULL DEFAULT 'default' COMMENT 'AppID',
  `Secret` varchar(128) NOT NULL DEFAULT '' COMMENT 'Secret',
  `IsEnabled` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: enabled, 0: disabled',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '1: deleted, 0: normal',
  `DataChange_CreatedBy` varchar(32) NOT NULL DEFAULT 'default' COMMENT '创建人邮箱前缀',
  `DataChange_CreatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `DataChange_LastModifiedBy` varchar(32) NOT NULL DEFAULT '' COMMENT '最后修改人邮箱前缀',
  `DataChange_LastTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`Id`),
  KEY `AppId` (`AppId`(191)),
  KEY `DataChange_LastTime` (`DataChange_LastTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='访问密钥';

-- protal
ALTER TABLE `Users`
    MODIFY COLUMN `Username` varchar(64) NOT NULL DEFAULT 'default' COMMENT '用户登录账户',
    ADD COLUMN `UserDisplayName` varchar(512) NOT NULL DEFAULT 'default' COMMENT '用户名称' AFTER `Password`;

-- 这句执行失败
-- UPDATE `Users` SET `UserDisplayName`=`Username` WHERE `UserDisplayName` = 'default';

ALTER TABLE `Users`
    MODIFY COLUMN `Password` varchar(512) NOT NULL DEFAULT 'default' COMMENT '密码';

-- spring session (https://github.com/spring-projects/spring-session/blob/faee8f1bdb8822a5653a81eba838dddf224d92d6/spring-session-jdbc/src/main/resources/org/springframework/session/jdbc/schema-mysql.sql)
CREATE TABLE SPRING_SESSION (
	PRIMARY_ID CHAR(36) NOT NULL,
	SESSION_ID CHAR(36) NOT NULL,
	CREATION_TIME BIGINT NOT NULL,
	LAST_ACCESS_TIME BIGINT NOT NULL,
	MAX_INACTIVE_INTERVAL INT NOT NULL,
	EXPIRY_TIME BIGINT NOT NULL,
	PRINCIPAL_NAME VARCHAR(100),
	CONSTRAINT SPRING_SESSION_PK PRIMARY KEY (PRIMARY_ID)
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;

# 三个加索引的执行失败
# CREATE UNIQUE INDEX SPRING_SESSION_IX1 ON SPRING_SESSION (SESSION_ID);
# CREATE INDEX SPRING_SESSION_IX2 ON SPRING_SESSION (EXPIRY_TIME);
# CREATE INDEX SPRING_SESSION_IX3 ON SPRING_SESSION (PRINCIPAL_NAME);

CREATE TABLE SPRING_SESSION_ATTRIBUTES (
	SESSION_PRIMARY_ID CHAR(36) NOT NULL,
	ATTRIBUTE_NAME VARCHAR(200) NOT NULL,
	ATTRIBUTE_BYTES BLOB NOT NULL,
	CONSTRAINT SPRING_SESSION_ATTRIBUTES_PK PRIMARY KEY (SESSION_PRIMARY_ID, ATTRIBUTE_NAME),
	CONSTRAINT SPRING_SESSION_ATTRIBUTES_FK FOREIGN KEY (SESSION_PRIMARY_ID) REFERENCES SPRING_SESSION(PRIMARY_ID) ON DELETE CASCADE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC;
 
```

