//
//  CustomShareViewController.m
//  ShareExtension
//
//  Created by user on 2017/5/9.
//  Copyright © 2017年 user. All rights reserved.
//

#import "CustomShareViewController.h"

@interface CustomShareViewController ()

@end

@implementation CustomShareViewController

- (void)viewDidLoad{
    self.view.hidden = YES;
    
    [self didSelectPost];
}


- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost
{
    
    [self fetchItemDataAtBackground];
    
}
- (void)fetchItemDataAtBackground
{
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *movieArr = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
    //后台获取
    NSArray *inputItems = self.extensionContext.inputItems;
    NSExtensionItem *item = inputItems.firstObject;//无论多少数据，实际上只有一个 NSExtensionItem 对象
    for (int i = 0; i < item.attachments.count; i ++) {
        
        NSItemProvider *provider = item.attachments[i];
        //completionHandler 是异步运行的
        // 具体类型
        NSString *dataType = provider.registeredTypeIdentifiers.firstObject;//实际上一个NSItemProvider里也只有一种数据类型
        NSLog(@"data type: %@", dataType);
        if ([provider hasItemConformingToTypeIdentifier:@"public.image"]) {
            
            dispatch_group_enter(group);
            // 图片 由于Container App 无法读取到图库中的图片，因此无论外部还是图库统一存入沙盒
            [provider loadItemForTypeIdentifier:@"public.image" options:nil completionHandler:^(NSURL *item, NSError *error){
                
                NSData *data = [NSData dataWithContentsOfURL:item];
                // 写入data数据至文件共享区
                NSURL *fileURL = [self getFileURLWithItem:item];
                if (fileURL) {
                    [data writeToURL:fileURL atomically:YES];
                    
                    [imageArr addObject:fileURL.absoluteString];
                }
                
                
                dispatch_group_leave(group);
            }];
        }else if ([provider hasItemConformingToTypeIdentifier:@"public.movie"]){
            dispatch_group_enter(group);
            [provider loadItemForTypeIdentifier:@"public.movie" options:nil completionHandler:^(NSURL *item, NSError *error){
                
                // 来自其它应用
                if ([item.absoluteString hasPrefix:@"file:///private"]) {
                    
                    
                    NSURL *fileURL = [self getFileURLWithItem:item];
                    if (fileURL) {
                        // 写入data数据至文件共享区,用data的方式当视频较大时会内存溢出，程序崩溃
                        // NSData *data = [NSData dataWithContentsOfURL:item];
                        // [data writeToURL:fileURL atomically:YES];
                        NSError *error = nil;
                        [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
                        [[NSFileManager defaultManager] copyItemAtURL:item toURL:fileURL error:&error];
                        
                        if (!error) {
                            [movieArr addObject:fileURL.absoluteString];
                        }
                    }
                    
                }
                // 来自图库
                else{
                    
                    [movieArr addObject:item.absoluteString];
                }
                
                dispatch_group_leave(group);
            }];
        }else
            NSLog(@"don't support data type: %@", dataType);
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.videoshow"];
        [userDefaults setValue:imageArr forKey:@"imageArr"];
        [userDefaults setValue:movieArr forKey:@"movieArr"];
        
        [self openVideoShowAPP];
        [self.extensionContext completeRequestReturningItems:inputItems completionHandler:^(BOOL expired) {
            
        }];
        
    });
    
}

// 获取共享文件路径
- (NSURL *)getFileURLWithItem:(NSURL *)item{
    
    NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.videoshow"];
    NSString *fileName = nil;
    NSRange range = [item.absoluteString rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        
        fileName = [item.absoluteString substringFromIndex:range.location + range.length];
        NSURL *fileURL = [groupURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
        
        return fileURL;
    }else{
        return nil;
    }
}

- (void)openVideoShowAPP{
    
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]) != nil) {
        if ([responder respondsToSelector:@selector(openURL:)]) {
            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"videoshow://"]];
        }
    }
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}


@end
