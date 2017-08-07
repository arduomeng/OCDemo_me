//
//  InputToolbar.h
//  VideoShow
//
//  Created by lance on 15/6/17.
//  Copyright (c) 2015年 energy. All rights reserved.
//

#import <UIKit/UIKit.h>

//键盘输入工具栏
@interface InputTextView : UIView

@property (nonatomic,strong) IBOutlet UITextView * textView;

-(void) addTarget:(id)target dismissAction:(SEL)action;
-(void) addTarget:(id)target confirmAction:(SEL)action;

-(void) inputDismissAction:(id)sender;
-(void)destory;



@end
