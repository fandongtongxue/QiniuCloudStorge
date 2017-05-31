//
//  VideoDetailViewController.m
//  QiniuCloudStorge
//
//  Created by fandong on 2017/5/31.
//  Copyright © 2017年 范东. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "KRVideoPlayerController.h"

@interface VideoDetailViewController ()

@property (nonatomic, strong) KRVideoPlayerController *player;

@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initPlayer];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player dismiss];
}

- (void)initPlayer{
    self.player = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeWidth*(9.0/16.0))];
    self.player.contentURL = [NSURL URLWithString:self.contentURL];
    [self.player showInWindow];
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
