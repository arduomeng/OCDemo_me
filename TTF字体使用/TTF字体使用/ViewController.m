//
//  ViewController.m
//  TTF字体使用
//
//  Created by arduomeng on 17/1/21.
//  Copyright © 2017年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CTFontManager.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 方式一
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }
    _labelOne.font = [UIFont fontWithName:@"AaPangXiaoer-Regular" size:14];
    _labelTwo.font = [self customFontWithPath:[[NSBundle mainBundle] pathForResource:@"prePhzHm371" ofType:@"ttf"] size:14];
    _labelTwo.font = [self customFontWithPath:[[NSBundle mainBundle] pathForResource:@"preMvnCG4Fy" ofType:@"ttf"] size:14];
    _labelTwo.font = [self customFontWithPath:[[NSBundle mainBundle] pathForResource:@"pre6cD4jaqA" ofType:@"ttf"] size:14];
    _labelTwo.font = [self customFontWithPath:[[NSBundle mainBundle] pathForResource:@"pre8wyhI71M" ofType:@"ttf"] size:14];
    _labelTwo.font = [self customFontWithPath:[[NSBundle mainBundle] pathForResource:@"prejUhdYnze" ofType:@"ttf"] size:14];
    _labelTwo.font = [self customFontWithPath:[[NSBundle mainBundle] pathForResource:@"preisxc8fzb" ofType:@"ttf"] size:14];
}

// 这样就不需要在plist设定任何东西，只需要得到字体库文件的路径，就可以取出对应的字体。
-(UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
//    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontUrl, kCTFontManagerScopeNone, nil);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
