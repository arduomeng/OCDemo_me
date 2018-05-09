//
//  ViewController.m
//  Runtime字体适配
//
//  Created by user on 2018/5/8.
//  Copyright © 2018年 user. All rights reserved.
//

/*
 方法一：用宏定义适配字体大小（根据屏幕尺寸判断）
 
 //宏定义
 #define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
 #define FONT_SIZE(size) ([UIFont systemFontOfSize:FontSize(size))
 
static inline CGFloat FontSize(CGFloat fontSize){
    if (SCREEN_WIDTH==320) {
        return fontSize-2;
    }else if (SCREEN_WIDTH==375){
        return fontSize;
    }else{
        return fontSize+2;
    }
}
方法二：用宏定义适配字体大小（根据屏幕尺寸判断）

1.5代表6P尺寸的时候字体为1.5倍，5S和6尺寸时大小一样，也可根据需求自定义比例。
代码如下:

#define IsIphone6P          SCREEN_WIDTH==414
#define SizeScale           (IsIphone6P ? 1.5 : 1)
#define kFontSize(value)    value*SizeScale
#define kFont(value)        [UIFont systemFontOfSize:value*SizeScale]
 
 
方法三：(利用runTime给UIFont写分类 替换系统自带的方法)推荐使用这种
 */

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _label.font = [UIFont systemFontOfSize:20];
    
    NSLog(@"%@", _label.font);
}



@end
