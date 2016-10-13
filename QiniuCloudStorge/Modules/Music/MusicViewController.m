//
//  MusicViewController.m
//  QiniuCloudStorge
//
//  Created by 范东 on 16/10/10.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicFileListViewController.h"

@interface MusicViewController ()

@property (nonatomic, strong) UIImageView *currentImageView;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initSubViews];
    [self configRecordSession];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"音乐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"音乐列表" style:UIBarButtonItemStylePlain target:self action:@selector(toFileListVC)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearRecord)];
}

- (void)clearRecord{
    
}

- (void)toFileListVC{
    MusicFileListViewController *listVC = [[MusicFileListViewController alloc]init];
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)initSubViews{
    UIImageView *currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kScreenSizeWidth - 20, kScreenSizeHeight - 10 - 10 - 10 - 40 - kBottomBarHeight - kStatusBarHeight - kNavigationBarHeight)];
    currentImageView.layer.borderColor = [UIColor blackColor].CGColor;
    currentImageView.layer.borderWidth = 1;
    currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    currentImageView.clipsToBounds = YES;
    [self.view addSubview:currentImageView];
    self.currentImageView = currentImageView;
    
    UIButton *selectImageButton = [[UIButton alloc]initWithFrame:CGRectMake(10, currentImageView.bottom + 10, (kScreenSizeWidth - 30)/2, 40)];
    [selectImageButton setTitle:@"开始录音" forState:UIControlStateNormal];
    [selectImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [selectImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectImageButton setBackgroundColor:[UIColor blackColor]];
    selectImageButton.layer.cornerRadius = 5;
    selectImageButton.clipsToBounds = YES;
    [selectImageButton addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectImageButton];
    
    UIButton *uploadImageButton = [[UIButton alloc]initWithFrame:CGRectMake(selectImageButton.right + 10, currentImageView.bottom + 10, (kScreenSizeWidth - 30)/2, 40)];
    [uploadImageButton setTitle:@"上传录音" forState:UIControlStateNormal];
    [uploadImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [uploadImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadImageButton setBackgroundColor:[UIColor blackColor]];
    uploadImageButton.layer.cornerRadius = 5;
    uploadImageButton.clipsToBounds = YES;
    [uploadImageButton addTarget:self action:@selector(uploadRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadImageButton];
}

- (void)startRecord{
    
}
- (void)uploadRecord{
    
}

//设置音频会话
- (void)configRecordSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
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
