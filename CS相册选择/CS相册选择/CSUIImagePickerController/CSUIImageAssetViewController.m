//
//  CSUIImageAssetViewController.m
//  CS相册选择
//
//  Created by arduomeng on 16/11/7.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "CSUIImageAssetViewController.h"
#import "UIBarButtonItem+Extensions.h"
#import "CSAlbumsModel.h"
#import "CSAssetModel.h"
#import "CSUIImageAssetCollectionViewCell.h"
#import <AVKit/AVPlayerViewController.h>
#import <Photos/Photos.h>
@interface CSUIImageAssetViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (nonatomic, strong) NSMutableArray *assetArr;
@property (nonatomic, strong) UIImageView *previewView;


@end

@implementation CSUIImageAssetViewController


- (NSMutableArray *)assetArr{
    if (!_assetArr) {
        _assetArr = [[NSMutableArray alloc] init];
    }
    return _assetArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem barButtonItemWithImage:@"material_back" highLightImage:@"material_back" target:self action:@selector(pop)]];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    [self.navigationItem setRightBarButtonItems:@[cancelItem, confirmItem]];
    
    
}

- (void)configCollectionView {
    //取消自动调整contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 5;
    CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - 5 * margin) * 0.25;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    _mainCollectionView.contentInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    _mainCollectionView.collectionViewLayout = layout;
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"CSUIImageAssetCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CSUIImageAssetCollectionViewCell"];
}

- (void)setModel:(CSAlbumsModel *)model{
    _model = model;
    
    self.title = model.name;
    
    // 处理模型对象
    for (PHAsset *asset in model.results) {
        CSAssetModel *model = [[CSAssetModel alloc] init];
        model.asset = asset;
        
        
        
        [self.assetArr addObject:model];
    }
    
    [_mainCollectionView reloadData];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirm{
    NSLog(@"confirm");
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assetArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CSUIImageAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSUIImageAssetCollectionViewCell" forIndexPath:indexPath];
    cell.model = _assetArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CSAssetModel *model = _assetArr[indexPath.row];
    
    if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        [[PHImageManager defaultManager] requestPlayerItemForVideo:model.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                AVPlayerViewController *playvc = [[AVPlayerViewController alloc] init];
                playvc.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
                [self presentViewController:playvc animated:YES completion:nil];
            });
            
        }];
    }else if (model.asset.mediaType == PHAssetMediaTypeImage){
        
        self.navigationController.navigationBar.hidden = YES;
        
        _previewView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _previewView.userInteractionEnabled = YES;
        _previewView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_previewView];
        UITapGestureRecognizer *reconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_previewView addGestureRecognizer:reconginzer];
        
        // 根据image原始宽高比，计算所需要的targetSize
//        CGSize imageSize;
//        
//        PHAsset *phAsset = model.asset;
//        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
//        CGFloat pixelWidth = [UIScreen mainScreen].bounds.size.width;
//        CGFloat pixelHeight = pixelWidth / aspectRatio;
//        imageSize = CGSizeMake(pixelWidth, pixelHeight);
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact; // 图像尺寸精确
        
        [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:CGSizeMake(model.asset.pixelWidth, model.asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            _previewView.image = result;
            NSLog(@"original image size %@", NSStringFromCGSize(result.size));
        }];
    }
    
    
}

- (void)tap{
    
    self.navigationController.navigationBar.hidden = NO;
    
    [_previewView removeFromSuperview];
    _previewView = nil;
}

@end
