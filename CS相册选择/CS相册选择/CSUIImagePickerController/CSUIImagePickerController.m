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
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact; // 图像尺寸精确
    
    /*
        若需要返回精确尺寸的image 需要设置两个条件
        1.contentMode = PHImageContentModeAspectFill
        2.options.resizeMode = PHImageRequestOptionsResizeModeExact
     
     targetSize :  需要注意在 PHImageManager 中，所有的尺寸都是用 Pixel 作为单位（Note that all sizes are in pixels），因此这里想要获得正确大小的图像，需要把输入的尺寸转换为 Pixel。如果需要返回原图尺寸，可以传入 PhotoKit 中预先定义好的常量 PHImageManagerMaximumSize，表示返回可选范围内的最大的尺寸，即原图尺寸
     contentMode : 图像的剪裁方式，与 UIView 的 contentMode 参数相似，控制照片应该以按比例缩放还是按比例填充的方式放到最终展示的容器内。注意如果 targetSize 传入 PHImageManagerMaximumSize，则 contentMode 无论传入什么值都会被视为 PHImageContentModeDefault。
     
   
     */
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        // 该block会回调多次，苹果会先返回较小尺寸的image，作为暂时的显示
        cell.imageView.image = result;
        NSLog(@"imageSize : %@", NSStringFromCGSize(result.size));
    }];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CSUIImageAssetViewController *vc = [CSUIImageAssetViewController initFromStoryboard:[CSUIImageAssetViewController class]];
    vc.model = _collectionArr[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
