//
//  VideoFileDetailViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "VideoFileDetailViewController.h"
#import "KRVideoPlayerController.h"

@interface VideoFileDetailViewController ()

@property (nonatomic, strong) KRVideoPlayerController *videoController;

@end

@implementation VideoFileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initPlayer];
    [self initNotification];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频详情";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.videoController stop];
    [self.videoController dismiss];
    self.videoController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
    [self.videoController stop];
    [self.videoController dismiss];
    self.videoController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initPlayer{
    NSString *videoUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[self.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (!self.videoController) {
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeWidth*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController showInSuperView:self.view];
    }
    
    NSString *localFilePrePath = [NSHomeDirectory() stringByAppendingPathComponent:kVideoDetailLocalPrefix];
    NSString *localFilePath = [localFilePrePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",self.key]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        self.videoController.contentURL = [NSURL fileURLWithPath:localFilePath];
    }else{
        self.videoController.contentURL = [NSURL URLWithString:videoUrl];
    }
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoControllerDidFullScreen) name:KRVideoPlayerControllerFullScreenNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoControllerDidExitFullScreen) name:KRVideoPlayerControllerExitFullScreenNoti object:nil];
}

- (void)videoControllerDidFullScreen{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)videoControllerDidExitFullScreen{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
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
