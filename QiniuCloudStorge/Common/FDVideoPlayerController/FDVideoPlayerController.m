//
//  AVPlayerController.m
//  AVPlayerControllerDemo
//
//  Created by fandong on 2017/6/12.
//  Copyright © 2017年 fandong. All rights reserved.
//

#import "FDVideoPlayerController.h"
#import <AVFoundation/AVFoundation.h>

#define kFD_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define kFD_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface FDVideoPlayerController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic, copy) NSURL *url;

@property (nonatomic, strong) id timeObserver;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FDVideoPlayerController

#pragma mark - Init
- (instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (void)dealloc{
    [self removeKVO];
    [self removeNotification];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initPlayer];
    [self initNotification];
    [self initKVO];
    [self initControlView];
    [self initTimer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.player play];
    self.playButton.selected = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.player pause];
    self.playButton.selected = NO;
}

#pragma mark - Notification
- (void)initNotification{
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoEndAction:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoJumpedAction:) name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStalledAction:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoEnterBackgroundAction) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)videoEndAction:(NSNotification *)noti{
    DLOG(@"%s",__func__);
}

- (void)videoJumpedAction:(NSNotification *)noti{
    DLOG(@"%s",__func__);
}

- (void)videoStalledAction:(NSNotification *)noti{
    DLOG(@"%s",__func__);
}

- (void)videoEnterBackgroundAction{
    DLOG(@"%s",__func__);
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            //竖屏
            _playerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kFD_SCREEN_WIDTH, kFD_SCREEN_WIDTH * 9 / 16)];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            //Home在左边
            _playerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kFD_SCREEN_WIDTH, kFD_SCREEN_WIDTH * 9 / 16)];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            break;
        case UIInterfaceOrientationLandscapeRight:
            //Home在右边
            _playerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kFD_SCREEN_WIDTH, kFD_SCREEN_WIDTH * 9 / 16)];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            break;
        default:
            break;
    }
    _playerLayer.frame = _playerView.frame;
    _playButton.center = _playerView.center;
}

#pragma mark - KVO
- (void)initKVO{
    //KVO
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)monitoringPlay:(AVPlayerItem *)playItem{
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:NULL usingBlock:^(CMTime time) {
        // 在这里将监听到的播放进度代理出去，对进度条进行设置
        CGFloat currentPlayTime = playItem.currentTime.value/playItem.currentTime.timescale;
//        weakSelf.slider.value = currentPlayTime;
    }];
}

- (void)removeKVO{
    [_playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        DLOG(@"status");
        AVPlayerItemStatus status = _playerItem.status;
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                DLOG(@"AVPlayerItemStatusReadyToPlay");
                [_player play];
                [self.playButton setSelected:YES];
                CMTime duration = self.playerItem.duration;
//                self.slider.maximumValue = CMTimeGetSeconds(duration);
                [self monitoringPlay:self.playerItem];
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                DLOG(@"AVPlayerItemStatusUnknown");
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                DLOG(@"AVPlayerItemStatusFailed");
                DLOG(@"%@",_playerItem.error);
            }
                break;
                
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval avaliableDuration = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration =CMTimeGetSeconds(duration);
        DLOG(@"当前缓冲进度:%f",avaliableDuration/totalDuration);
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        DLOG(@"playbackBufferEmpty");
    }
}

#pragma mark - Player
- (void)initPlayer{
    [self.view addSubview:self.playerView];
    [self.playerView.layer addSublayer:self.playerLayer];
}

#pragma mark - Control
- (void)initControlView{
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.timeLabel];
}

#pragma mark - Timer
- (void)initTimer{
    if (!self.timer) {
        __weak typeof(self) weakSelf = self;
        NSTimer *timer = [NSTimer timerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.playButton.hidden = YES;
            [strongSelf deallocTimer];
        }];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

- (void)deallocTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - Action
- (void)playButtonAction:(UIButton *)sender{
    if (sender.selected) {
        //暂停
        [self.player pause];
    }else{
        //播放
        [self.player play];
    }
    sender.selected = !sender.selected;
    [self deallocTimer];
    [self initTimer];
}

- (void)sliderAction:(UISlider *)slider{
    DLOG(@"%f",slider.value);
}

- (void)showPlayButton{
    _playButton.hidden = NO;
    [self initTimer];
}

#pragma mark - Aid
- (NSTimeInterval)availableDuration{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds =CMTimeGetSeconds(timeRange.start);
    float duratiomSeconds = CMTimeGetSeconds(timeRange.duration);
    return startSeconds + duratiomSeconds;
}

#pragma mark - LazyLoad
- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _playButton.center = _playerView.center;
        [_playButton setImage:[UIImage imageNamed:@"video_play_button"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"video_pause_button"] forState:UIControlStateSelected];
        [_playButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_playerView.frame) + 15, kFD_SCREEN_WIDTH, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textColor = [UIColor blackColor];
    }
    return _timeLabel;
}

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kFD_SCREEN_WIDTH, kFD_SCREEN_WIDTH * 9 / 16)];
        _playerView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPlayButton)];
        _playerView.userInteractionEnabled = YES;
        [_playerView addGestureRecognizer:tap];
    }
    return _playerView;
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        _player.volume = 1.0;
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = _playerView.frame;
    }
    return _playerLayer;
}

- (AVPlayerItem *)playerItem{
    if (!_playerItem) {
        _playerItem = [[AVPlayerItem alloc]initWithURL:self.url];
    }
    return _playerItem;
}

@end
