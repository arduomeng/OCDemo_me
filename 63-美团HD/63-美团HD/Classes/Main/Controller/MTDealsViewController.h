//
//  MTDealsViewController.h
//  美团HD
//
//  Created by apple on 14/11/26.
//  Copyright (c) 2014年 heima. All rights reserved.
//  团购列表控制器(父类)

#import <UIKit/UIKit.h>

@interface MTDealsViewController : UICollectionViewController
/**
 *  设置请求参数:交给子类去实现
 */

/*
    面向对象的思路，相同的功能模块抽取成夫类。不同的模块，夫类提供方法，由子类去实现。夫类负责调用该方法
 */

- (void)setupParams:(NSMutableDictionary *)params;
@end
