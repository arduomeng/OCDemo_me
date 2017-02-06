//
//  ViewController.m
//  iTunes数据获取
//
//  Created by arduomeng on 16/12/21.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self loadLocalMusic];
    
    [self loadLocalVideo];
}

/** 返回单例---如果使用不同的对象会发出警告 */
+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    //创建后会一直保留着引用
    static ALAssetsLibrary * assetsLibrary = nil;
    
    static dispatch_once_t onceToken;
    // 保证代码只执行一次
    dispatch_once(&onceToken, ^{
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeImageDataToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error){}];
    });
    
    return assetsLibrary;
}


- (void)loadLocalVideo{
    MPMediaQuery *query = [MPMediaQuery playlistsQuery];
    NSMutableArray *tmpList = [[query items] mutableCopy];
    if (tmpList) {
        
        for (int i=0; i<tmpList.count; i++) {
            
            MPMediaItem *mediaItem = tmpList[i];
            //inf.mediaItem = mediaItem;
            AVURLAsset *asset=[AVURLAsset URLAssetWithURL:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] options:@{AVURLAssetPreferPreciseDurationAndTimingKey : @YES}];
            if ([[mediaItem valueForProperty:MPMediaItemPropertyMediaType] unsignedIntegerValue] > MPMediaTypeAnyAudio) {
                
                NSLog(@"type video");
                
                ALAssetsLibrary *alLibrary = [ViewController defaultAssetsLibrary];
                [alLibrary assetForURL:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] resultBlock:^(ALAsset *asset){
                    NSLog(@"alLibrary ");
                } failureBlock:^(NSError *error){
                    NSLog(@"alLibrary ");
                }];
                
            }else{
                NSLog(@"type sound");
            }
            NSLog(@"duration %f", CMTimeGetSeconds(asset.duration));
            NSLog(@"path %@", [[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString]);
            NSLog(@"fileName %@", [mediaItem valueForProperty:MPMediaItemPropertyTitle]);
            NSLog(@"------------");
        }
    }
}

- (NSArray *)loadLocalMusic {
    
    MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
    
    MPMediaQuery *query = [MPMediaQuery albumsQuery];
    NSMutableArray *tmpList = [[query items] mutableCopy];
    NSMutableArray *localM = [NSMutableArray array];
    if (tmpList) {
        /*
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for(MPMediaItem *item in tmpList){
            long duration = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
            if (duration < limitSecond) {
                [tmp addObject:item];
            }
        }
        //删除时长太短的音乐
        for(MPMediaItem *item in tmp){
            [tmpList removeObject:item];
        }
        */
        for (int i=0; i<tmpList.count; i++) {
            
            MPMediaItem *mediaItem = tmpList[i];
            //inf.mediaItem = mediaItem;
            AVURLAsset *asset=[AVURLAsset URLAssetWithURL:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] options:@{AVURLAssetPreferPreciseDurationAndTimingKey : @YES}];
            
            NSLog(@"duration %f", CMTimeGetSeconds(asset.duration));
            NSLog(@"path %@", [[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] absoluteString]);
            NSLog(@"fileName %@", [mediaItem valueForProperty:MPMediaItemPropertyTitle]);
            NSLog(@"------------");
        }
    }
    return localM.copy;
}



@end
