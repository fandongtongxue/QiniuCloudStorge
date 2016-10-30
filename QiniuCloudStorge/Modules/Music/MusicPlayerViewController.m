//
//  MusicPlayerViewController.m
//  QiniuCloudStorge
//
//  Created by 范东 on 16/10/19.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import <DOUAudioStreamer/DOUAudioStreamer.h>
#import <DOUAudioStreamer/DOUAudioVisualizer.h>
#import "MusicModel.h"
#import "ImageFileDetailModel.h"
#import "FXBlurView.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface MusicPlayerViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *statusLabel;
//@property (nonatomic, strong) UILabel *miscLabel;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *playPreBtn;
@property (nonatomic, strong) UIButton *playNextBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UISlider *progressSlider;
//@property (nonatomic, strong) UIImageView *volumeImageView;
//@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) DOUAudioStreamer *streamer;
@property (nonatomic, strong) DOUAudioVisualizer *visualizer;
//@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSInteger currentTrackIndex;
@property (nonatomic, strong) NSMutableArray *tracks;

@end

@implementation MusicPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentTrackIndex = self.index;
}

- (void)loadView
{
    FXBlurView *view = [[FXBlurView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setDynamic:YES];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenSizeWidth - 40 , 30, 22.5, 13.5)];
    [closeBtn setEnlargeEdge:20];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [closeBtn setBackgroundColor:view.backgroundColor];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
//    UIImageView *volumeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, CGRectGetMaxY([closeBtn frame]) + 10.0, 32.0, 32.0)];
//    [volumeImageView setImage:[UIImage imageNamed:@"music_img_vol"]];
//    [view addSubview:volumeImageView];
//    self.volumeImageView = volumeImageView;
//    
//    UISlider *volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX([self.volumeImageView frame]) + 8, CGRectGetMinY([self.volumeImageView frame]), CGRectGetWidth([view bounds]) - CGRectGetMaxX([self.volumeImageView frame]) - 10.0 - 20.0, 40.0)];
//    volumeSlider.centerY = self.volumeImageView.centerY;
//    [volumeSlider addTarget:self action:@selector(_actionSliderVolume:) forControlEvents:UIControlEventValueChanged];
//    [view addSubview:volumeSlider];
//    self.volumeSlider = volumeSlider;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, CGRectGetMaxY(closeBtn.frame) + 20.0, CGRectGetWidth([view bounds]) - 40.0, 30.0)];
    [titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [titleLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
//    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([self.titleLabel frame]) + 10.0, CGRectGetWidth([view bounds]), 30.0)];
//    [statusLabel setFont:[UIFont systemFontOfSize:16.0]];
//    [statusLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
//    [statusLabel setTextAlignment:NSTextAlignmentCenter];
//    [statusLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//    [view addSubview:statusLabel];
//    self.statusLabel = statusLabel;
//    
//    UILabel *miscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([self.statusLabel frame]) + 10.0, CGRectGetWidth([view bounds]), 20.0)];
//    [miscLabel setFont:[UIFont systemFontOfSize:10.0]];
//    [miscLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
//    [miscLabel setTextAlignment:NSTextAlignmentCenter];
//    [miscLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//    [view addSubview:miscLabel];
//    self.miscLabel = miscLabel;
    
    DOUAudioVisualizer *visualizer = [[DOUAudioVisualizer alloc] initWithFrame:CGRectMake(40.0, CGRectGetMaxY([self.titleLabel frame]) + 10.0, CGRectGetWidth([view bounds]) - 80.0, CGRectGetWidth([view bounds]) - 80.0)];
    [visualizer setBackgroundColor:view.backgroundColor];
    [view addSubview:visualizer];
    self.visualizer = visualizer;
    
    UISlider *progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0, CGRectGetMaxY([self.visualizer frame]) + 10.0, CGRectGetWidth([view bounds]) - 20.0 * 2.0, 40.0)];
    [progressSlider addTarget:self action:@selector(_actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:progressSlider];
    self.progressSlider = progressSlider;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [playBtn setFrame:CGRectMake(80.0, CGRectGetMaxY([self.progressSlider frame]) + 10.0, 60.0, 60.0)];
    playBtn.centerX = view.centerX;
    [playBtn setBackgroundImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(_actionPlayPause:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:playBtn];
    self.playBtn = playBtn;
    
    UIButton *playPreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [playPreBtn setFrame:CGRectMake(0.0, CGRectGetMaxY([self.progressSlider frame]) + 10.0, 20.0, 28.0)];
    playPreBtn.right = playBtn.left - 25;
    playPreBtn.centerY = self.playBtn.centerY;
    [playPreBtn setBackgroundImage:[UIImage imageNamed:@"prev_song"] forState:UIControlStateNormal];
    [playPreBtn addTarget:self action:@selector(_actionPlayPre:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:playPreBtn];
    self.playPreBtn = playPreBtn;
    
    UIButton *playNextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [playNextBtn setFrame:CGRectMake(0, CGRectGetMaxY([self.progressSlider frame]) + 10.0, 20.0, 28.0)];
    playNextBtn.left = self.playBtn.right + 25;
    playNextBtn.centerY = self.playBtn.centerY;
    [playNextBtn setBackgroundImage:[UIImage imageNamed:@"next_song"] forState:UIControlStateNormal];
    [playNextBtn addTarget:self action:@selector(_actionPlayNext:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:playNextBtn];
    self.playNextBtn = playNextBtn;
    
//    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [stopBtn setFrame:CGRectMake(round((CGRectGetWidth([view bounds]) - 60.0) / 2.0), CGRectGetMaxY([self.playBtn frame]) + 10.0, 32.0, 32.0)];
//    [stopBtn setBackgroundImage:[UIImage imageNamed:@"music_btn_stop"] forState:UIControlStateNormal];
//    [stopBtn addTarget:self action:@selector(_actionStop:) forControlEvents:UIControlEventTouchDown];
//    [view addSubview:stopBtn];
//    self.stopBtn = stopBtn;
    
//    UIProgressView *progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, kScreenSizeHeight - 5, kScreenSizeWidth, 5)];
//    progressView.progress = 0;
//    [view addSubview:progressView];
//    self.progressView = progressView;
    
    [self setView:view];
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)_resetStreamer
{
    [self _cancelStreamer];
    
    MusicModel *model = [self.tracks objectAtIndex:_currentTrackIndex];
    NSString *title = [NSString stringWithFormat:@"%@", model.title];
    [_titleLabel setText:title];
    
    _streamer = [DOUAudioStreamer streamerWithAudioFile:model];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
    
    [_streamer play];
    
    [self _updateBufferingStatus];
    [self _setupHintForStreamer];
}

- (void)_setupHintForStreamer
{
    NSUInteger nextIndex = _currentTrackIndex + 1;
    if (nextIndex >= [_tracks count]) {
        nextIndex = 0;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

- (void)_timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
        [_progressSlider setValue:0.0f animated:NO];
    }
    else {
        [_progressSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
    }
}

- (void)_updateStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
//            [_statusLabel setText:@"playing"];
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerPaused:
//            [_statusLabel setText:@"paused"];
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerIdle:
//            [_statusLabel setText:@"idle"];
            [_playBtn setBackgroundImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerFinished:
//            [_statusLabel setText:@"finished"];
            break;
            
        case DOUAudioStreamerBuffering:
//            [_statusLabel setText:@"buffering"];
            break;
            
        case DOUAudioStreamerError:
//            [_statusLabel setText:@"error"];
            break;
    }
}

- (void)_updateBufferingStatus
{
//    [_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];
//    double progress = (double)[_streamer receivedLength] / (double)[_streamer expectedLength];
//    NSString *progressStr = [NSString stringWithFormat:@"%.2f",progress];
//    [self.progressView setProgress:progressStr.floatValue animated:YES];
    if ([_streamer bufferingRatio] >= 1.0) {
        NSLog(@"sha256: %@", [_streamer sha256]);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(_updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _resetStreamer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
//    [_volumeSlider setValue:[DOUAudioStreamer volume]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
    [_streamer stop];
    [self _cancelStreamer];
    
    [super viewWillDisappear:animated];
}

- (void)_actionPlayPause:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }
    else {
        [_streamer pause];
    }
}

- (void)_actionPlayPre:(id)sender
{
    if (--_currentTrackIndex <= 0) {
        _currentTrackIndex = 0;
    }
    [self _resetStreamer];
}

- (void)_actionPlayNext:(id)sender
{
    if (++_currentTrackIndex >= [_tracks count]) {
        _currentTrackIndex = 0;
    }
    [self _resetStreamer];
}

//- (void)_actionStop:(id)sender
//{
//    [_streamer stop];
//}

- (void)_actionSliderProgress:(id)sender
{
    [_streamer setCurrentTime:[_streamer duration] * [_progressSlider value]];
}

//- (void)_actionSliderVolume:(id)sender
//{
//    [DOUAudioStreamer setVolume:[_volumeSlider value]];
//}

- (NSMutableArray *)tracks{
    if (_tracks == nil) {
        _tracks = [[NSMutableArray alloc]init];
        for (ImageFileDetailModel *model in self.modelsArray) {
            MusicModel *musicModel = [[MusicModel alloc]init];
            musicModel.audioFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            NSArray *stringArray = [self.key componentsSeparatedByString:@"."];
            NSString *string = stringArray[0];
            NSString *newString = [string substringFromIndex:8];
            musicModel.title = newString;
            [_tracks addObject:musicModel];
        }
    }
    return _tracks;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
