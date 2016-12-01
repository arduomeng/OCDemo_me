//
//  ViewController.m
//  VideoEdit
//
//  Created by arduomeng on 16/11/30.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

/*
 AVMutableComposition 可以用来操作音频和视频的组合，AVMutableVideoComposition 可以用来对视频进行操作，AVMutableAudioMix 类是给视频添加音频的，AVMutableVideoCompositionInstruction和AVMutableVideoCompositionLayerInstruction 一般都是配合使用，用来给视频添加水印或者旋转视频方向，AVAssetExportSession 是用来进行视频导出操作的。需要值得注意的是当App进入后台之后，会对使用到GPU的代码操作进行限制，会造成崩溃，而视频处理这些功能多数会使用到GPU,所以需要做对应的防错处理。
 
 文／junbinchencn（简书作者）
 原文链接：http://www.jianshu.com/p/5433143cccd8
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 */

#import "ViewController.h"
#import "CSVideoPlayView.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainVideoView;
@property (nonatomic, strong) CSVideoPlayView *videoPlayView;
@property (nonatomic, strong) AVAsset *inputAsset;

@property (nonatomic, strong) AVMutableComposition *mutableComposition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoPlayView = [[[NSBundle mainBundle] loadNibNamed:@"CSVideoPlayView" owner:nil options:nil] lastObject];
    _videoPlayView.contrainerViewController = self;
    
    [self.mainVideoView addSubview:_videoPlayView];
    
    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    NSURL *url = [NSURL fileURLWithPath:urlString];
    _videoPlayView.url = url;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    _videoPlayView.frame = _mainVideoView.bounds;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark 事件
- (IBAction)Trim:(id)sender {
    
    //    拿到视频和音频资源
    //    创建AVMutableComposition对象
    //    往AVMutableComposition对象添加视频资源，同时设置视频资源的时间段和插入点
    //    往AVMutableComposition对象添加音频资源，同时设置音频资源的时间段和插入点
    
    
    // 创建AVAsset
    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    NSURL *url = [NSURL fileURLWithPath:urlString];
    _inputAsset = [AVAsset assetWithURL:url];
    
    // 获取VideoTrack AudioTrack 拿到视频和音频资源
    AVAssetTrack *videoTrack = nil;
    AVAssetTrack *audioTrack = nil;
    NSError *error = nil;
    
    if ([_inputAsset tracksWithMediaType:AVMediaTypeVideo].count) {
        videoTrack = [[_inputAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    }
    if ([_inputAsset tracksWithMediaType:AVMediaTypeAudio].count) {
        audioTrack = [[_inputAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    }
    
    //创建AVMutableComposition对象
    _mutableComposition = [AVMutableComposition composition];
    
    //往AVMutableComposition对象添加视频资源，同时设置视频资源的时间段和插入点
    float duration = CMTimeGetSeconds(_inputAsset.duration);
    if (videoTrack) {
        // 原视频时长
        AVMutableCompositionTrack *compositionVideoTrack = [_mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration * 0.5, _inputAsset.duration.timescale)) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
        if (error) {
            NSLog(@"compositionVideoTrack %@", error);
        }
    }
    
    //往AVMutableComposition对象添加音频资源，同时设置音频资源的时间段和插入点
    if (audioTrack) {
        AVMutableCompositionTrack *compositionAudioTrack = [_mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration * 0.5, _inputAsset.duration.timescale)) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
        if (error) {
            NSLog(@"compositionAudioTrack %@", error);
        }
    }
    
    [self reloadPlayerView];
}
- (IBAction)Rotate:(id)sender {
//    拿到视频和音频资源
//    创建AVMutableComposition对象
//    往AVMutableComposition对象添加视频资源，同时设置视频资源的时间段和插入点
//    往AVMutableComposition对象添加音频资源，同时设置音频资源的时间段和插入点
//    设置旋转矩阵变换
//    创建AVMutableVideoComposition对象
//    设置视频的渲染宽高和Frame
//    创建视频组合指令AVMutableVideoCompositionInstruction，并设置指令在视频的作用时间范围和旋转矩阵变换
//    创建视频组合图层指令AVMutableVideoCompositionLayerInstruction，并设置图层指令在视频的作用时间范围和旋转矩阵变换
//    把视频图层指令放到视频指令中，再放入视频组合对象中
    
    // Step 1
    // Create a composition with the given asset and insert audio and video tracks into it from the asset
    
    
    
}
- (IBAction)Crop:(id)sender {
}
- (IBAction)AddMusic:(id)sender {
}
- (IBAction)AddWater:(id)sender {
}
- (IBAction)Reverse:(id)sender {
}

- (void)reloadPlayerView{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.mutableComposition];
    
    _videoPlayView.outerPlayerItem = playerItem;
}

@end
