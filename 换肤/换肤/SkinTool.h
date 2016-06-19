//
//  SkinTool.h
//  换肤
//
//  Created by xiaomage on 15/8/19.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkinTool : NSObject

+ (void)setSKinColor:(NSString *)skinColor;

+ (UIImage *)skinToolWithImageName:(NSString *)imageName;

+ (UIColor *)skinToolWithLabelColor;

@end
