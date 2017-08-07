//
//  InputToolbar.m
//  VideoShow
//
//  Created by lance on 15/6/17.
//  Copyright (c) 2015年 energy. All rights reserved.
//

#import "InputTextView.h"
#import "CSUtil.h"
#import "UIView+Extensions.h"


@interface InputTextView() <UITextViewDelegate>{
    NSInteger _textLine;
    CGSize _textLineHeightSize;
    float _originalHeight;
}

@property (nonatomic,strong) IBOutlet UIButton * btDismiss;
@property (nonatomic,strong) IBOutlet UIButton * btOk;

@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,weak) id actionTarget;
@property (nonatomic,assign) SEL dismissSelector;
@property (nonatomic,assign) SEL confirmSelector;

@property (nonatomic,assign) BOOL isFirstLayout;
@end

@implementation InputTextView

@synthesize btDismiss;
@synthesize btOk;
@synthesize textView;

@synthesize actionTarget;
@synthesize dismissSelector;
@synthesize confirmSelector;

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [btDismiss addTarget:self action:@selector(inputDismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [btOk addTarget:self action:@selector(inputConfirmAction:) forControlEvents:UIControlEventTouchUpInside];

    textView.delegate = self;
    textView.tintColor=[CSUtil colorWithHexString:@"#fc5730"];
    
    _textLineHeightSize = [@"VideoShow" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size;
    
    
    _isFirstLayout = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_isFirstLayout) {
        _isFirstLayout = NO;
        _originalHeight = self.height;
    }
}

//    此方法不适用于计算textView的文字size 因为textview存在边距计算不准确
//    CGSize textSize = [mainTextView.text boundingRectWithSize:CGSizeMake(mainTextView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size;
- (void)textViewDidChange:(UITextView *)mainTextView {
    
    
    // 获取指定宽度width的字符串在UITextView上的高度
    CGSize textSize = [mainTextView sizeThatFits:CGSizeMake(mainTextView.width, MAXFLOAT)];

    int line = textSize.height / _textLineHeightSize.height;
    line = line > 1 ? line : 1;
    CGFloat height;
    if (line >= 3) {
        height = _originalHeight + 1.2 * _textLineHeightSize.height;
    }else{
        height = _originalHeight + (line - 1) * _textLineHeightSize.height;
    }

    [UIView animateWithDuration:0.25f animations:^{
        self.y -= height - self.height;
        self.height = height;
        
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [mainTextView scrollRangeToVisible:mainTextView.selectedRange];
    }];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
#if 0
    // 不让输入表情
    if ([textField isFirstResponder]) {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            NSLog(@"输入的是表情，返回NO");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告！" message:@"不能输入表情" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alertView show];
            return NO;
        }
    }
    
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        NSString *filteredEmojiStr = [self disable_emoji:textField.text];
        //        if (filteredEmojiStr && [filteredEmojiStr isKindOfClass:[NSString class]] && [filteredEmojiStr isEqualToString:@""]) {
        //
        //        } else {
        //            textView.text = filteredEmojiStr;
        //            [textView resignFirstResponder];
        //            [self inputConfirmAction:nil];
        //        }
        textField.text = filteredEmojiStr;
        [textField resignFirstResponder];
        [self inputConfirmAction:nil];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
#endif
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textField resignFirstResponder];
        [self inputConfirmAction:nil];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
#if 0
    if (self.selectedIndex == 1) {
        NSString *filteredEmojiStr = [self disable_emoji:textField.text];
        if (filteredEmojiStr && [filteredEmojiStr isKindOfClass:[NSString class]] && [filteredEmojiStr isEqualToString:@""]) {
            return NO;
        }
    } else if (self.selectedIndex == 0) {
        return YES;
    }
#endif
    return YES;
}

#if 0
- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [self disable_emoji:textField.text];
}
#endif



//判断NSString字符串是否包含emoji表情
- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue =NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    returnValue =YES;
                }
            }else {
                // non surrogate
                if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue =YES;
                }else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue =YES;
                }else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue =YES;
                }else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue =YES;
                }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue =YES;
                }
            }
        }
    }];
    return returnValue;
}

#pragma Mark   ---  过滤表情
//- (NSString *)disable_emoji:(NSString *)text {
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
//                                                               options:0
//                                                                 range:NSMakeRange(0, [text length])
//                                                          withTemplate:@""];
//    return modifiedString;
//}

-(void) inputDismissAction:(id)sender
{
    self.selectedIndex = 0;
//    subtitleText.text = nil;
    [textView resignFirstResponder];
    [self.actionTarget performSelector:self.dismissSelector withObject:nil];
}

-(void) inputConfirmAction:(id)sender
{
    self.selectedIndex = 1;
    //subtitleText.text = [self disable_emoji:subtitleText.text];
    [self.actionTarget performSelector:self.confirmSelector withObject:nil];
}

-(void) addTarget:(id)target dismissAction:(SEL)action
{
    self.actionTarget=target;
    self.dismissSelector=action;
}

-(void) addTarget:(id)target confirmAction:(SEL)action
{
    self.actionTarget=target;
    self.confirmSelector=action;
}

- (void)destory {
    self.selectedIndex = -1;
    [self.textView resignFirstResponder];
    [self removeFromSuperview];
}

@end
