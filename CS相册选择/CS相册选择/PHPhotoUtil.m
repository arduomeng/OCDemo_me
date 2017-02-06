//
//  PHPhotoUtil.m
//  VideoShow
//
//  Created by arduomeng on 16/12/29.
//  Copyright © 2016年 energy. All rights reserved.
//

#import "PHPhotoUtil.h"
#import <Photos/Photos.h>
@implementation PHPhotoUtil

// 获取精确尺寸的image
+ (void)requestExactImageAsync:(PHAsset *)asset size:(CGSize)size resultHandler:(resultHandlerExactImage)block{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact; // 图像尺寸精确
    /*
     若需要返回精确尺寸的image 需要设置两个条件
     1.contentMode = PHImageContentModeAspectFill
     2.options.resizeMode = PHImageRequestOptionsResizeModeExact
     
     targetSize :  需要注意在 PHImageManager 中，所有的尺寸都是用 Pixel 作为单位（Note that all sizes are in pixels），因此这里想要获得正确大小的图像，需要把输入的尺寸转换为 Pixel。如果需要返回原图尺寸，可以传入 PhotoKit 中预先定义好的常量 PHImageManagerMaximumSize，表示返回可选范围内的最大的尺寸，即原图尺寸
     contentMode : 图像的剪裁方式，与 UIView 的 contentMode 参数相似，控制照片应该以按比例缩放还是按比例填充的方式放到最终展示的容器内。注意如果 targetSize 传入 PHImageManagerMaximumSize，则 contentMode 无论传入什么值都会被视为 PHImageContentModeDefault。
     
     
     */
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        // 该block会回调多次，苹果会先返回较小尺寸的image，作为暂时的显示
        block(result, info);
        NSLog(@"imageSize : %@", NSStringFromCGSize(result.size));
    }];
}

// 同步获取精确尺寸的image
+ (void)requestExactImageSync:(PHAsset *)asset size:(CGSize)size resultHandler:(resultHandlerExactImage)block{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact; // 图像尺寸精确
    options.synchronous = YES;
    /*
     若需要返回精确尺寸的image 需要设置两个条件
     1.contentMode = PHImageContentModeAspectFill
     2.options.resizeMode = PHImageRequestOptionsResizeModeExact
     
     targetSize :  需要注意在 PHImageManager 中，所有的尺寸都是用 Pixel 作为单位（Note that all sizes are in pixels），因此这里想要获得正确大小的图像，需要把输入的尺寸转换为 Pixel。如果需要返回原图尺寸，可以传入 PhotoKit 中预先定义好的常量 PHImageManagerMaximumSize，表示返回可选范围内的最大的尺寸，即原图尺寸
     contentMode : 图像的剪裁方式，与 UIView 的 contentMode 参数相似，控制照片应该以按比例缩放还是按比例填充的方式放到最终展示的容器内。注意如果 targetSize 传入 PHImageManagerMaximumSize，则 contentMode 无论传入什么值都会被视为 PHImageContentModeDefault。
     
     
     */
    
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[asset.localIdentifier] options:nil];
    PHAsset *phasset = result.firstObject;
    [[PHImageManager defaultManager] requestImageForAsset:phasset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        // 该block会回调多次，苹果会先返回较小尺寸的image，作为暂时的显示
        block(result, info);
        NSLog(@"imageSize : %@", NSStringFromCGSize(result.size));
    }];
   

    
    
    
}

// 获取缩略图尺寸的image
+ (void)requestThumbnailImage:(PHAsset *)asset resultHandler:(resultHandlerExactImage)block{
    [self requestExactImageAsync:asset size:CGSizeMake(200, 200) resultHandler:^(UIImage *result, NSDictionary *info) {
        block(result, info);
    }];
}

// 获取缩略图尺寸的image
+ (void)requestThumbnailImageSync:(PHAsset *)asset resultHandler:(resultHandlerExactImage)block{
    [self requestExactImageSync:asset size:CGSizeMake(200, 200) resultHandler:^(UIImage *result, NSDictionary *info) {
        block(result, info);
    }];
}

// 获取图片url
+ (void)requestImageURL:(PHAsset *)asset resultHandler:(resultHandlerImageURL)block{
    
    __block NSURL *url = nil;
    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
    options.canHandleAdjustmentData = ^(PHAdjustmentData *adjustmentData){
        return  YES;
    };
    
    [asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
        url = contentEditingInput.fullSizeImageURL;
        block(url, info);
        
    }];
    
}

// 获取视频URL
+ (void)requestVideoURL:(PHAsset *)asset resultHandler:(resultHandlerImageURL)block{
    
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.version = PHVideoRequestOptionsVersionOriginal;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        NSURL *url = nil;
        if (urlAsset) {
            url = urlAsset.URL;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(url, info);
        });
    }];
}

// 查找PHAsset
+ (PHAsset *)fetchAssetWithIdentifier:(NSString *)indentifier{
    if (!indentifier) {
        return nil;
    }
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[indentifier] options:nil];
    if (!result || !result.count) {
        return nil;
    }
    PHAsset *phasset = result.firstObject;
    
    return phasset;
}

// 保存视频到相册并存入数据库
+(void)saveVideoFromURL:(NSURL *)url  toAlbum:(NSString *)customAlbumName  completionBlock:(void (^)(PHAsset *phasset))completionBlock  failureBlock:(void (^)(NSError *error))failureBlock{
    
    // 凡事对相册进行修改 都需要在performChanges的block中进行
    
    __block NSString *PHAssetLocalIdentifiers = nil;
    
    // 1.保存图片到“相机胶卷”
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 系统默认在子线程中执行操作
        
        // iOS 9 later
        // PHAssetLocalIdentifiers = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:url].placeholderForCreatedAsset.localIdentifier;
        
        PHAssetLocalIdentifiers = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url].placeholderForCreatedAsset.localIdentifier;

    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 手动回到主线程操作
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (success) {
                
                // 2.获得相簿，若不存在则新建
                PHAssetCollection *assetCollection =  [self getAssetCollect:customAlbumName];
                if (assetCollection == nil) {
                    NSLog(@"获取相簿失败");
                    failureBlock(error);
                    return ;
                }
                
                // 3.添加图片到相簿
                if (!PHAssetLocalIdentifiers) {
                    NSLog(@"获取资源失败");
                    failureBlock(error);
                    return ;
                }
                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[PHAssetLocalIdentifiers] options:nil].lastObject;
                
                if (!asset) {
                    NSLog(@"获取资源失败");
                    failureBlock(error);
                    return ;
                }
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                    [request addAssets:@[asset]];
                    
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (success) {
                            NSLog(@"保存到相簿成功");
                            completionBlock(asset);
                        }else{
                            NSLog(@"保存到相簿失败 %@", error);
                            failureBlock(error);
                        }
                    });
                    
                }];
                
            }else{
                NSLog(@"保存相机胶卷失败 %@", error);
                failureBlock(error);
            }
        });
        
    }];
    
}

// 获取相册对象
+ (PHAssetCollection *)getAssetCollect:(NSString *)albumName{
    
    PHAssetCollection *assetCollection = nil;
    __block NSString *PHAssetCollectLocalIdentifiers = nil;
    
    // 判断该项目的相簿是否存在
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in fetchResult) {
        if ([collection.localizedTitle isEqualToString:albumName]) {
            return collection;
        }
    }
    
    // 创建“相簿”
    NSError *error = nil;
    //  [[PHPhotoLibrary sharedPhotoLibrary] performChanges:]             异步操作创建相簿
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{  // 同步操作创建相簿
        PHAssetCollectLocalIdentifiers = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        return nil;
    }
    // 获得相簿
    assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[PHAssetCollectLocalIdentifiers] options:nil].lastObject;
    
    return assetCollection;
}

// 获取视频大小
+ (float)getVideoFilesize:(NSURL *)url{
    
    if ([url.absoluteString hasPrefix:@"ipod-library:"]) {
        AVURLAsset *avasset  = [AVURLAsset URLAssetWithURL:url options:@{AVURLAssetPreferPreciseDurationAndTimingKey : @YES}];
        NSArray *tracks = [avasset tracks];
        float estimatedSize = 0.0 ;
        for (AVAssetTrack * track in tracks) {
            float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
            float seconds = CMTimeGetSeconds([track timeRange].duration);
            estimatedSize += seconds * rate;
        }
        return  estimatedSize / 1024 / 1024;
    }else{
        AVURLAsset* urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        
        NSNumber *size;
        
        [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
        return [size floatValue]/(1024.0*1024.0);
    }
}

// 获取视频大小PHAsset
+ (void)getVideoFilesizeWithPHAsset:(PHAsset *)phasset block:(void(^)(float assetSize))block{
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    
    __block float currentAssetSize = 0;
    [[PHImageManager defaultManager] requestAVAssetForVideo:phasset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
        
        
        if ([asset isKindOfClass:[AVURLAsset class]]) {
            AVURLAsset* urlAsset = (AVURLAsset*)asset;
            
            NSNumber *size;
            
            [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
            currentAssetSize = [size floatValue]/(1024.0*1024.0);
            
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(currentAssetSize);
        });
    }];
    

}
// 获取图片大小PHAsset
+ (void)getImageFilesizeWithPHAsset:(PHAsset *)phasset block:(void(^)(float assetSize))block{
    __block float imageSize = 0;
    [[PHImageManager defaultManager] requestImageDataForAsset:phasset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        imageSize = imageData.length;
        //convert to Megabytes
        imageSize = imageSize/(1024*1024);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(imageSize);
        });
    }];
    
}
@end
