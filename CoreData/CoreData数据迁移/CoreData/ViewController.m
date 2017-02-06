//
//  ViewController.m
//  CoreData
//
//  Created by LCS on 16/7/14.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Student+CoreDataProperties.h"
#import "AppDelegate.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)add:(id)sender {
    
    for (int i = 0; i < 10 ; i ++) {
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:[AppDelegate shareInstance].managedObjectContext];
        student.name = @"lcs";
        //student.age = [NSDate date];
        student.height = @(100 + i);
        
        NSError *error = nil;
        
        [[AppDelegate shareInstance].managedObjectContext save:&error];
        
        if (!error) {
            NSLog(@"添加数据成功");
        }
    }
    
}
- (IBAction)delete:(id)sender {
    // 先执行select操作，再对数据进行删除后保存。
    
    // 创建一个数据获取对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 设置请求参数
    request.predicate = [NSPredicate predicateWithFormat:@"height > 109"];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[sortDesc];
    
    NSError *error =nil;
    NSArray *resultArr = [[AppDelegate shareInstance].managedObjectContext executeFetchRequest:request error:&error];
    
    if (!error) {
        for (Student *student in resultArr) {
            
            [[AppDelegate shareInstance].managedObjectContext deleteObject:student];
            
            // 保存修改
            [[AppDelegate shareInstance].managedObjectContext save:nil];
        }
    }
    
}
- (IBAction)update:(id)sender {
    // 先执行select操作，再对数据进行修改后保存。
    
    // 创建一个数据获取对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 设置请求参数
    request.predicate = [NSPredicate predicateWithFormat:@"height > 105"];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[sortDesc];
    
    NSError *error =nil;
    NSArray *resultArr = [[AppDelegate shareInstance].managedObjectContext executeFetchRequest:request error:&error];
    
    if (!error) {
        for (Student *student in resultArr) {
            student.height = @(student.height.floatValue + 1);
            
            // 保存修改
            [[AppDelegate shareInstance].managedObjectContext save:nil];
        }
    }
}
- (IBAction)select:(id)sender {
    
    // 创建一个数据获取对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 设置请求参数
//    request.predicate = [NSPredicate predicateWithFormat:@"height > 105"];
    
    // 模糊查询
//    request.predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@",@"lcs"];
//    request.predicate = [NSPredicate predicateWithFormat:@"name ENDSWITH %@", @"cs"];
//    request.predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"c"];
    
    // 分页查询
//    request.fetchOffset = 0;
//    request.fetchLimit = 1;
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO];
    request.sortDescriptors = @[sortDesc];
    
    NSError *error =nil;
    NSArray *resultArr = [[AppDelegate shareInstance].managedObjectContext executeFetchRequest:request error:&error];
    
    if (!error) {
        for (Student *student in resultArr) {
            // CoreData
            NSLog(@"name : %@, age : %@, height : %@", student.name, student.age, student.height);
            // CoreData 1.2
            //NSLog(@"name : %@, height : %@, address : %@", student.name, student.height, student.address);
            // CoreData 1.1
            //NSLog(@"name : %@, height : %@", student.name, student.height);
        }
    }
}

@end
