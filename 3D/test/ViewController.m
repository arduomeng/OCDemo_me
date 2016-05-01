//
//  ViewController.m
//  test
//
//  Created by 易彬 on 15/11/8.
//  Copyright © 2015年 易彬. All rights reserved.
//

#import "ViewController.h"
#define SCREEN_W [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - 懒加载
- (ViewOne *)one
{
    if (_one==nil)
    {
        
        _one = [[ViewOne alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    }
    return _one;
}

- (ViewTwo *)two
{
    if (_two==nil)
    {
        
        _two = [[ViewTwo alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    }
    return _two;
}

- (ViewThree *)three
{
    if (_three==nil)
    {
        
        _three = [[ViewThree alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    }
    return _three;
}

#pragma mark - 视图加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.beginFlag = YES;         //不弄个一次性的flag的话，第一次点击屏幕，会进行一次3D动画，暂用flag去判断，待改进
    self.nowIndex = 2;
    [self showPage:self.nowIndex];
    
    [self.view addSubview:self.one];
    [self.view addSubview:self.two];
    [self.view addSubview:self.three];

}

#pragma mark - 显示view
-(void) showPage:(NSUInteger)page
{
    NSArray *titleArr = @[@"客户中心",@"滔滔鲜度柜",@"服务网点"];
    NSString *str = titleArr[self.nowIndex-1];
    NSDictionary *dict = @{@"title":str};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"page" object:nil userInfo:dict];
    self.nowIndex=page;
    if(page == 1)
    {
        self.angle_view_1 = 0;
        self.angle_view_2 = 90;
        self.angle_view_3 = 180;
        self.title = @"客服中心";
        self.one.userInteractionEnabled = YES;
        self.two.userInteractionEnabled = NO;
        self.three.userInteractionEnabled = NO;
    }
    else if(page == 2)
    {
        self.angle_view_1 = -90;
        self.angle_view_2 = 0;
        self.angle_view_3 = 90;
        self.title = @"滔滔鲜度柜";
        self.two.userInteractionEnabled = YES;
        self.one.userInteractionEnabled = NO;
        self.three.userInteractionEnabled = NO;
        
    }else if(page==3)
    {
        self.angle_view_1 = -180;
        self.angle_view_2 = -90;
        self.angle_view_3 = 0;
        self.three.userInteractionEnabled= YES;
        self.one.userInteractionEnabled = NO;
        self.two.userInteractionEnabled = YES;
    }
    [self setFilpAngle];
}

#pragma mark - 触摸滑动事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects[0];
    self.start_touch_x = [touch locationInView:self.view].x;
    self.last_touch_x = [touch locationInView:self.view].x;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects[0];
    CGFloat x = [touch locationInView:self.view].x;
    self.angle_view_1 += (x - self.last_touch_x) / SCREEN_W * 90;
    self.angle_view_2 += (x - self.last_touch_x) / SCREEN_W * 90;
    self.angle_view_3 += (x - self.last_touch_x) / SCREEN_W * 90;
    
    if (self.angle_view_3 < 195 && self.angle_view_3 > -15)
    {
        [self setFilpAngle];
    }
    
    self.last_touch_x = x;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.allObjects[0];
    CGFloat x = [touch locationInView:self.view].x;
    if((x - self.start_touch_x) < -(SCREEN_W/2))
    {
        if(self.nowIndex != 3)
        {
            self.nowIndex++;
        }
    }
    else if(x - self.start_touch_x > (float)(self.view.frame.size.width/2))
    {
        if(self.nowIndex != 1)
        {
            self.nowIndex--;
        }
    }
    [self showPage:self.nowIndex];
    
}

#pragma mark - 3Dcube效果
- (void)setFilpAngle
{

    CATransform3D move = CATransform3DMakeTranslation(0, 0, SCREEN_W/2);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, -SCREEN_W/2);
    
    CATransform3D rotate0 = CATransform3DMakeRotation(self.angle_view_1 * M_PI / 180, 0, 1, 0);
    CATransform3D rotate1 = CATransform3DMakeRotation(self.angle_view_2 * M_PI / 180, 0, 1, 0);
    CATransform3D rotate2 = CATransform3DMakeRotation(self.angle_view_3 * M_PI / 180, 0, 1, 0);
    
    CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
    CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
    CATransform3D mat2 = CATransform3DConcat(CATransform3DConcat(move, rotate2), back);
    
    if (self.beginFlag)
    {
        self.one.layer.transform = [self Perspect:mat0 point:CGPointZero distance:500];
        self.two.layer.transform = [self Perspect:mat1 point:CGPointZero distance:500];
        self.three.layer.transform = [self Perspect:mat2 point:CGPointZero distance:500];
        self.beginFlag = NO;
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.one.layer.transform = [self Perspect:mat0 point:CGPointZero distance:500];
            self.two.layer.transform = [self Perspect:mat1 point:CGPointZero distance:500];
            self.three.layer.transform = [self Perspect:mat2 point:CGPointZero distance:500];
        }];
    }
}

- (CATransform3D)Perspect:(CATransform3D)t point:(CGPoint)center distance:(CGFloat)disz
{
    return CATransform3DConcat(t, [self makePerspective:center distance:disz]);
}

- (CATransform3D)makePerspective:(CGPoint)center distance:(CGFloat)disz
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disz;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}


@end
