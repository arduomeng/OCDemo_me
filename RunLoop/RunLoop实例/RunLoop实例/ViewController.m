//
//  ViewController.m
//  RunLoop实例
//
//  Created by Apple on 16/4/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //RunLoop实例一
    //[self userImageView];
    
    //RunLoop实例二:常驻线程
    //[self permanentThread];
    
    //RunLoop实例三:子线程定时器
    //[self TimerThread];
    
    //自动释放池
}

//RunLoop实例一
- (void)userImageView{
    //只有在NSDefaultRunLoopMode模式下，3秒之后才会执行setImage
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"pic"] afterDelay:3.0 inModes:@[NSDefaultRunLoopMode]];
}

//RunLoop实例二:常驻线程
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self performSelector:@selector(excute) onThread:_thread withObject:nil waitUntilDone:NO];
}

- (void)permanentThread{
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(permanent) object:nil];
    [_thread start];
}

- (void)permanent{
    
    //必须给RunLoop添加一种事件源 Port， Timer， Observer 才能使RunLoop始终运行
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    //启动RunLoop     [NSRunLoop currentRunLoop] 若线程没有RunLoop则自动创建
    [[NSRunLoop currentRunLoop] run];
}

- (void)excute{
    NSLog(@"====excute==== %@", [NSThread currentThread]);
}

//RunLoop实例三:子线程定时器

- (void)TimerThread{
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(Timer) object:nil];
    [_thread start];
}

- (void)Timer{
    //加autorelease目的：创建一个自动释放池去管理RunLoop。RunLoop内部会在进入的时候创建释放池，在休眠之前释放释放池 例如
    /*
     int main(int argc, char * argv[]) {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
     }
     */
    @autoreleasepool {
        //创建定时器并添加到当前线程的RunLoop 模式为Default
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(excute) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

@end
