//
//  ViewController.m
//  UICollectionView瀑布流
//
//  Created by LCS on 16/5/1.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionViewWalteLayout.h"
@interface ViewController () <UICollectionViewDataSource>

@end


static NSString *reuseID = @"cell";


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewWalteLayout *layout = [[UICollectionViewWalteLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseID];
    [self.view addSubview:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor purpleColor];
    
    return  cell;
}

@end
