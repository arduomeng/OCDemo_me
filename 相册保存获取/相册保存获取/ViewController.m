//
//  ViewController.m
//  相册保存获取
//
//  Created by LCS on 16/9/24.
//  Copyright © 2016年 LCS. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"save error");
    }else{
        NSLog(@"save success");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 保存
    // [self saveImage];
    
    // 获取
    [self getOriginalImage];
    
}

- (void)getThumbnailImage{
    // 获取相簿中的所有图片
    
    // 同步获得图片？
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    // 1. 获取自定义相簿
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in fetchResult) {
        NSLog(@"%@", collection.localizedTitle);
        // 2. 获取相簿对应的图片
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        for (PHAsset *asset in assets) {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(0, 0) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                NSLog(@"%@", result);
            }];
        }
    }
    
    // 2. 获取相机胶卷
    PHFetchResult *fetchResult2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    for (PHAssetCollection *collection in fetchResult2) {
        NSLog(@"%@", collection.localizedTitle);
        // 2. 获取相簿对应的图片
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        for (PHAsset *asset in assets) {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(0, 0) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                NSLog(@"%@", result);
            }];
        }
    }
}

// 缩略图和原图的获取唯一区别targetSize
- (void)getOriginalImage{
    // 获取相簿中的所有图片
    
    // 同步获得图片？
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    // 1. 获取自定义相簿
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in fetchResult) {
        NSLog(@"%@", collection.localizedTitle);
        // 2. 获取相簿对应的图片
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        for (PHAsset *asset in assets) {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                NSLog(@"%@", result);
            }];
        }
    }
    
    // 2. 获取相机胶卷
    PHFetchResult *fetchResult2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    for (PHAssetCollection *collection in fetchResult2) {
        NSLog(@"%@", collection.localizedTitle);
        // 2. 获取相簿对应的图片
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        for (PHAsset *asset in assets) {
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(0, 0) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                NSLog(@"%@", result);
            }];
        }
    }
}

- (void)saveImage{
    // PHAsset : 一个资源
    // PHAssetCollection : 一个相簿
    // 0.判断授权状态
    /*
     PHAuthorizationStatusNotDetermined = 0, // User has not yet made a choice with regards to this application
     PHAuthorizationStatusRestricted,        // This application is not authorized to access photo data.
     // The user cannot change this application’s status, possibly due to active restrictions
     //   such as parental controls being in place.
     PHAuthorizationStatusDenied,            // User has explicitly denied this application access to photos data.
     PHAuthorizationStatusAuthorized
     */
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusRestricted:
            NSLog(@"系统原因无法访问相册");
            break;
        case PHAuthorizationStatusDenied:
            NSLog(@"提醒用户打开权限");
            break;
        case PHAuthorizationStatusAuthorized:
            [self savePhotoAlbum];
            break;
        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusDenied) {
                    NSLog(@"提醒用户打开权限");
                }else{
                    [self savePhotoAlbum];
                }
            }];
            break;
    }
}

// 1.保存图片到“相机胶卷”
// 2.创建“相簿”
// 3.添加图片到相簿
- (void)savePhotoAlbum{
    UIImage *image = [UIImage imageNamed:@"qq"];
    // 凡事对相册进行修改 都需要在performChanges的block中进行
    
    __block NSString *PHAssetLocalIdentifiers = nil;
    
    // 1.保存图片到“相机胶卷”
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 系统默认在子线程中执行操作
        PHAssetLocalIdentifiers = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 手动回到主线程操作
        if (success) {
            
            // 2.获得相簿，若不存在则新建
            PHAssetCollection *assetCollection =  [self getAssetCollect];
            if (assetCollection == nil) {
                NSLog(@"获取相簿失败");
                return ;
            }
            
            // 3.添加图片到相簿
            
            // 获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[PHAssetLocalIdentifiers] options:nil].lastObject;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                [request addAssets:@[asset]];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    NSLog(@"保存图片到相簿成功");
                }else{
                    NSLog(@"保存图片到相簿失败 %@", error);
                }
                
            }];
            
        }else{
            NSLog(@"保存相机胶卷失败 %@", error);
        }
    }];
    
    
}

- (PHAssetCollection *)getAssetCollect{
    
    PHAssetCollection *assetCollection = nil;
    __block NSString *PHAssetCollectLocalIdentifiers = nil;
    
    // 判断该项目的相簿是否存在
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in fetchResult) {
        if ([collection.localizedTitle isEqualToString:@"安人多梦"]) {
            return collection;
        }
    }
    
    // 创建“相簿”
    NSError *error = nil;
//  [[PHPhotoLibrary sharedPhotoLibrary] performChanges:]             异步操作创建相簿
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{  // 同步操作创建相簿
        PHAssetCollectLocalIdentifiers = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"安人多梦"].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        return nil;
    }
    // 获得相簿
    assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[PHAssetCollectLocalIdentifiers] options:nil].lastObject;
    
    return assetCollection;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
