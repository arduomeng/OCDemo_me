//
//  ViewController.m
//  GCD的使用
//
//  Created by LCS on 16/4/9.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 sync 和 async 决定了能否开启多线程
 串行并行       决定任务的执行方式
 
 async 异步函数，会等当前函数执行完后执行
 sync  同步函数，会立刻加入到队列中执行
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    // 异步方式， 串行队列 开启一条线程串行执行
    // [self asyncSerial];
    /*
     2016-04-09 13:35:30.409 GCD的使用[1473:29019]  <NSThread: 0x7f92fad07770>{number = 1, name = main}
     2016-04-09 13:35:30.410 GCD的使用[1473:29101]  <NSThread: 0x7f92fae03bf0>{number = 2, name = (null)} =======  0
     2016-04-09 13:35:30.410 GCD的使用[1473:29101]  <NSThread: 0x7f92fae03bf0>{number = 2, name = (null)} =======  1
     2016-04-09 13:35:30.410 GCD的使用[1473:29101]  <NSThread: 0x7f92fae03bf0>{number = 2, name = (null)} =======  0
     2016-04-09 13:35:30.410 GCD的使用[1473:29101]  <NSThread: 0x7f92fae03bf0>{number = 2, name = (null)} =======  1
     2016-04-09 13:35:30.411 GCD的使用[1473:29101]  <NSThread: 0x7f92fae03bf0>{number = 2, name = (null)} =======  0
     2016-04-09 13:35:30.411 GCD的使用[1473:29101]  <NSThread: 0x7f92fae03bf0>{number = 2, name = (null)} =======  1
     */
    
    // 异步方式， 主队列 不创建线程在主队列中串行执行 注意 ！ (加入到主线程中的任务，都在主线程执行)
    // [self asyncMainQueue];
    /*
     2016-04-09 14:24:25.509 GCD的使用[2171:53012]  <NSThread: 0x7f840be04b00>{number = 1, name = main}
     2016-04-09 14:24:25.514 GCD的使用[2171:53012]  <NSThread: 0x7f840be04b00>{number = 1, name = main} =======  0
     2016-04-09 14:24:25.515 GCD的使用[2171:53012]  <NSThread: 0x7f840be04b00>{number = 1, name = main} =======  1
     2016-04-09 14:24:25.515 GCD的使用[2171:53012]  <NSThread: 0x7f840be04b00>{number = 1, name = main} =======  0
     2016-04-09 14:24:25.515 GCD的使用[2171:53012]  <NSThread: 0x7f840be04b00>{number = 1, name = main} =======  1
     2016-04-09 14:24:25.515 GCD的使用[2171:53012]  <NSThread: 0x7f840be04b00>{number = 1, name = main} =======  0
     2016-04-09 14:24:25.515 GCD的使用[2171:53012]  <NSThread: 0x7f840be04b00>{number = 1, name = main} =======  1
     */
    
    
    //异步方式， 并行队列会开启多线程，
    //[self asyncConcurrent];
    /*
     2016-04-09 14:47:17.777 GCD的使用[2533:62553]  <NSThread: 0x7f8c91607730>{number = 1, name = main}
     2016-04-09 14:47:17.778 GCD的使用[2533:62553] asyncConcurrent
     2016-04-09 14:47:17.778 GCD的使用[2533:62605]  <NSThread: 0x7f8c915029b0>{number = 3, name = (null)} =======  0
     2016-04-09 14:47:17.778 GCD的使用[2533:62606]  <NSThread: 0x7f8c91624e00>{number = 2, name = (null)} =======  0
     2016-04-09 14:47:17.778 GCD的使用[2533:62607]  <NSThread: 0x7f8c91622400>{number = 4, name = (null)} =======  0
     2016-04-09 14:47:17.779 GCD的使用[2533:62605]  <NSThread: 0x7f8c915029b0>{number = 3, name = (null)} =======  1
     2016-04-09 14:47:17.779 GCD的使用[2533:62606]  <NSThread: 0x7f8c91624e00>{number = 2, name = (null)} =======  1
     2016-04-09 14:47:17.779 GCD的使用[2533:62607]  <NSThread: 0x7f8c91622400>{number = 4, name = (null)} =======  1
     */
    
    //同步方式， 在当前线程中执行
    //[self syncConcurrent];
    //[self syncSerial];
    /*
     2016-04-09 14:49:48.982 GCD的使用[2577:64118]  <NSThread: 0x7faba0e06630>{number = 1, name = main}
     2016-04-09 14:49:48.983 GCD的使用[2577:64118]  <NSThread: 0x7faba0e06630>{number = 1, name = main} =======  0
     2016-04-09 14:49:48.983 GCD的使用[2577:64118]  <NSThread: 0x7faba0e06630>{number = 1, name = main} =======  1
     2016-04-09 14:49:48.983 GCD的使用[2577:64118]  <NSThread: 0x7faba0e06630>{number = 1, name = main} =======  0
     2016-04-09 14:49:48.983 GCD的使用[2577:64118]  <NSThread: 0x7faba0e06630>{number = 1, name = main} =======  1
     2016-04-09 14:49:48.983 GCD的使用[2577:64118]  <NSThread: 0x7faba0e06630>{number = 1, name = main} =======  0
     2016-04-09 14:49:48.984 GCD的使用[2577:64118]  <NSThread: 0x7faba0e06630>{number = 1, name = main} =======  1
     2016-04-09 14:49:48.984 GCD的使用[2577:64118] asyncConcurrent
     */
    
    //死锁。
    //[self syncMainQueue];
    
    
    
    
    /*GCD常用方法
     1.延时执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(<#delayInSeconds#> * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        <#code to be executed after a specified delay#>
    });
     2.一次性代码
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
     <#code to be executed once#>
     });
     3.栅栏，等前面的任务执行完后，在执行后面的任务
     dispatch_barrier_async(<#dispatch_queue_t queue#>, <#^(void)block#>)
     4.迭代,快速遍历
     dispatch_apply(<#size_t iterations#>, <#dispatch_queue_t queue#>, <#^(size_t)block#>)
     5.队列组
     dispatch_group_async(<#dispatch_group_t group#>, <#dispatch_queue_t queue#>, <#^(void)block#>)
     当队列组中的任务都执行完后会调用
     dispatch_group_notify(<#dispatch_group_t group#>, <#dispatch_queue_t queue#>, <#^(void)block#>)方法。可以将最后的操作放在里面.例如队列组里面有两个任务下载两张图片，下载完成后在notify方法中，进行图片的合成。
     */
    
    
}

//使用异步方式创建任务，将任务放入串行队列中
- (void)asyncSerial{
    //创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("lcs", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@" %@", [NSThread currentThread]);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
}


//使用异步方式创建任务，将任务放入主队列中
- (void)asyncMainQueue{
    
    //主队列 (加入到主线程中的任务，都在主线程执行)
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    NSLog(@" %@", [NSThread currentThread]);
    
    dispatch_async(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_async(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_async(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
}


//使用异步方式创建任务，将任务放入并行队列中
- (void)asyncConcurrent{
    
    //自己创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("lcs", DISPATCH_QUEUE_CONCURRENT);
    
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@" %@", [NSThread currentThread]);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    
    //async 异步函数，会等当前函数执行完后在开线程
    NSLog(@"asyncConcurrent");
}

//使用同步方式创建任务，将任务放入并行队列中
- (void)syncConcurrent{
    
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    
    NSLog(@" %@", [NSThread currentThread]);
    
    dispatch_sync(globalQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_sync(globalQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_sync(globalQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    //sync  同步函数，会立刻加入到队列中执行
    NSLog(@"asyncConcurrent");
}

//使用同步方式创建任务，将任务放入串行队列中
- (void)syncSerial{
    
    //自己创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("lcs", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@" %@", [NSThread currentThread]);
    
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    
    //sync  同步函数，会立刻加入到队列中执行
    NSLog(@"asyncConcurrent");
    
}


//使用同步方式创建任务，将任务放入主队列中
- (void)syncMainQueue{
    
    //主队列 (加入到主线程中的任务，都在主线程执行)
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    NSLog(@" %@", [NSThread currentThread]);
    
    dispatch_sync(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_sync(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
    dispatch_sync(mainQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@" %@ =======  %ld", [NSThread currentThread], i);
        }
    });
}


@end
