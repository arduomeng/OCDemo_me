//
//  ViewController.m
//  UMengDemo
//
//  Created by LCS on 15/12/30.
//  Copyright (c) 2015年 LCS. All rights reserved.
//

#import "ViewController.h"
#import <UMSocial.h>

#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>
@interface ViewController () <UMSocialUIDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UMSocialData openLog:YES];
}

- (IBAction)WeChatSession:(id)sender {
    
    //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
    UIImage *image = [UIImage imageNamed:@"bg_detail_info"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"分享内嵌文字" image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}


- (IBAction)WeChatTimeLine:(id)sender {
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信好友title";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"分享内嵌文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
- (IBAction)QQ:(id)sender {
    UIImage *image = [UIImage imageNamed:@"bg_detail_info"];
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialData defaultData].extConfig.qqData.title = @"QQ分享";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"content" image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}
- (IBAction)Sina:(id)sender {
    
}
- (IBAction)message:(id)sender {
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示"message:@"设备不支持短信功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *smsBody = @"http://baidu.com";
    picker.body=smsBody;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma  mark  MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
