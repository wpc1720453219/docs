# logstash
推荐使用性能更好的[filebeat](./filebeat_install.md)

1. [filebeat如何提取日志时间覆盖timestamp，使用grok非结构化日志转结构化](https://elasticsearch.cn/question/3202)
1. [国内可用grok试验地址](http://grok.51vagaa.com/)
1. [使用教程](https://www.cnblogs.com/rongfengliang/p/12198738.html)

## Logstash安装

### 3.1.    下载安装

下载、解压安装包：

下载地址：<https://www.elastic.co/downloads/logstash>

​       Windows下载[ZIP](https://artifacts.elastic.co/downloads/logstash/logstash-6.3.0.zip)包

​       Linux下载[TAR.GZ](https://artifacts.elastic.co/downloads/logstash/logstash-6.3.0.tar.gz)包

这个页面下点击[past releases](https://www.elastic.co/downloads/past-releases)可下载历史版本（该页面只提供最新版）。

【注意】ELK，即Elasticsearch、Logstash、Kibana三个软件的**版本必须一致**！

### 3.2.    配置

在logstash的bin目录下，新建一个文件，不妨命名为：logstash-gardpay.conf

文件内容：

```ruby
input {
  tcp {
    host => "10.60.45.174" 
    port => 9252
    mode => "server"
    type => "gardpay-test"
    codec => json_lines
 }
 tcp {
    host => "10.60.45.174"
    port => 9255
    mode => "server"
    type => "gardpay-dev"
    codec => json_lines
  }
}
output {
  elasticsearch { 
    action => "index"
    hosts => "10.60.45.174:9200" 
    index  => "%{type}-log-%{+yyyy.MM.dd}" 
  }
}
```

配置项说明：

- `input`：tcp 配置为绑定本机的`port`端口，作为一个日志服务器；
  - `host`：填本机ip地址；
  - `type`：可为这个log服务打个标签，区分不同的环境，比如：开发环境`gardpay-dev`，测试环境`gardpay-test`；

- `output` – elasticsearch是把logstash日志输出到elasticsearch，

- `hosts`：填elasticsearch的`ip:端口`，如：`10.60.44.248:9200`

- `index`：填在elasticsearch建立的索引名，如`gardpaylog`

其他按模板写即可。

### 3.3.    运行

Windowns/Linux下，cd到`logstash`安装目录下，运行命令：

#### 测试配置文件是否正确

由于配置文件是`Ruby`语言格式，可能发生语法错误：

Windows下：

```powershell
bin\logstash -t -f config\rh2-logstash.conf
```

Linux下：

```bash
bin/logstash -t -f config/rh2-logstash.conf
```

#### 运行服务：

Windows下：

```powershell
bin\logstash -f config\rh2-logstash.conf
```

Linux下：

```bash
bin/logstash -f config/rh2-logstash.conf
```

Linux后台运行： 

```bash
setsid bin/logstash -f config/rh2-logstash.conf
```

### 3.4.    验证

logstash并不容易验证，等ELK搭好后，运行程序，做一个整体上的验证即可。


## 脱敏
### filter mutate插件，gsub的使用
1. [求助］日志脱敏：filebeat>logstash>es>kibana](https://elasticsearch.cn/question/2057)
1. [plugins-filters-mutate-gsub](https://www.elastic.co/guide/en/logstash/6.4/plugins-filters-mutate.html#plugins-filters-mutate-gsub)

```ruby
input {
  beats {
    port => 5044
  }
}
filter {
  mutate {
    gsub => [
      # 列表形式，3个一组，分别是 字段名，匹配正则，替换值；不支持替换值取正则匹配结果

      # 测试一个字段匹配多次
      "message", "(?<=handleUsingGET_)\d+", "***",
      "message", "(?<=handleUsingDELETE_)\d+", "****"
      
      # 测试结果包含匹配值，未达预期，测试结果直接是$1
      # "message", "operation named: ([a-zA-Z_]+)\d+", "$1***"
    ]
  }
}
output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}" 
  }
}
```
### 直接ruby脚本实现高度自定义
1. [logstash实现敏感信息脱敏及超长字符截取](https://blog.csdn.net/wangchengaihuiming/article/details/89914587)
1. [plugins-filters-ruby](https://www.elastic.co/guide/en/logstash/6.4/plugins-filters-ruby.html)
1. [ruby正则表达式替换语法](https://www.cnblogs.com/qinyan20/p/3759812.html)

配置
```ruby
# logstash -f filebeat-logstash-ruby-conf.rb
# logstash -t -f filebeat-logstash-ruby-conf.rb
input {
  beats {
    port => 5044
  }
}
filter {
  ruby {
    path => "E:/elk/logstash-6.4.2/bin/filebeat-logstash-ruby.rb"
    script_params => { "message" => message }
  }
}
output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}" 
  }
}
```

脚本，诡异的ruby正则匹配替换语法
```ruby
# the value of `params` is the value of the hash passed to `script_params`
# in the logstash configuration
def register(params)
	# @message = params["message"]
end

# the filter method receives an event and must return a list of events.
# Dropping an event means not including it in the return array,
# while creating new ones only requires you to add a new instance of
# LogStash::Event to the returned array
def filter(event)
  # puts event.inspect
  msg = event.get("message")
  # gsub 不支持这种语法
  # msg.gsub!(/operation named: ([a-zA-Z_]+)\d+/, "$1***")

  if (msg =~ /operation named: ([a-zA-Z_]+)\d+/)
    msg.gsub!(/operation named: ([a-zA-Z_]+)\d+/,"operation named: "+$1+"***")
    puts "msg: "+msg
  end
  return [event]
end
```

### grok 

对应的filebeat配置：
```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - "D:/fingard/project/ats/BankLogs/202005/20/10/BOC01/**/*.txt"
    fields:
      appname: dsp
    fields_under_root: true
    multiline.pattern: '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \d{3}'
    multiline.negate: true
    multiline.match: after
```
提取dsp时间示例
```ruby
filter {
  if [appname] == "dsp" {
    grok {
      pattern_definitions => {
        "dsp_time" => "^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \d{3}"
      }
      match => ["message", "%{dsp_time:dsp_time}"]
    }
    date {
        match => ["dsp_time", "yyyy-MM-dd HH:mm:ss SSS"]
        target => "@timestamp"
    }
  }
  
}
```

dsp日志示例：
```log
系统版本号:@PRO_VERSION@_@SVN_VERSION@
2020-05-20 10:11:17 510 9 0.开始接收，来源IP：127.0.0.1
2020-05-20 10:11:17 510 1.接收ATS的报文：
<ATSYH version="5.1.0.0"><TransReq><Tenant>10001</Tenant><BankCode>BOC01</BankCode><TransTime>2020-05-20 10:11:17</TransTime><TransType>1988</TransType><SystemCode></SystemCode><CommandCode>198801</CommandCode><TransSeqID>1011177537</TransSeqID><TotalNum>2</TotalNum><TotalAmt>11234.00</TotalAmt><TransParam><ReqSeqID>RN00000D4B</ReqSeqID><PaySpd>0</PaySpd><PsselNum>PH00000BL2</PsselNum><PayAct>513157951264</PayAct><PayArea>44433</PayArea><PayAreaName>中国银行江苏省分行</PayAreaName><PaySwiftCode>BKCHCNBJXXX</PaySwiftCode><SubmitId></SubmitId><DetailRecord><PayName>扬中市公共资源交易中心</PayName><PayAct>513157951264</PayAct><PayBnk>中国银行股份有限公司连云港分行</PayBnk><PayArea>中国银行江苏省分行</PayArea><RecBankName>中国银行</RecBankName><RecBankCode>104</RecBankCode><CostMode></CostMode><RecName>susan</RecName><RecAct>6217856100000000502</RecAct><RecBnk>中国银行股份有限公司江苏省分行</RecBnk><RecArea>44433</RecArea><RecAreaName>中国银行江苏省分行</RecAreaName><RecStandardArea>江苏省_南京市</RecStandardArea><SameCity>0</SameCity><SameBnk>1</SameBnk><PayDate>2020-05-20</PayDate><PayTime>10:11:17</PayTime><PayAmount>11111.00</PayAmount><PaySpd>0</PaySpd><IsPrivate>1</IsPrivate><PayCur>1</PayCur><RecCur>1</RecCur><CertType></CertType><CertNum></CertNum><CreditCardSecCode></CreditCardSecCode><CreditCardValidity></CreditCardValidity><Usage></Usage><PostScript>0000099G</PostScript><Memo></Memo><ReqReserve>CC0000099F</ReqReserve><CNAPSCode>104301003011</CNAPSCode><CNAPSName>中国银行股份有限公司江苏省分行</CNAPSName><InnerAct></InnerAct><InnerName></InnerName></DetailRecord><DetailRecord><PayName>扬中市公共资源交易中心</PayName><PayAct>513157951264</PayAct><PayBnk>中国银行股份有限公司连云港分行</PayBnk><PayArea>中国银行江苏省分行</PayArea><RecBankName>中国银行</RecBankName><RecBankCode>104</RecBankCode><CostMode></CostMode><RecName>susan</RecName><RecAct>4563511000640659384</RecAct><RecBnk>中国银行股份有限公司山东省分行</RecBnk><RecArea>43810</RecArea><RecAreaName>中国银行山东省分行</RecAreaName><RecStandardArea>山东省_济南市</RecStandardArea><SameCity>0</SameCity><SameBnk>1</SameBnk><PayDate>2020-05-20</PayDate><PayTime>10:11:17</PayTime><PayAmount>123.00</PayAmount><PaySpd>0</PaySpd><IsPrivate>1</IsPrivate><PayCur>1</PayCur><RecCur>1</RecCur><CertType></CertType><CertNum></CertNum><CreditCardSecCode></CreditCardSecCode><CreditCardValidity></CreditCardValidity><Usage></Usage><PostScript>0000099H</PostScript><Memo></Memo><ReqReserve>CC0000099F</ReqReserve><CNAPSCode>104451038006</CNAPSCode><CNAPSName>中国银行股份有限公司山东省分行</CNAPSName><InnerAct></InnerAct><InnerName></InnerName></DetailRecord></TransParam></TransReq></ATSYH>

2020-05-20 10:11:17 510 当前未登录前置，现在进行登录
2020-05-20 10:11:17 510 2.提交银行的地址：http://127.0.0.1:8098/B2EC/E2BServlet
2020-05-20 10:11:17 510 2.发送银行的报文：
<?xml version="1.0" encoding="GBK"?>
<bocb2e version="100" security="true" lang="chs">
  <head>
    <termid>E192168005174</termid>
    <trnid>101117000012</trnid>
    <custid>133828095</custid>
    <cusopr>136139486</cusopr>
    <trncod>b2e0001</trncod>
    <token />
  </head>
  <trans>
    <trn-b2e0001-rq>
      <b2e0001-rq>
        <custdt>20200520101117</custdt>
        <oprpwd>4GznNNnK</oprpwd>
      </b2e0001-rq>
    </trn-b2e0001-rq>
  </trans>
</bocb2e>

2020-05-20 10:11:18 541 3.银行返回的报文：
连接http://127.0.0.1:8098/B2EC/E2BServlet异常：java.net.ConnectException: Connection refused: connect

2020-05-20 10:11:18 541 登录失败：连接http://127.0.0.1:8098/B2EC/E2BServlet异常：java.net.ConnectException: Connection refused: connect
2020-05-20 10:11:18 550 2.提交银行的地址：http://127.0.0.1:8098/B2EC/E2BServlet
2020-05-20 10:11:18 550 2.发送银行的报文：
<?xml version="1.0" encoding="GBK"?>
<bocb2e version="100" security="true" lang="chs" locale="zh_CN" >
  <head>
    <termid>E192168005174</termid>
    <trnid>101117000011</trnid>
    <custid>133828095</custid>
    <cusopr>136139486</cusopr>
    <trncod>b2e0078</trncod>
    <token />
  </head>
  <trans>
    <trn-b2e0078-rq>
      <ceitinfo></ceitinfo>
      <transtype></transtype>
      <b2e0078-rq>
        <insid>RN00000D4B</insid>
        <fractn>
          <fribkn>44433</fribkn>
          <actacn>513157951264</actacn>
          <actnam>扬中市公共资源交易中心</actnam>
        </fractn>
        <pybcur>CNY</pybcur>
        <pybamt>11234.00</pybamt>
        <pybnum>2</pybnum>
        <crdtyp>7</crdtyp>
        <furinfo>G8</furinfo>
        <useinf>CC0000099F</useinf>
        <trfdate>20200520</trfdate>
        <detail>
          <toibkn>32</toibkn>
          <tobank>中国银行股份有限公司江苏省分行</tobank>
          <toactn>6217856100000000502</toactn>
          <pydcur>CNY</pydcur>
          <pydamt>11111.00</pydamt>
          <toname>susan</toname>
          <toidtp></toidtp>
          <toidet></toidet>
          <furinfo>0000099G</furinfo>
          <purpose></purpose>
          <reserve1></reserve1>
          <reserve2></reserve2>
          <reserve3></reserve3>
          <reserve4></reserve4>
        </detail>
        <detail>
          <toibkn>37</toibkn>
          <tobank>中国银行股份有限公司山东省分行</tobank>
          <toactn>4563511000640659384</toactn>
          <pydcur>CNY</pydcur>
          <pydamt>123.00</pydamt>
          <toname>susan</toname>
          <toidtp></toidtp>
          <toidet></toidet>
          <furinfo>0000099H</furinfo>
          <purpose></purpose>
          <reserve1></reserve1>
          <reserve2></reserve2>
          <reserve3></reserve3>
          <reserve4></reserve4>
        </detail>
      </b2e0078-rq>
    </trn-b2e0078-rq>
  </trans>
</bocb2e>

2020-05-20 10:11:19 561 3.银行返回的报文：
连接http://127.0.0.1:8098/B2EC/E2BServlet异常：java.net.ConnectException: Connection refused: connect

2020-05-20 10:11:19 561 4.返回ATS的报文：
<ATSYH>
  <TransResp>
    <BankCode>BOC01</BankCode>
    <TransType>1988</TransType>
    <TransSeqID>1011177537</TransSeqID>
    <TransParam>
      <DetailRecord>
        <NewReqSeqID />
        <RespCode>0</RespCode>
        <RespInfo>连接http://127.0.0.1:8098/B2EC/E2BServlet异常：java.net.ConnectException: Connection refused: connect</RespInfo>
        <TransState>BatchFailed</TransState>
        <ReqSeqID>RN00000D4B</ReqSeqID>
        <PayInfoCode>E9999</PayInfoCode>
      </DetailRecord>
    </TransParam>
  </TransResp>
</ATSYH>

```
