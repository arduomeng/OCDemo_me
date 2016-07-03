//
//  ViewController.m
//  04-响应式编程思想
//
//  Created by xiaomage on 15/10/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"

#import "NSObject+KVO.h"
@interface ViewController ()

@property (nonatomic, strong) Person *p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // KVO底层实现
    // 1.自定义NSKVONotifying_Person子类
    // 2.重写setName,在内部恢复父类做法,通知观察者
    // 3.如何让外界调用自定义Person类的子类方法,修改当前对象的isa指针,指向NSKVONotifying_Person
    
    Person *p = [[Person alloc] init];
    
    // 监听name属性有没有改变
    [p xmg_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    _p = p;

}

- (void)KVO
{
    /*
     响应式编程思想
     a,b,c
     
     c = a + b;
     
     a = 2;
     
     b = 3;
     
     */
    
    Person *p = [[Person alloc] init];
    
    // 监听name属性有没有改变
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    _p = p;
    
    // KVO怎么实现
    // KVO的本质就是监听一个对象有没有调用set方法
    // 重写这个方法
    
    // 监听方法本质:并不需要修改方法的实现,仅仅想判断下有没有调用

}

// 只要p.name一改变就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%@",_p.name);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int i = 0;
    i++;
    _p.name = [NSString stringWithFormat:@"%d",i];
//    _p -> _name = [NSString stringWithFormat:@"%d",i];
}


@end
