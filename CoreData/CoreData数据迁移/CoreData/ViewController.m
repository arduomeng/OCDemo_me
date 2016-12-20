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
@interface ViewController ()

@property (nonatomic, strong) NSManagedObjectContext *ctx;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 上下文
    _ctx = [[NSManagedObjectContext alloc] init];
    
    // 模型管理器
    // 添加某一个.xcdatamodeld模型到模型管理器中   一个上下文对应一个数据库
     NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"]];
    // 2. 创建持久存储器
    // 2.1 给存储器添加模型管理器
    NSPersistentStoreCoordinator *persistentStroe = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    // 2.2 设置存储器存储类型和路径
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [document stringByAppendingPathComponent:@"CoreData.sqlite"];
    NSLog(@"%@", path);
    NSError *error = nil;
    
    // 设置option参数 CoreData 自动进行数据迁移
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    [persistentStroe addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:optionsDictionary error:&error];
    
    if (error) {
        NSLog(@"持久存储器创建失败");
    }
    
    // 3. 设置上下文的持久存储器
    _ctx.persistentStoreCoordinator = persistentStroe;
    
}

- (IBAction)add:(id)sender {
    
    for (int i = 0; i < 10 ; i ++) {
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_ctx];
        student.name = @"lcs";
        //student.age = [NSDate date];
        student.height = @(100 + i);
        
        NSError *error = nil;
        
        [_ctx save:&error];
        
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
    NSArray *resultArr = [_ctx executeFetchRequest:request error:&error];
    
    if (!error) {
        for (Student *student in resultArr) {
            
            [_ctx deleteObject:student];
            
            // 保存修改
            [_ctx save:nil];
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
    NSArray *resultArr = [_ctx executeFetchRequest:request error:&error];
    
    if (!error) {
        for (Student *student in resultArr) {
            student.height = @(student.height.floatValue + 1);
            
            // 保存修改
            [_ctx save:nil];
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
    NSArray *resultArr = [_ctx executeFetchRequest:request error:&error];
    
    if (!error) {
        for (Student *student in resultArr) {
//            NSLog(@"name : %@, age : %@, height : %@", student.name, student.age, student.height);
            NSLog(@"name : %@, height : %@, address : %@", student.name, student.height, student.address);
        }
    }
}

@end
