//
//  CSUIImagePickerController.m
//  CS相册选择
//
//  Created by arduomeng on 16/11/7.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "CSUIImagePickerController.h"
#import "CSUIImageAssetViewController.h"
#import "UIBarButtonItem+Extensions.h"
#import <Photos/Photos.h>
#import "CSAlbumsModel.h"
#import "UIViewController+Util.h"
#import "PHPhotoUtil.h"
@interface CSUIImagePickerController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, assign) CSMenuButtonStyle menuButtonStyle;

@property (nonatomic, strong) NSMutableArray *collectionArr;


@end

@implementation CSUIImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionArr = [NSMutableArray array];
    
    self.title = @"相册";
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem barButtonItemWithImage:@"material_back" highLightImage:@"material_back" target:self action:@selector(dismiss)]];
    
    [self requestPhotoAutho];
}
- (IBAction)onClickTabView:(UIButton *)sender {
    if (sender == _selectedButton) {
        return;
    }
    
    switch (sender.tag) {
        case CSMenuButtonStyleAll:
            self.menuButtonStyle = CSMenuButtonStyleAll;
            break;
        case CSMenuButtonStyleVideo:
            self.menuButtonStyle = CSMenuButtonStyleVideo;
            break;
        case CSMenuButtonStylePhoto:
            self.menuButtonStyle = CSMenuButtonStylePhoto;
            break;
            
        default:
            break;
    }
    
    [self requestPhotoAutho];
}

- (void)requestPhotoAutho{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusRestricted:
            NSLog(@"系统原因无法访问相册");
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"提醒用户打开权限");
            break;
        case PHAuthorizationStatusAuthorized:
            [self fetchAssetCollection];
            break;
        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusDenied) {
                    NSLog(@"提醒用户打开权限");
                }else{
                    [self fetchAssetCollection];
                }
            }];
            break;
    }
    
}

- (void)fetchAssetCollection{
    
    [_collectionArr removeAllObjects];
    // 获取所有自定义的相册
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [self getAlbumsModelWith:fetchResult];
    
    NSLog(@"--------------------------");
    // 获取相机胶卷
    fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [self getAlbumsModelWith:fetchResult];
    
    [_mainTableView reloadData];
}

// 根据类型 过滤相册
- (void)getAlbumsModelWith:(PHFetchResult *)results{
    // 根据类型添加对应的相册
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    switch (self.menuButtonStyle) {
        case CSMenuButtonStyleAll:
            break;
        case CSMenuButtonStyleVideo:
        {
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            
        }
            break;
        case CSMenuButtonStylePhoto:
        {
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }
            break;
            
        default:
            break;
    }
    for (PHAssetCollection *collection in results) {
        NSLog(@"name : %@", collection.localizedTitle);
        
        PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (!results.count) {
            continue;
        }
        
        // 创建相册模型
        CSAlbumsModel *album = [CSAlbumsModel albumModelWith:results name:collection.localizedTitle];
        [_collectionArr addObject:album];
        
    }
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _collectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumscell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"albumscell"];
    }
    CSAlbumsModel *model = _collectionArr[indexPath.row];
    [cell.textLabel setText:model.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld", model.count]];
    
    PHAsset *asset = (PHAsset *)model.results.lastObject;
    
    [PHPhotoUtil requestExactImageAsync:asset size:CGSizeMake(200, 200) resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.imageView.image = result;
    }];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSUIImageAssetViewController *vc = [CSUIImageAssetViewController initFromStoryboard:[CSUIImageAssetViewController class]];
    vc.model = _collectionArr[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
