## websocket
[使用纯Java实现一个WebSSH项目](https://blog.csdn.net/NoCortY/article/details/104772431)  
### 传统实时方案
1.单向   
前端要获取后端的数据，由前端主动发起，后端没办法主动给前端发消息。

2.long poll(长轮询)  
浏览器发起一个长连接，会一直等待，直到后端返回数据或超时 （DefferResult）。张三今天一定要取到快递，他就一直站在快递
点，等待快递一到，立马取走。

3.Ajax轮询  
定时的发起请求，向后端要数据。现在系统里面的预警消息的更新  

4.延迟性较大  
前端需要定时去请求，会有一个时间差  

5.服务端压力
频繁的轮询会给服务端造成很大的压力。延迟和压力无法平衡，降
低轮询的间隔，延迟降低，压力增加；增加轮询的间隔，压力降低，
延迟增高

### 什么是 WebSocket
1.双向传输  
一次握手，两者之间就直接可以创建持久性的连接，并进行双向数据传输  

2.延迟低  
允许服务端主动向客户端推送数据。不需要等待客户端发起请求才能返回  

3.数据格式  
WebSocket的数据帧一共有两种格式，TextMessage和BinaryMessage  

4.可靠性传输协议  
基于tcp的，应用层协议。初次连接是HTTP/1.1协议的101状态码进行握手  

5.轻量  
数据格式比较轻量，性能开销小，通信高效。更好的压缩效果

6.协议标识符  
协议标识符是ws，如果加密，则为wss


WebSocket是一种在单个TCP连接上进行全双工通信的协议。WebSocket通信协议于2011年被
IETF定为标准RFC 6455，并由RFC7936补充规范。WebSocket API也被W3C定为标准。
WebSocket使得客户端和服务器之间的数据交换变得更加简单，允许服务端主动向客户端推送数
据。在WebSocket API中，浏览器和服务器只需要完成一次握手，两者之间就直接可以创建持久性
的连接，并进行双向数据传输。

### WebSocket应用场景
B站实时弹幕  
看股票实时行情  
在线文档协同编辑  
系统首页待办消息  
外汇实时报价 

在WebSocket概念出来之前，如果页面要不停地显示最新的价格， 那么必须不停地刷新页面，或者用一段js代码每隔几秒钟发消息询问服务器数据。  
而使用WebSocket技术之后，当服务器有了新的数据，会主动通知浏览器。 如效果所示，当服务端有新的比特币价格之后，浏览器立马接收到消息。

优点:
1. 节约带宽。 不停地轮询服务端数据这种方式，使用的是http协议，head信息很大，有效数据占比低， 而使用WebSocket方式，头信息很小，有效数据占比高。  
2. 无浪费。 轮询方式有可能轮询10次，才碰到服务端数据更新，那么前9次都白轮询了，因为没有拿到变化的数据。 而WebSocket是由服务器主动回发，来的都是新数据。  
3. 实时性，考虑到服务器压力，使用轮询方式不可能很短的时间间隔，否则服务器压力太多，所以轮询时间间隔都比较长，好几秒，设置十几秒。 而WebSocket是由服务器主动推送过来，实时性是最高的  

```shell
@Controller
@WebSocketMapping('/api/ws/webssh')
@TypeChecked
class WebSshWsController extends TextWebSocketHandler {

    @Autowired
    WebSSHService webSSHService


    /**
     * 用户连接上WebSocket的回调
     */
    @Override
    void afterConnectionEstablished(WebSocketSession session) throws Exception {
        webSSHService.initConnection(session)
    }

    /**  session 当前WebSocket 信息
     ** TextMessage message  接受页面传入的信息
     */
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        log.info("${session.id}: ${message.getPayload()}")
        webSSHService.recvHandle((message).getPayload(), session)
    }

    /**
     * 出现错误的回调
     */
    @Override
    void handleTransportError(WebSocketSession session, Throwable throwable) throws Exception {
        log.error("数据传输错误")
    }

    /**
     * 连接关闭的回调
     */
    @Override
    void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
        //调用service关闭连接
        webSSHService.close(session)
    }

}
```

```shell
#接受 buffer信息到session ,反馈给客户端
  session.sendMessage(new TextMessage(buffer))
```







