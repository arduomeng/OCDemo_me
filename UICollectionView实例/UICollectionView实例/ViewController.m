//
//  ViewController.m
//  UICollectionView实例
//
//  Created by LCS on 16/5/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionViewLineLayout.h"
#import "UICollectionViewCircleLayout.h"
@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *reuseID = @"cell";

@implementation ViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [@[@"", @"", @"", @"", @"", @""] mutableCopy];
    }
    return _dataArr;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGRect rect = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400);
        UICollectionViewCircleLayout *layout = [[UICollectionViewCircleLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseID];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blueColor];
    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.dataArr removeObjectAtIndex:indexPath.item];
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 切换layout布局样式
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:NSClassFromString(@"UICollectionViewLineLayout")]) {
        [self.collectionView setCollectionViewLayout:[[UICollectionViewCircleLayout alloc] init] animated:YES];
    }else{
        [self.collectionView setCollectionViewLayout:[[UICollectionViewLineLayout alloc] init] animated:YES];
    }
   
}

@end
