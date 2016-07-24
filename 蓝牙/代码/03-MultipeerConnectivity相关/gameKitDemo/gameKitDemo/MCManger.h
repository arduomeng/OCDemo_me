//
//  MCManger.h
//  gameKitDemo
//
//  Created by dyf on 15/10/7.
//  Copyright © 2015年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCManger : NSObject

@property (nonatomic, copy) NSString *displayName; /**< 设备名 */

// 通过自定义设备名设置peer和session
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
// 设置搜索弹窗
-(void)setupMCBrowserInVC:(UIViewController *)vc;

// 开启本设备广播
- (void)startAdvertising;

// 结束本设备广播
- (void)endAdvertising;

@end
