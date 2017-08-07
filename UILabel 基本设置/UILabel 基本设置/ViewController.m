//
//  ViewController.m
//  UILabel 基本设置
//
//  Created by user on 2017/6/7.
//  Copyright © 2017年 user. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *boldBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _label.text = @"hehehe呵呵呵\n呵呵呵";
    _label.clipsToBounds = NO;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onclickBold:(UIButton *)button {
    button.selected = !button.isSelected;
    [self updateBoldWithSelected:button.isSelected];
    
    [self drawImage];
}
- (IBAction)onclickXieti:(UIButton *)button {
    button.selected = !button.isSelected;
    [self updateItalicWithSelected:button.isSelected];
    
    [self drawImage];
   
}
- (IBAction)onclickShadow:(UIButton *)button {
    button.selected = !button.isSelected;
    [self updateShadowWithSelected:button.isSelected];
    
    [self drawImage];
}
- (IBAction)font1:(id)sender {
    UIFont *font = [UIFont fontWithName:@"Didot" size:_label.font.pointSize];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString setAttributedString:_label.attributedText];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _label.text.length)];
    _label.attributedText = attrString;
    
    [self drawImage];
}
- (IBAction)font2:(id)sender {
    
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"preqvh4F78m.ttf" ofType:nil];
    UIFont *font = [self customFontWithPath:fontPath size:_label.font.pointSize];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    [attrString setAttributedString:_label.attributedText];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _label.text.length)];
    _label.attributedText = attrString;
    
    [self drawImage];
}
- (IBAction)changeSlider:(UISlider *)sender {
    
    _label.alpha = sender.value;
    
    [self drawImage];
}

// 这样就不需要在plist设定任何东西，只需要得到字体库文件的路径，就可以取出对应的字体。
- (UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    if (!path) {
        return nil;
    }
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    //    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontUrl, kCTFontManagerScopeNone, nil);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    if (!fontName) {
        return nil;
    }
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

- (void)updateBoldWithSelected:(BOOL)isSelected {
    
    if (isSelected && _label && ![_label.text isEqualToString:@""]) {
        
        NSDictionary *dictionary =  [_label.attributedText attributesAtIndex:0 effectiveRange:nil];
        UIFont *baseFont = [dictionary objectForKey:NSFontAttributeName];
        
        UIFont *italicFont = GetVariationOfFontWithTrait(baseFont, kCTFontTraitBold);
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        [attrString setAttributedString:_label.attributedText];
        [attrString addAttribute:NSFontAttributeName value:italicFont range:NSMakeRange(0, _label.text.length)];
        _label.attributedText = attrString;
        
        NSLog(@"label %@", _label.text);
    }else{
        NSDictionary *dictionary =  [_label.attributedText attributesAtIndex:0 effectiveRange:nil];
        UIFont *baseFont = [dictionary objectForKey:NSFontAttributeName];
        
        UIFont *italicFont = RemoveVariationOfFontWithTrait(baseFont, kCTFontTraitBold);
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        [attrString setAttributedString:_label.attributedText];
        [attrString addAttribute:NSFontAttributeName value:italicFont range:NSMakeRange(0, _label.text.length)];
        _label.attributedText = attrString;
    }

}

- (void)updateItalicWithSelected:(BOOL)isSelected {
    
    /* 这种方式可以实现斜体效果 但是无法绘制出斜体的layer图片
    if (isSelected && _label && ![_label.text isEqualToString:@""]) {
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-20 * (CGFloat)M_PI / 180), 1, 0, 0);
        _label.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }else{
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(0 * (CGFloat)M_PI / 180), 1, 0, 0);
        _label.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    }
    */
    
    if (isSelected && _label && ![_label.text isEqualToString:@""]) {
        /*
        UIFont *italicFont = GetVariationOfFontWithTrait(_label.font, kCTFontTraitBold);
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_label.text];
        [attrString addAttribute:NSFontAttributeName value:italicFont range:NSMakeRange(0, _label.text.length)];
        _label.attributedText = attrString;
         */
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        [attrString setAttributedString:_label.attributedText];
        [attrString addAttribute:NSObliquenessAttributeName value:@0.5 range:NSMakeRange(0, _label.text.length)];
        _label.attributedText = attrString;
        
        NSLog(@"label %@", _label.text);
    }else{
        /*
        UIFont *italicFont = RemoveVariationOfFontWithTrait(_label.font, kCTFontTraitBold);
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_label.text];
        [attrString addAttribute:NSFontAttributeName value:italicFont range:NSMakeRange(0, _label.text.length)];
        _label.attributedText = attrString;
         */
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        [attrString setAttributedString:_label.attributedText];
        [attrString addAttribute:NSObliquenessAttributeName value:@0 range:NSMakeRange(0, _label.text.length)];
        _label.attributedText = attrString;
    }
    
    
    
    NSLog(@"x");
   
}
- (void)updateShadowWithSelected:(BOOL)isSelected {
    
    
    if (isSelected && _label && ![_label.text isEqualToString:@""]) {
        /*
        _label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _label.shadowOffset = CGSizeMake(3,3);
        */
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        shadow.shadowOffset = CGSizeMake(3,3);

        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        [attrString setAttributedString:_label.attributedText];
        [attrString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, _label.text.length)];
        _label.attributedText = attrString;
        
    }else{
        /*
        _label.shadowColor = [UIColor clearColor];
         */
        NSShadow *shadow = [[NSShadow alloc] init];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
        [attrString setAttributedString:_label.attributedText];
        [attrString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, _label.text.length)];
        _label.attributedText = attrString;
    }

}

// 绘制图片
- (void)drawImage{
    UIImage* tImage;
    @autoreleasepool {
        UIGraphicsBeginImageContext(_label.bounds.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [_label.layer renderInContext:ctx];
        tImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    _imageView.image = tImage;
    _imageView.contentMode = UIViewContentModeCenter;
}


// CoreText 给字体添加额外的效果
// 中文下斜体无效 使用系统之外的字体粗体无效
UIFont * GetVariationOfFontWithTrait(UIFont *baseFont,
                                     CTFontSymbolicTraits trait) {
    CGFloat fontSize = [baseFont pointSize];
    CFStringRef
    baseFontName = (__bridge CFStringRef)[baseFont fontName];
    CTFontRef baseCTFont = CTFontCreateWithName(baseFontName,
                                                fontSize, NULL);
    CTFontRef ctFont = CTFontCreateCopyWithSymbolicTraits(baseCTFont, 0.0, NULL, trait, trait);
    
    if (ctFont) {
        NSString *variantFontName = CFBridgingRelease(CTFontCopyName(ctFont, kCTFontPostScriptNameKey));
        
        UIFont *variantFont = [UIFont fontWithName:variantFontName
                                              size:fontSize];
        CFRelease(ctFont);
        CFRelease(baseCTFont);
        return variantFont;
    }else{
        
        CFRelease(baseCTFont);
        return baseFont;
    }
    
};

// CoreText 移除字体效果
UIFont * RemoveVariationOfFontWithTrait(UIFont *baseFont,
                                     CTFontSymbolicTraits trait) {
    CGFloat fontSize = [baseFont pointSize];
    CFStringRef
    baseFontName = (__bridge CFStringRef)[baseFont fontName];
    CTFontRef baseCTFont = CTFontCreateWithName(baseFontName,
                                                fontSize, NULL);
    CTFontRef ctFont =
    CTFontCreateCopyWithSymbolicTraits(baseCTFont, 0, NULL,
                                       0, trait);
    NSString *variantFontName =
    CFBridgingRelease(CTFontCopyName(ctFont,
                                     kCTFontPostScriptNameKey));
    
    UIFont *variantFont = [UIFont fontWithName:variantFontName
                                          size:fontSize];
    CFRelease(ctFont);
    CFRelease(baseCTFont);
    return variantFont;
};

- (IBAction)onClickAlignmeng:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.label.textAlignment = NSTextAlignmentLeft;
    }else{
        self.label.textAlignment = NSTextAlignmentRight;
    }
    
    CGRect bound = self.label.bounds;
    CGSize size = [self.label.text sizeWithAttributes:@{NSFontAttributeName : _label.font}];
    size.width += 30;
    bound.size = size;
    
    self.label.bounds = bound;
}

@end
