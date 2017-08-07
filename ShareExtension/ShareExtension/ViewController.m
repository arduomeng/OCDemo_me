//
//  ViewController.m
//  ShareExtension
//
//  Created by user on 2017/4/27.
//  Copyright © 2017年 user. All rights reserved.
//



/*
 
 
 该方式将APP加入到系统分享控制器中，例如拷贝至"乐秀" 不适用于手机自带的“照片”等app
 http://www.jianshu.com/p/cd134bcdbe3a
 info.plist 中加入下面代码
 <key>CFBundleDocumentTypes</key>
 <array>
 <dict>
 <key>LSItemContentTypes</key>
 <array>
 <string>public.item</string>
 <string>public.content</string>
 </array>
 </dict>
 </array>
 这样很简单的就配置完了
 我来解释下每个字段的意思
 CFBundleDocumentTypes：指的是当前app可以接收文档的类型，比如图片啊、文档啊什么的
 LSItemContentTypes：指的是具体的可以接收的类型，比如txt、jpg、doc什么的，这个key对应的是一个Array，Array中放的是支持类型的字段。
 
 
 shareExtension 可以实现系统自带应用的分享 例如图库 safari 的分享
 
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}




@end
