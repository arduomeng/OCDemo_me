# MultipeerConnectivity
- 在iOS7中，引入了一个全新的框架——Multipeer Connectivity（多点连接）。

- 利用Multipeer Connectivity框架，即使在`没有连接到WiFi（WLAN）或移动网络（xG）`的情况下，距离较近的Apple设备（iMac/iPad/iPhone）之间可基于`蓝牙和WiFi（P2P WiFi）`技术进行发现和连接实现近场通信。

- Multipeer Connectivity扩充的功能与利用AirDrop传输文件非常类似，可以将其看作AirDrop不能直接使用的补偿，代价是需要自己实现。
- 手机不联网也能跟附近的人聊得火热的`FireChat`和`See You Around`等近场聊天App、近距离无网遥控交互拍照神器`拍咯App`就是基于Multipeer Connectivity框架实现。

- 相比AirDrop，Multipeer Connectivity在进行发现和会话时并不要求同时打开WiFi和蓝牙，也不像AirDrop那样强制打开这两个开关，而是根据条件适时选择使用蓝牙或（和）WiFi。
- 粗略测试情况如下：
    * 双方WiFi和蓝牙`都未打开`：无法发现。
    * 双方都开启`蓝牙`：通过蓝牙发现和传输。
    * 双方都开启`WiFi`：通过WiFi Direct发现和传输，速度接近AirDrop（Reliable速率稍低），不知道同一WLAN下是否优先走局域网？

    * 双方都`同时开启了WiFi和蓝牙`：应该是模拟AirDrop，通过低功耗蓝牙技术扫描发现握手，然后通过WiFi Direct传输。

#### 常用类

- MCPeerID

类似sockaddr，用于标识连接的两端endpoint，通常是`昵称或设备名称`。

该对象只开放了displayName属性，私有MCPeerIDInternal对象持有的设备相关的_idString/_pid64字段并`未公开`。
在许多情况下，客户端同时广播并发现同一个服务，这将导致一些混乱，尤其是在`client/server`模式中。所以，每一个服务都应有一个类型标示符——`serviceType，它是由ASCII字母、数字和“-”组成的短文本串，最多15个字符`。


- MCNearbyServiceAdvertiser

类似broadcaster,`可以接收，并处理用户请求连接的响应。但是，这个类会有回调，告知有用户要与您的设备连接，然后可以自定义提示框，以及自定义连接处理`。

主线程（com.apple.main-thread(serial)）创建MCNearbyServiceAdvertiser并启动startAdvertisingPeer。
MCNearbyServiceAdvertiserDelegate异步回调（didReceiveInvitationFromPeer）切换回主线程。
在主线程didReceiveInvitationFromPeer中创建MCSession并invitationHandler(YES, session)接受会话连接请求（accept参数为YES）。

- MCNearbyServiceBrowser

类似servo listen+client connect,`用于搜索附近的用户，并可以对搜索到的用户发出邀请加入某个会话中`。
主线程（com.apple.main-thread(serial)）创建MCNearbyServiceBrowser并启动startBrowsingForPeers。
MCNearbyServiceBrowserDelegate异步回调（foundPeer/lostPeer）切换回主线程。
主线程创建MCSession并启动invitePeer。

- MCSession

`启用和管理Multipeer连接会话中的所有人之间的沟通。 通过Sesion，给别人发送数据`
注意，peerID并不具备设备识别属性。
类似TCP链接中的socket。创建MCSession时，需指定自身MCPeerID，类似bind。
为避免频繁的会话数据通知阻塞主线程，MCSessionDelegate异步回调（didChangeState/didReceiveCertificate/didReceiveData/didReceiveStream）有一个专门的回调线程——com.apple.MCSession.callbackQueue(serial)。为避免阻塞MCSeesion回调线程，最好新建数据读（写）线程！

- MCAdvertiserAssistant/MCBrowserViewController

`MCAdvertiserAssistant   //可以接收，并处理用户请求连接的响应。没有回调，会弹出默认的提示框，并处理连接。`
`MCBrowserViewController 弹出搜索框,需要手动modal`

MCAdvertiserAssistant为针对Advertiser封装的管理助手；MCBrowserViewController继承自UIViewController，提供了基本的UI应用框架。
MCBrowser/MCAdvertiser的回调线程一般是delegate所在线程Queue：com.apple.main-thread(serial)。
