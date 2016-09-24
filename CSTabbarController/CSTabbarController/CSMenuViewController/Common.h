//
//  Common.h
//  喵播
//
//  Created by LCS on 16/7/31.
//  Copyright © 2016年 LCS. All rights reserved.
//

#ifndef Common_h
#define Common_h

//  字体宏
#define FONTSYS(size) ([UIFont systemFontOfSize:(size)])
#define FONTBOLDSYS(size) ([UIFont boldSystemFontOfSize:(size)])

//  颜色宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//#define WT_RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)
//#define WT_RGBColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXSTRCOLOR(hex) [UIColor colorWithHexString:hex]

//  图片宏
#define IMAGE(name) [UIImage imageNamed:(name)]

//  获取沙箱文件
#define GetFileInDocuments(file) [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",file]]

//  获取沙箱路径
#define GetDocumentsDirectory [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppData"]

// 屏幕宽高
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width


#endif /* Common_h */
