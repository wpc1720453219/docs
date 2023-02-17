# 第 9 章 Configuration配置

## 9.1. 工作日历

如果希望自定义工作日历， 需要导入的默认工作日历配置 使用你自定义的工作日历进行替换。比如。

```xml
<jbpm-configuration>

  <import resource="jbpm.businesscalendar.cfg.xml" />
  ...

  <process-engine-context>
    <business-calendar>
      <monday    hours="9:00-18:00"/>
      <tuesday   hours="9:00-18:00"/>
      <wednesday hours="9:00-18:00"/>
      <thursday  hours="9:00-18:00"/>
      <friday    hours="9:00-18:00"/>
      <holiday period="01/02/2009 - 31/10/2009"/>
    </business-calendar>
  </process-engine-context>

</jbpm-configuration>
```

## 9.2. Console控制台

默认情况下，console控制台所在的web应用服务端 的host和port为`localhost` 和`8080`。不难想象存在着修改 这些默认值的需求。 因此这两个值都似乎可配置的。如果想进行定制化， 在默认的配置中修改它们的值 （比如在"jbpm.console.cfg.xml"文件中） 然后使用你希望的值去替代它们。

```xml
<jbpm-configuration>

  <process-engine-context>
    <string name="jbpm.console.server.host" value="myNewHost">
    <string name="jbpm.console.server.port" value="9191">
  </process-engine-context>

</jbpm-configuration>
```

## 9.3. Email

默认的配置可以查看 `jbpm.mail.properties` 这个classpath下的资源文件中包含了 [JavaMail 属性](http://java.sun.com/products/javamail/javadocs/)。 如果想通过服务器发送邮件，而不是本地，需要在邮件属性文件中设置 `mail.smtp.host` 属性。

```properties
mail.smtp.host=localhost
mail.smtp.port=25
mail.from=noreply@jbpm.org
```

如果SMTP需要验证，应用可以在配置文件中提供 一个自定义的验证器。

```xml
<mail-session>
  <mail-server>
    <session-properties resource="jbpm.mail.properties" />
    <authenticator class='BasicAuthenticator'>
      <field name='userName'><string value='aguizar'/></field>
      <field name='password'><string value='wontsay'/></field>
    </authenticator>
  </mail-server>
</mail-session>
```

在Java EE环境下，通常已经有一个mail会话被配置好并绑定在 JNDI中。 为了使用这个会话， 可以在配置文件中指定它的JNDI名称。

```xml
<mail-session>
  <mail-server session-jndi='java:comp/env/mail/smtp' />
</mail-session>
```

### 重要

如果当前，会话JNDI名放在会话属性和验证器的前面。 会话属性和会话jndi的结合 会构成一个错误。

参考 [开发 指南](http://docs.jboss.com/jbpm/v4/devguide/html_single/#mailsupport) 获得更多高级信息，尚未支持的，邮件设置。

------
