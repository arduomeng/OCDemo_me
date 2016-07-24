//
//  MCManger.m
//  gameKitDemo
//
//  Created by dyf on 15/10/7.
//  Copyright © 2015年 dyf. All rights reserved.
//

#import "MCManger.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

// 1.必须是1 - 15字符, 2.只能包含ASCII小写字母,数字和连字符
#define kMyService @"yf-XMG-MCDemo"

@interface MCManger () <MCSessionDelegate, MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate>


@property (nonatomic, strong) MCPeerID *peerID; /**< 设备 */

@property (nonatomic, strong) MCSession *session; /**< 会话 */


@property (nonatomic, strong) MCBrowserViewController *browserVc; /**< 搜索弹窗 */

@property (nonatomic, strong) MCAdvertiserAssistant *advAss; /**< 广播 */


@end

@implementation MCManger

#pragma mark - 公有方法
- (void)setupPeerAndSessionWithDisplayName:(NSString *)displayName
{
    self.displayName = displayName;
    
    [self session];
}

-(void)setupMCBrowserInVC:(UIViewController *)vc
{
    [vc presentViewController:self.browserVc animated:YES completion:nil];
}

- (void)startAdvertising
{
    [self.advAss start];
}

- (void)endAdvertising
{
    [self.advAss stop];
    self.advAss = nil;
}

#pragma mark - 私有方法
// 懒加载

// PeerID 对象表示设备，它包含发现设备和建立会话阶段所需的各种属性。
- (MCPeerID *)peerID
{
    if (!_peerID) {
        _peerID = [[MCPeerID alloc] initWithDisplayName:(self.displayName) ? self.displayName: [UIDevice currentDevice].name];
    }
    return _peerID;
}
// Session对象是最重要的，因为它代表目前的对等点（这个程序将运行的设备）将创建的会话.任何数据交换和通信细节都由该对象控制。
- (MCSession *)session
{
    if (!_session) {
        _session = [[MCSession alloc] initWithPeer:self.peerID];
        _session.delegate = self;
    }
    return _session;
}
// browserVc对象实际上是代表苹果提供的用于浏览其他peers的默认UI，我们将为此目的而使用它。对于框架的浏览功能更先进的处理，苹果提供了一个可编程的替代方式，但它超出了现在本文的范围。
- (MCBrowserViewController *)browserVc
{
    if (!_browserVc) {
        
        _browserVc = [[MCBrowserViewController alloc] initWithServiceType:kMyService // 自定义,与广播的一样即可
                                                                  session:self.session];
        _browserVc.delegate = self;
    }
    return _browserVc;
}
// advAss对象，这是用来从目前的设备去宣传自己，使其容易被发现
- (MCAdvertiserAssistant *)advAss
{
    if (!_advAss) {
        _advAss = [[MCAdvertiserAssistant alloc] initWithServiceType:kMyService
                                                       discoveryInfo:nil // 别人接收到时候会获得的信息
                                                             session:self.session];
        _advAss.delegate = self;
    }
    return _advAss;
}

#pragma mark - MCSessionDelegate
// Remote peer changed state.
// 在节点改变状态的时候被调用，已连接或已断开。有三个状态： MCSessionStateConnected , MCSessionStateConnecting  and  MCSessionStateNotConnected。最后一个状态在节点从连接断开后依然有效
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    // 此处可以发出通知or触发代理
}

// Received data from remote peer.
// 在有新数据从节点过来时被调用。记住有三种数据可以交换：消息，流和资源(messages, streaming and resources)。这个是消息的代理
/*
 Messages是定义明确的信息，比如端文本或者小序列化对象。
 Streams 流是可连续传输数据（如音频，视频或实时传感器事件）的信息公开渠道。
 Resources是图片、电影以及文档的文件
*/
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    // 此处可以发出通知or触发代理
}

// Received a byte stream from remote peer.
//在收到Stream时被调用
- (void)    session:(MCSession *)session
   didReceiveStream:(NSInputStream *)stream
           withName:(NSString *)streamName
           fromPeer:(MCPeerID *)peerID
{
    
}

// Start receiving a resource from remote peer.
// 在开始收到Resource资源时被调用
- (void)                    session:(MCSession *)session
  didStartReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                       withProgress:(NSProgress *)progress
{
    // 此处开启HUD提醒正在传输
}

// 在收到Resource资源后被调用
// Finished receiving a resource from remote peer and saved the content
// in a temporary location - the app is responsible for moving the file
// to a permanent location within its sandbox.
- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error
{
    // 结束HUD,并且提示以及传输完毕
    
    // 处理接收到数据后的业务
}

// 收到certificate时调用
// Made first contact with peer and have identity information about the
// remote peer (certificate may be nil).
- (void)        session:(MCSession *)session
  didReceiveCertificate:(nullable NSArray *)certificate
               fromPeer:(MCPeerID *)peerID
     certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    
}
#pragma mark - MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button.
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}


// 此方法主要起到过滤作用
// Notifies delegate that a peer was found; discoveryInfo can be used to
// determine whether the peer should be presented to the user, and the
// delegate should return a YES if the peer should be presented; this method
// is optional, if not implemented every nearby peer will be presented to
// the user.
- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController
      shouldPresentNearbyPeer:(MCPeerID *)peerID
            withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
    
    // 此处可以发出通知
    
    return YES;
}

#pragma mark - MCAdvertiserAssistantDelegate
// An invitation will be presented to the user.
- (void)advertiserAssistantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant
{
    // 可以发通知
}

// An invitation was dismissed from screen.
- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant
{
    // 可以发通知
}

@end
