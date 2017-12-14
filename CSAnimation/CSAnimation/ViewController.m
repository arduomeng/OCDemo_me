//
//  ViewController.m
//  CSAnimation
//
//  Created by LCS on 16/3/18.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"

#define angleToRadia(angle) (angle * M_PI / 180)

@interface ViewController () <CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) CALayer *layer;

@property (nonatomic, strong) CAAnimationGroup *CAGroup;
@end

@implementation ViewController
// 核心动画都是假象，不能改变layer的真实属性的值
// 展示的位置和实际的位置不同。实际位置永远在最开始位置
/*
 CAAnimation基本属性
 duration:动画的持续时间
 repeatCount:重复次数
 removedOnCompletion:默认为YES 动画执行完毕后是否移除
 fillMode：定义动画非活动时候的行为，若需要保持最终效果则设置为kCAFillModeForwards
 beginTime：动画开始时间，CACurrentMediaTime() layer的当前时间
 timingFunction：速度控制函数，控制动画运行的节奏 默认 kCAMediaTimingFunctionEaseInEaseOut（渐进渐出）
 delegate：代理
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _layer = [[CALayer alloc] init];
    _layer.bounds = CGRectMake(0, 0, 100, 100);
    [self.view.layer addSublayer:_layer];
    
//    [self CABasic];
    [self CAGroupAnimation];
}
//基础动画
- (void)CABasic{
    CABasicAnimation *CABasic = [[CABasicAnimation alloc] init];
    /*
    CALayer的基本属性
    宽度和高度：
    @property CGRect bounds;
    位置(默认指中点，具体由anchorPoint决定)：
    @property CGPoint position;
    锚点(x,y的范围都是0-1)，决定了position的含义：
    @property CGPoint anchorPoint;
    背景颜色
    @property CGColorRef backgroundColor;
    形变属性：
    @property CATransform3D transform;
     */
//    CABasic.keyPath = @"transform.scale";
//    CABasic.toValue = @0.5;
//    CABasic.duration = 0.5;
//    //动画执行完后取消反弹
//    CABasic.removedOnCompletion = NO;
//    //动画完成后图片的状态保持最新的位置
//    CABasic.fillMode = kCAFillModeForwards;
//    [_image.layer addAnimation:CABasic forKey:nil];
    
    _image.layer.anchorPoint = CGPointMake(0.5, 1);
    CABasic.keyPath = @"transform.rotation.y";
    CABasic.toValue = @M_PI;
    CABasic.duration = 0.5;
    CABasic.beginTime = CACurrentMediaTime() + 1;
    //动画执行完后取消反弹
    CABasic.removedOnCompletion = NO;
    //动画完成后图片的状态保持最新的位置
    CABasic.fillMode = kCAFillModeForwards;
    [_image.layer addAnimation:CABasic forKey:nil];
    
//    CABasic.keyPath = @"transform.translation";
//    CABasic.toValue = @100;
//    CABasic.duration = 0.5;
//    //动画执行完后取消反弹
//    CABasic.removedOnCompletion = NO;
//    //动画完成后图片的状态保持最新的位置
//    CABasic.fillMode = kCAFillModeForwards;
//    [_image.layer addAnimation:CABasic forKey:nil];
//
//    //图层的属性还是原来的值没有改变
//    NSLog(@"image width : %f", _image.frame.size.width);
//    NSLog(@"image height : %f", _image.frame.size.height);
}
//帧动画（路径动画）
- (void)CAKeyframe{
    CAKeyframeAnimation *CAKeyframe = [[CAKeyframeAnimation alloc] init];
    CAKeyframe.keyPath = @"transform.rotation";
    CAKeyframe.values = @[@(angleToRadia(5)),@(-angleToRadia(5)),@(angleToRadia(5))];
    CAKeyframe.duration = 0.5;
    CAKeyframe.repeatCount = MAXFLOAT;
    [_image.layer addAnimation:CAKeyframe forKey:nil];
}

//动画组
- (void)CAGroupAnimation{
    _CAGroup = [[CAAnimationGroup alloc] init];
    _CAGroup.delegate = self;
    //动画执行完后取消反弹
    _CAGroup.removedOnCompletion = NO;
    //动画完成后图片的状态保持最新的位置
    _CAGroup.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *CABasic1 = [[CABasicAnimation alloc] init];
    CABasic1.keyPath = @"transform.translation.y";
    CABasic1.toValue = @300;
    //动画执行完后取消反弹
    CABasic1.removedOnCompletion = NO;
    //动画完成后图片的状态保持最新的位置
    CABasic1.fillMode = kCAFillModeForwards;
    [CABasic1 setBeginTime:0];
    [CABasic1 setDuration:1];
    
    CABasicAnimation *CABasic2 = [[CABasicAnimation alloc] init];
    CABasic2.keyPath = @"transform.rotation.y";
    CABasic2.toValue = @(2 * M_PI);
    //动画执行完后取消反弹
    CABasic2.removedOnCompletion = NO;
    //动画完成后图片的状态保持最新的位置
    CABasic2.fillMode = kCAFillModeForwards;
    [CABasic2 setBeginTime:1];
    [CABasic2 setDuration:1];
    
    _CAGroup.duration = 2;
    _CAGroup.animations = @[CABasic1, CABasic2];
    [_image.layer addAnimation:_CAGroup forKey:nil];
    
}

//转场动画
- (IBAction)CATranstion:(id)sender {
    CATransition *CATran = [CATransition animation];
    _image.image = [UIImage imageNamed:@"小新"];
    /* The name of the transition. Current legal transition types include
     * `fade', `moveIn', `push' and `reveal'. Defaults to `fade'. */
    //过度效果 'fade' 'push' 'moveIn' 'reveal' 'cube' 'oglFlip' 'suckEffect'
    //'rippleEffect' 'pageCurl' 'pageUnCurl' 'cameraIrisHollowOpen' 'cameraIrisHollowClose'
    CATran.type = @"moveIn";
    /* An optional subtype for the transition. E.g. used to specify the
     * transition direction for motion-based transitions, in which case
     * the legal values are `fromLeft', `fromRight', `fromTop' and
     * `fromBottom'. */
    //过度方向
    CATran.subtype =@"fromLeft";
    CATran.duration = 1;
    /* A convenience method for creating common timing functions. The
     * currently supported names are `linear', `easeIn', `easeOut' and
     * `easeInEaseOut' and `default' (the curve used by implicit animations
     * created by Core Animation). */
    CATran.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_image.layer addAnimation:CATran forKey:nil];
}
//隐式动画:
/*
 每一个uiview都默认关联着一个CALayer，我们成这个layer为root layer
 所有的非root layer都存在默认的隐私动画，隐式动画默认为1/4秒
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    _layer.backgroundColor = [[UIColor yellowColor] CGColor];
    _layer.position = point;
    [_layer setValue:@(arc4random_uniform(11)/10) forKey:@"transform.scale"];
    [_layer setValue:@(arc4random_uniform(M_PI * 2)) forKey:@"transform.rotation"];
    _layer.cornerRadius = arc4random_uniform(51);
}

//UIView封装动画
- (void)UIViewAnimation{
    // 弹簧效果的动画
    // SpringWithDamping:弹簧阻尼系数,越小，弹簧效果越明显
    // initialSpringVelocity:初始弹簧速度
    // options:弹簧动画效果
    _image.layer.transform = CATransform3DMakeRotation(M_PI/3, 1, 0, 0);
    [UIView animateWithDuration:1 delay:1 usingSpringWithDamping:0.1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _image.layer.transform = CATransform3DIdentity;
        
    } completion:nil];
    
    
}

#pragma mark delegate
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"Start");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"End");
}

@end
