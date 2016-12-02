//
//  ViewController.m
//  VideoEdit
//
//  Created by arduomeng on 16/11/30.
//  Copyright © 2016年 arduomeng. All rights reserved.
//

/*
 AVMutableComposition 可以用来操作音频和视频的组合，AVMutableVideoComposition 可以用来对视频进行操作，AVMutableAudioMix 类是给视频添加音频的，AVMutableVideoCompositionInstruction和AVMutableVideoCompositionLayerInstruction 一般都是配合使用，用来给视频添加水印或者旋转视频方向，AVAssetExportSession 是用来进行视频导出操作的。需要值得注意的是当App进入后台之后，会对使用到GPU的代码操作进行限制，会造成崩溃，而视频处理这些功能多数会使用到GPU,所以需要做对应的防错处理。
 */

#import "ViewController.h"
#import "CSVideoPlayView.h"
#import <AVFoundation/AVFoundation.h>

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

int degree = 0;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainVideoView;
@property (nonatomic, strong) CSVideoPlayView *videoPlayView;
@property (nonatomic, strong) AVAsset *inputAsset;

@property (nonatomic, strong) AVMutableComposition *mutableComposition;
@property (nonatomic, strong) AVMutableVideoComposition *mutableVideoComposition;
@property (nonatomic, strong) AVMutableAudioMix *mutableAudioMix;


@end

@implementation ViewController


- (AVAsset *)inputAsset{
    if (!_inputAsset) {
        
        // 创建AVAsset
        NSString *urlString = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
        NSURL *url = [NSURL fileURLWithPath:urlString];
        _inputAsset = [AVAsset assetWithURL:url];
        
    }
    return _inputAsset;
}

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

// 创建AVMutableComposition对象 timeRange : 视频资源的时间段 startTime : 插入点
- (void)createMutableCompositionWithTimeRange:(CMTimeRange)timeRange startTime:(CMTime)startTime{
    //    拿到视频和音频资源
    //    创建AVMutableComposition对象
    //    往AVMutableComposition对象添加视频资源，同时设置视频资源的时间段和插入点
    //    往AVMutableComposition对象添加音频资源，同时设置音频资源的时间段和插入点
    
    // 获取VideoTrack AudioTrack 拿到视频和音频资源
    AVAssetTrack *videoTrack = nil;
    AVAssetTrack *audioTrack = nil;
    NSError *error = nil;
    
    if ([self.inputAsset tracksWithMediaType:AVMediaTypeVideo].count) {
        videoTrack = [[self.inputAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    }
    if ([self.inputAsset tracksWithMediaType:AVMediaTypeAudio].count) {
        audioTrack = [[self.inputAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    }
    
    //创建AVMutableComposition对象
    _mutableComposition = [AVMutableComposition composition];
    
    //往AVMutableComposition对象添加视频资源，同时设置视频资源的时间段和插入点
    if (videoTrack) {
        // 原视频时长
        AVMutableCompositionTrack *compositionVideoTrack = [_mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:timeRange ofTrack:videoTrack atTime:startTime error:&error];
        if (error) {
            NSLog(@"compositionVideoTrack %@", error);
        }
    }
    
    //往AVMutableComposition对象添加音频资源，同时设置音频资源的时间段和插入点
    if (audioTrack) {
        AVMutableCompositionTrack *compositionAudioTrack = [_mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:timeRange ofTrack:audioTrack atTime:startTime error:&error];
        if (error) {
            NSLog(@"compositionAudioTrack %@", error);
        }
    }
}

- (void)rotateToDegree{
    
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
    
    
    AVMutableVideoCompositionInstruction *instruction = nil;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = nil;
    
    AVAssetTrack *videoTrack = [[self.inputAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    // Step 1
    // Create a composition with the given asset and insert audio and video tracks into it from the asset
    float duration = CMTimeGetSeconds(self.inputAsset.duration);
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, _inputAsset.duration.timescale));
    CMTime startTime = kCMTimeZero;
    
    [self createMutableCompositionWithTimeRange:timeRange startTime:startTime];
    
    // Step 2
    // Translate the composition to compensate the movement caused by rotation (since rotation would cause it to move out of frame)
    // Rotate transformation
    CGAffineTransform t1;
    CGAffineTransform t2;
    
    // Step 3
    // Set the appropriate render sizes and rotational transforms
    // Create a new video composition
    self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    // 每一帧的时间
    self.mutableVideoComposition.frameDuration = CMTimeMake(1, _inputAsset.duration.timescale);
    
    switch (degree) {
        case 90:
            
            t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0);
            t2 = CGAffineTransformRotate(t1, degreesToRadians(90));
            // 绘制尺寸
            self.mutableVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
            break;
        case 180:
            t1 = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            t2 = CGAffineTransformRotate(t1, degreesToRadians(180));
            // 绘制尺寸
            self.mutableVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            break;
        case 270:
            t1 = CGAffineTransformMakeTranslation(0, videoTrack.naturalSize.width);
            t2 = CGAffineTransformRotate(t1, degreesToRadians(270));
            // 绘制尺寸
            self.mutableVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
            break;
        case 360:
            // 返回
            self.mutableVideoComposition = nil;
            degree = 0;
            [self reloadPlayerView];
            return;
            break;
        default:
            break;
    }
    
    // The rotate transform is set on a layer instruction
    instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.mutableComposition.duration);
    layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:self.mutableComposition.tracks[0]];
    [layerInstruction setTransform:t2 atTime:kCMTimeZero];
    
    // Step 4
    // Add the transform instructions to the video composition
    instruction.layerInstructions = @[layerInstruction];
    self.mutableVideoComposition.instructions = @[instruction];
    
    // Step 5
    // Notify AVSEViewController about rotation operation completion
    [self reloadPlayerView];
}


#pragma mark 事件
- (IBAction)Trim:(id)sender {
    
    
    float duration = CMTimeGetSeconds(self.inputAsset.duration);
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration * 0.5, _inputAsset.duration.timescale));
    CMTime startTime = kCMTimeZero;
    
    [self createMutableCompositionWithTimeRange:timeRange startTime:startTime];
    
    [self reloadPlayerView];
}
- (IBAction)Rotate:(id)sender {
    
    degree += 90;

    [self rotateToDegree];
    
}
- (IBAction)Crop:(id)sender {
}
- (IBAction)AddMusic:(id)sender {
//    拿到视频和音频资源
//    创建AVMutableComposition对象
//    往AVMutableComposition对象添加视频资源，同时设置视频资源的时间段和插入点
//    往AVMutableComposition对象添加音频资源，同时设置音频资源的时间段和插入点
//    往AVMutableComposition对象添加要追加的音频资源，同时设置音频资源的时间段，插入点和混合模式
    
    float duration = CMTimeGetSeconds(self.inputAsset.duration);
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, _inputAsset.duration.timescale));
    CMTime startTime = kCMTimeZero;
    [self createMutableCompositionWithTimeRange:timeRange startTime:startTime];
    
    // Step 1
    // Extract the custom audio track to be added to the composition
    NSString *audioURL = [[NSBundle mainBundle] pathForResource:@"audio" ofType:@"mp3"];
    AVAsset *audioAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:audioURL]];
    AVAssetTrack *newAudioTrack = [audioAsset tracksWithMediaType:AVMediaTypeAudio][0];
    
    AVMutableCompositionTrack *customAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [customAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [self.mutableComposition duration]) ofTrack:newAudioTrack atTime:kCMTimeZero error:nil];
    
    // Step 4
    // Mix parameters sets a volume ramp for the audio track to be mixed with existing audio track for the duration of the composition
    AVMutableAudioMixInputParameters *inputParameter = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:customAudioTrack];
    // fade in
    [inputParameter setVolumeRampFromStartVolume:0 toEndVolume:1 timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(1, 1))];
    // fade out
    [inputParameter setVolumeRampFromStartVolume:1 toEndVolume:0 timeRange:CMTimeRangeMake(, kCMTimeZero)];
    
    self.mutableAudioMix = [AVMutableAudioMix audioMix];
    self.mutableAudioMix.inputParameters = @[inputParameter];
    
    [self reloadPlayerView];
}
- (IBAction)AddWater:(id)sender {
}
- (IBAction)Reverse:(id)sender {
}

- (void)reloadPlayerView{
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.mutableComposition];
    playerItem.videoComposition = self.mutableVideoComposition;
    playerItem.audioMix = self.mutableAudioMix;
    
    _videoPlayView.outerPlayerItem = playerItem;
}


@end
