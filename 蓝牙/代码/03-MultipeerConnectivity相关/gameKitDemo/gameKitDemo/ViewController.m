//
//  ViewController.m
//  gameKitDemo
//
//  Created by dyf on 15/10/7.
//  Copyright © 2015年 dyf. All rights reserved.
//

#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

// 1.必须是1 - 15字符, 2.只能包含ASCII小写字母,数字和连字符
#define kMyService @"yf-XMG-MCDemo"

@interface ViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, strong) MCSession *session; /**< 会话 */

@property (nonatomic, strong) MCAdvertiserAssistant *advAss; /**< 广播 */


@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@end

@implementation ViewController

/*
 MCAdvertiserAssistant   //可以接收，并处理用户请求连接的响应。没有回调，会弹出默认的提示框，并处理连接。
 MCNearbyServiceAdvertiser //可以接收，并处理用户请求连接的响应。但是，这个类会有回调，告知有用户要与您的设备连接，然后可以自定义提示框，以及自定义连接处理。
 MCNearbyServiceBrowser  //用于搜索附近的用户，并可以对搜索到的用户发出邀请加入某个会话中。
 MCPeerID //这表明是一个用户
 MCSession //启用和管理Multipeer连接会话中的所有人之间的沟通。 通过Sesion，给别人发送数据。
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // wifi局域网/蓝牙聊天
//    MCNearbyServiceAdvertiser;
//    MCNearbyServiceBrowser;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 开始广播自己
    self.advAss = [[MCAdvertiserAssistant alloc] initWithServiceType:kMyService discoveryInfo:@{@"title": @"foundXMG"} session:self.session];
    [self.advAss start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 结束广播
    [self.advAss stop];
    self.advAss = nil;
}

- (MCSession *)session
{
    if (!_session) {
        MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
        // Session对象是最重要的，因为它代表目前的对等点（这个程序运行的设备）将创建的会话.任何数据交换和通信细节都由该对象控制。
        _session = [[MCSession alloc] initWithPeer:peerID];
        _session.delegate = self;
    }
    return _session;
}

// 建立连接
- (IBAction)buildConnect:(id)sender {
    
#warning 此处最好是用 MCNearbyServiceBrowser
    // 创建弹窗控制器
    MCBrowserViewController *bvc = [[MCBrowserViewController alloc] initWithServiceType:kMyService session:self.session];
    // 设置代理
    bvc.delegate = self;
    // 弹出
    [self presentViewController:bvc animated:YES completion:nil];
}
// 发送数据
- (IBAction)sendData:(id)sender {
    
    
    NSError *error = nil;
    
    BOOL sendState =
    [self.session sendData:[@"xmgData" dataUsingEncoding:NSUTF8StringEncoding] // 传递出的数据
                   toPeers:self.session.connectedPeers // 数组,表示想传给哪些设备
                  withMode:MCSessionSendDataReliable // 可靠的
                     error:&error]; // 错误
    if (!sendState) {
        NSLog(@"Error sending: %@", error);
    }
    
}

// 从相册中选择,记得先打开ImaView的交互
- (IBAction)chooseImaFormL:(id)sender {
    // 先判断是否有相册
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    // 创建弹出的相册vc
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    // 设置sourceType
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 设置代理
    ipc.delegate = self;
    // modal出来
    [self presentViewController:ipc animated:YES completion:nil];
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 先退出vc
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"info:%@", info);
    // 在处理info
    self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    /*
     // info dictionary keys
     UIKIT_EXTERN NSString *const UIImagePickerControllerMediaType;      // an NSString (UTI, i.e. kUTTypeImage)
     UIKIT_EXTERN NSString *const UIImagePickerControllerOriginalImage;  // a UIImage
     UIKIT_EXTERN NSString *const UIImagePickerControllerEditedImage;    // a UIImage
     UIKIT_EXTERN NSString *const UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     UIKIT_EXTERN NSString *const UIImagePickerControllerMediaURL;       // an NSURL
     */
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


#pragma mark - MCSessionDelegate
// Remote peer changed state.
// 在节点改变状态的时候被调用，已连接或已断开。有三个状态： MCSessionStateConnected , MCSessionStateConnecting  and  MCSessionStateNotConnected。最后一个状态在节点从连接断开后依然有效
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    // 此处可以发出通知or触发代理
    if (state == MCSessionStateConnected) {
        //
    }else if (state == MCSessionStateConnecting)
    {
        
    }else if (state == MCSessionStateNotConnected)
    {
        
    }
}

// Received data from remote peer.
// 在有新数据从节点过来时被调用。记住有三种数据可以交换：消息，流和资源(messages, streaming and resources)。这个是消息的代理
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

@end
