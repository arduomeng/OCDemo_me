//
//  ViewController.m
//  NSOperation的使用
//
//  Created by LCS on 16/4/9.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "CSOperation.h"
@interface ViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建队列
    _queue = [[NSOperationQueue alloc] init];
    
    //设置最大并发数,设置为1，则该队列就是串行队列
    _queue.maxConcurrentOperationCount = 3;
    
    [self addDependency];
    
}

- (void)addDependency{
    //任务依赖
    NSBlockOperation *b1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"b1");
    }];
    
    NSBlockOperation *b2 = [NSBlockOperation blockOperationWithBlock:^{
        for(int i = 0; i < 2; i++){
            NSLog(@"b2");
        }
    }];
    NSBlockOperation *b3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"b3");
    }];
    
    //监听线程执行完毕
    b3.completionBlock = ^{
        NSLog(@"b3 执行完毕 ---%@", [NSThread currentThread]);
    };
    
    //b3依赖于b1 b2
    [b3 addDependency:b1];
    [b3 addDependency:b2];
    
    [_queue addOperation:b1];
    [_queue addOperation:b2];
    [_queue addOperation:b3];
    
}

- (void)createOperation{
    //创建任务
    //方式一
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    //方式二
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"messionBlock %@", [NSThread currentThread]);
    }];
    //添加额外的block
    [op2 addExecutionBlock:^{
        NSLog(@"messionExecution %@", [NSThread currentThread]);
    }];
    
    //方式三：自定义:(实现类的main方法)
    CSOperation *op3 = [[CSOperation alloc] init];
    
    //加入队列
    [_queue addOperation:op1]; //内部调用 [op1 start]
    [_queue addOperation:op2];
    [_queue addOperation:op3];
    [_queue addOperationWithBlock:^{
        NSLog(@"messionOperationWithBlock %@", [NSThread currentThread]);
    }];
}

- (void)run{
    for(int i = 0;i < 1; i++){
        NSLog(@"messionInvocation %@",[NSThread currentThread]);
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //挂起队列。注意:挂起操作会将当前任务执行完毕后，再去挂起该队列中的其他线程任务。
    //_queue.suspended = YES;
    
    //取消所有任务 注意:取消操作也会将当前任务执行完毕后，再取消其他任务
    //[_queue cancelAllOperations]; 内部调用所有任务的cancel
}

@end
