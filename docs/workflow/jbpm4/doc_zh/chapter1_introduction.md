# 第 1 章 导言

最好使用[firefox](http://www.mozilla.com/firefox/)浏览这份教程。 在使用internet explorer的时候会有一些问题。

## 1.1. 许可证与最终用户许可协议

jBPM是依据GNU Lesser General Public License（LGPL） 和JBoss End User License Agreement（EULA）中的协议发布的， 请参考 [完整的LGPL协议](http://www.mossle.com/license.txt)和 [完整的最终用户协议](http://www.mossle.com/jboss.eula.txt)。

## 1.2. 下载

可以从sourceforge上下载发布包。

http://sourceforge.net/projects/jbpm/files/

## 1.3. 源码

可以从jBPM的SVN仓库里下载源代码。

https://anonsvn.jboss.org/repos/jbpm/jbpm4/

## 1.4. 什么是jBPM

jBPM是一个可扩展、灵活的流程引擎， 它可以运行在独立的服务器上或者嵌入任何Java应用中。

## 1.5. 文档内容

在这个用户指南里， 我们将介绍在持久执行模式下的jPDL流程语言。 持久执行模式是指流程定义、 流程执行以及流程历史都保存在关系数据库中， 这是jBPM实际通常使用的方式。

这个用户指南介绍了jBPM中支持的使用方式。 开发指南介绍了更多的、高级的、定制的、 没有被支持的选项。

## 1.6. 从jBPM 3升级到jBPM 4

没办法实现从jBPM 3到jBPM 4的升级。 可以参考开发指南来获得更多迁移的信息。

## 1.7. 报告问题

在用户论坛或者我们的支持门户报告问题的时候， 请遵循如下模板：

```
=== 环境 ==============================
- jBPM Version : 你使用的是哪个版本的jBPM？
- Database : 使用的什么数据库以及数据库的版本
- JDK : 使用的哪个版本的JDK？如果不知道可以使用'java -version'查看版本信息
- Container : 使用的什么容器？（JBoss, Tomcat, 其他）
- Configuration : 你的jbpm.cfg.xml中是只导入了jbpm.jar中的默认配置，
   还是使用了自定义的配置？
- Libraries : 你使用了jbpm发布包中完全相同的依赖库的版本？
   还是你修改了其中一些依赖库？

=== Process ==================================
这里填写jPDL流程定义

=== API ===================================
这里填写你调用jBPM使用的代码片段

=== Stacktrace ==============================
这里填写完整的错误堆栈

=== Debug logs ==============================
这里填写调试日志

=== Problem description =========================
请保证这部分短小精悍并且切入重点。比如，API没有如期望中那样工作。
或者，比如，ExecutionService.SignalExecutionById抛出了异常。
```

聪明的读者可能已经注意到这些问题已经指向了可能导致问题的几点原因：） 特别是对依赖库和配置的调整都很容易导致问题。 这就是为什么我们在包括安装和使用导入实现建议配置机制时花费了大量的精力。 所以，在你开始在用户手册覆盖的知识范围之外修改配置之前，一定要三思而行。 同时在使用其他版本的依赖库替换默认的依赖库之前， 也一定要三思而行。

------
