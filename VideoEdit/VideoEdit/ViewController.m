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
#import "AVUtilities.h"
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

@property (nonatomic, strong) CALayer *watermarkLayer;

@property (nonatomic, strong) AVAssetExportSession *exportSession;
@property (nonatomic, strong) NSTimer *exportTimer;


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
    
    _inputAsset = _mutableComposition;
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
    if (!self.mutableVideoComposition) {
        self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    }
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
- (IBAction)Rate:(id)sender {
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
    // 从音频15秒 处插入
    [customAudioTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(15, audioAsset.duration.timescale), [self.mutableComposition duration]) ofTrack:newAudioTrack atTime:kCMTimeZero error:nil];
    
    // Step 4
    // Mix parameters sets a volume ramp for the audio track to be mixed with existing audio track for the duration of the composition
    AVMutableAudioMixInputParameters *inputParameter = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:customAudioTrack];
    CMTime fadeDuration = CMTimeMakeWithSeconds(1, self.mutableComposition.duration.timescale);
    CMTime fadeInTime = kCMTimeZero;
    CMTime fadeOutTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.mutableComposition.duration) - 1, self.mutableComposition.duration.timescale);
    // fade in
    [inputParameter setVolumeRampFromStartVolume:0 toEndVolume:1 timeRange:CMTimeRangeMake(fadeInTime, fadeDuration)];
    // fade out
    [inputParameter setVolumeRampFromStartVolume:1 toEndVolume:0 timeRange:CMTimeRangeMake(fadeOutTime, fadeDuration)];

    self.mutableAudioMix = [AVMutableAudioMix audioMix];
    self.mutableAudioMix.inputParameters = @[inputParameter];
    
    [self reloadPlayerView];
}
- (IBAction)AddWater:(id)sender {
    /*
    拿到视频和音频资源
    创建AVMutableComposition对象
    往AVMutableComposition对象添加视频资源，同时设置视频资源的时间段和插入点
    往AVMutableComposition对象添加音频资源，同时设置音频资源的时间段和插入点
    创建视频组合器对象 AVMutableVideoComposition 并设置frame和渲染宽高
    创建视频组合器指令对象，设置指令的作用范围
    创建视频组合器图层指令对象，设置指令的作用范围
    视频组合器图层指令对象 放入 视频组合器指令对象中
    视频组合器指令对象放入视频组合器对象
    创建水印图层Layer并设置frame和水印的位置，并将水印加入视频组合器中
     */
    
    // Step 1
    // Create a composition with the given asset and insert audio and video tracks into it from the asset
    float duration = CMTimeGetSeconds(self.inputAsset.duration);
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, _inputAsset.duration.timescale));
    CMTime startTime = kCMTimeZero;
    
    [self createMutableCompositionWithTimeRange:timeRange startTime:startTime];
    
    if (!self.mutableVideoComposition) {
        // build a pass through video composition
        self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
        self.mutableVideoComposition.frameDuration = CMTimeMake(1, self.mutableComposition.duration.timescale);
        
        AVAssetTrack *videoTrack = [[self.inputAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        self.mutableVideoComposition.renderSize = videoTrack.naturalSize;
        
        AVMutableVideoCompositionInstruction *passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [self.mutableComposition duration]);
        
        AVMutableVideoCompositionLayerInstruction *passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        passThroughInstruction.layerInstructions = @[passThroughLayer];
        self.mutableVideoComposition.instructions = @[passThroughInstruction];
    }
    
    // Step 2
    // Create a water mark layer of the same size as that of a video frame from the asset
    _watermarkLayer = [CALayer layer];
    _watermarkLayer.bounds = CGRectMake(0, 0, 200, 100);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    imageView.image = [UIImage imageNamed:@"trim_btn_fastsetting"];
    [_watermarkLayer addSublayer:imageView.layer];
    
    [self reloadPlayerView];
}
- (IBAction)Reverse:(id)sender {
    
    float duration = CMTimeGetSeconds(self.inputAsset.duration);
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, _inputAsset.duration.timescale));
    CMTime startTime = kCMTimeZero;
    [self createMutableCompositionWithTimeRange:timeRange startTime:startTime];
    
    NSString *path = [self createReverseDirectory];
    NSString *reverseFile = [path stringByAppendingPathComponent:@"reverse.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:reverseFile error:nil];
    _inputAsset = [AVUtilities assetByReversingAsset:_inputAsset outputURL:[NSURL fileURLWithPath:reverseFile]];
}
- (IBAction)RemoveAudio:(id)sender {
    
    float duration = CMTimeGetSeconds(self.inputAsset.duration);
    CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, _inputAsset.duration.timescale));
    CMTime startTime = kCMTimeZero;
    
    // 获取VideoTrack AudioTrack 拿到视频和音频资源
    AVAssetTrack *videoTrack = nil;
    NSError *error = nil;
    
    if ([self.inputAsset tracksWithMediaType:AVMediaTypeVideo].count) {
        videoTrack = [[self.inputAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
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
    
    _inputAsset = _mutableComposition;
    
    [self reloadPlayerView];
}
- (IBAction)export:(id)sender {
//    创建输出路径
//    根据AVMutableComposition对象创建AVAssetExportSession视频导出对象
//    设置AVAssetExportSession的AVMutableVideoComposition对象，AVMutableAudioMix对象，视频导出路径，视频导出格式
//    异步导出视频，根据导出结果做对应处理。
    
    // Step 1
    // Create an outputURL to which the exported movie will be saved
    NSString *exportDir = [self createExportDirectory];
    NSString *exportFile = [exportDir stringByAppendingPathComponent:@"output.mp4"];
    [[NSFileManager defaultManager] removeItemAtPath:exportFile error:nil];
    
    // Step 2
    // Create an export session with the composition and write the exported movie to the photo library
    // 含有水印处理
    if (self.watermarkLayer) {
        CALayer *exportWatermarkLayer = [self copyWatermarkLayer:self.watermarkLayer];
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, self.mutableVideoComposition.renderSize.width, self.mutableVideoComposition.renderSize.height);
        videoLayer.frame = CGRectMake(0, 0, self.mutableVideoComposition.renderSize.width, self.mutableVideoComposition.renderSize.height);
        [parentLayer addSublayer:videoLayer];
        exportWatermarkLayer.position = CGPointMake(self.mutableVideoComposition.renderSize.width/2, self.mutableVideoComposition.renderSize.height/4);
        [parentLayer addSublayer:exportWatermarkLayer];
        self.mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    }
    
    // 定时器监控导出进度
    _exportTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                    target:self
                                                  selector:@selector(updateExportProgress)
                                                  userInfo:nil
                                                   repeats:YES];

    // 导出
    _exportSession = [[AVAssetExportSession alloc] initWithAsset:self.mutableComposition presetName:AVAssetExportPreset1280x720];
    _exportSession.videoComposition = self.mutableVideoComposition;
    _exportSession.audioMix = self.mutableAudioMix;
    _exportSession.outputURL = [NSURL fileURLWithPath:exportFile];
    _exportSession.outputFileType = AVFileTypeMPEG4;

    // 异步开始导出
    [_exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            switch (_exportSession.status) {
                    
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"waiting");
                    break;
                case AVAssetExportSessionStatusUnknown:
                    
                    NSLog(@"Unknown:%@",self.exportSession.error);
                    break;
                case AVAssetExportSessionStatusExporting:
                    break;
                case AVAssetExportSessionStatusCompleted:
                    // 写入相册
                    NSLog(@"export success");
                    [_exportTimer invalidate];
                    _exportTimer = nil;
                    break;
                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Failed:%@",self.exportSession.error);
                    [_exportTimer invalidate];
                    _exportTimer = nil;
                    break;
                    
                default:
                    break;
            }

        });
    }];
}

- (void)updateExportProgress{
    NSLog(@"progress %.2f", _exportSession.progress);
}

- (CALayer*)copyWatermarkLayer:(CALayer*)inputLayer{
    CALayer *exportLayer = [CALayer layer];
    exportLayer.bounds = inputLayer.bounds;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    imageView.image = [UIImage imageNamed:@"trim_btn_fastsetting"];
    [exportLayer addSublayer:imageView.layer];
    return exportLayer;
}

- (NSString *)createExportDirectory{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentPath stringByAppendingPathComponent:@"Export"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
- (NSString *)createReverseDirectory{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentPath stringByAppendingPathComponent:@"Reverse"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

- (void)reloadPlayerView{
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:self.mutableComposition];
    playerItem.videoComposition = self.mutableVideoComposition;
    playerItem.audioMix = self.mutableAudioMix;
    
    if (self.watermarkLayer) {
        self.watermarkLayer.position = CGPointMake(self.videoPlayView.bounds.size.width * 0.5, self.videoPlayView.bounds.size.height * 0.5);
        [self.videoPlayView.layer addSublayer:self.watermarkLayer];
    }
    
    _videoPlayView.outerPlayerItem = playerItem;
}


@end
