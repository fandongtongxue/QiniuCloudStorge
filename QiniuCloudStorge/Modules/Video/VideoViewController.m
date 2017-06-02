//
//  VideoViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/11.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "VideoViewController.h"
#import "QiniuUploadManager.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoFileListViewController.h"

@interface VideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *key;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initSubViews];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"视频";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"视频列表" style:UIBarButtonItemStylePlain target:self action:@selector(toFileListVC)];
}

- (void)initSubViews{
    
    UIImageView *currentImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    currentImageView.layer.borderColor = [UIColor blackColor].CGColor;
    currentImageView.layer.borderWidth = 1;
    currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    currentImageView.clipsToBounds = YES;
    [self.view addSubview:currentImageView];
    self.currentImageView = currentImageView;
    
    [self.currentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.view.mas_top).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(- 10 - 10 - 40 - kBottomBarHeight);
    }];
    
    UIButton *selectImageButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [selectImageButton setTitle:@"选取视频" forState:UIControlStateNormal];
    [selectImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [selectImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectImageButton setBackgroundColor:[UIColor blackColor]];
    selectImageButton.layer.cornerRadius = 5;
    selectImageButton.clipsToBounds = YES;
    [selectImageButton addTarget:self action:@selector(selectVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectImageButton];
    
    UIButton *uploadImageButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [uploadImageButton setTitle:@"上传视频" forState:UIControlStateNormal];
    [uploadImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [uploadImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadImageButton setBackgroundColor:[UIColor blackColor]];
    uploadImageButton.layer.cornerRadius = 5;
    uploadImageButton.clipsToBounds = YES;
    [uploadImageButton addTarget:self action:@selector(uploadVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadImageButton];
    
    [selectImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.currentImageView.mas_bottom).offset(10);
        make.right.equalTo(uploadImageButton.mas_left).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(uploadImageButton.mas_width);
    }];
    [uploadImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectImageButton.mas_right).offset(10);
        make.top.equalTo(self.currentImageView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(selectImageButton.mas_width);
    }];
}

- (void)toFileListVC{
    VideoFileListViewController *videoListVC = [[VideoFileListViewController alloc]init];
    videoListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoListVC animated:YES];
}

-(void)selectVideo{
    kWSelf;
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [[UIAlertController alloc]init];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
            
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"录像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
            
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"录像", nil];
        [actionSheet showInView:self.view];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker   didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        NSString *moviePath = [videoUrl path];
        
        self.player = [[MPMoviePlayerController alloc]initWithContentURL:videoUrl] ;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerThumbnailImageRequestDidFinish:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.player];
        
        [self.player requestThumbnailImagesAtTimes:@[@1.0] timeOption:MPMovieTimeOptionNearestKeyFrame];
        

        NSString *videoCacheDir = [NSHomeDirectory() stringByAppendingPathComponent:kVideoDetailLocalPrefix];
        if (![[NSFileManager defaultManager] fileExistsAtPath:videoCacheDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:videoCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        self.key = [NSString stringWithFormat:@"Video_%@%@",[AppHelper getPlatformString],[NSDate dateWithTimeIntervalSinceNow:3600 * 8]];
        
        NSString *lastPathComponent = [NSString stringWithFormat:@"%@.mov", self.key];
        NSString *videoPath = [videoCacheDir stringByAppendingPathComponent:lastPathComponent];
        [[NSFileManager defaultManager] copyItemAtPath:moviePath toPath:videoPath error:nil];
        self.data = [NSData dataWithContentsOfFile:videoPath];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerThumbnailImageRequestDidFinish:(NSNotification *)noti{
    
    [self.player stop];
    
    self.player = nil;
    
    NSDictionary *userInfo = [noti userInfo];
    
    UIImage *image =[userInfo objectForKey: @"MPMoviePlayerThumbnailImageKey"];
    
    self.currentImageView.image = image;
    
    self.currentImage = image;
}

- (void)uploadVideo{
    kWSelf;
    if (!self.currentImage) {
        [self showAlert:@"请先选择需要上传的视频"];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"上传中";
        
        [[QiniuUploadManager manager] getUploadTokenSuccessBlock:^(NSString *token) {
            [[QiniuUploadManager manager] upload:self.data Key:self.key Token:token SuccessBlock:^(NSDictionary *info) {
                [hud hide:YES];
                self.currentImage = nil;
                self.currentImageView.image = nil;
            } failBlock:^(NSError *error) {
                [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
               [hud hide:YES];
            } ProgressBlock:^(float percent) {
                DLOG(@"上传进度:%f",percent);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Instead we could have also passed a reference to the HUD
                    // to the HUD to myProgressTask as a method parameter.
                    [MBProgressHUD HUDForView:self.navigationController.view].progress = percent;
                });
            }];
        } failBlock:^(NSError *error) {
            [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
            [hud hide:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
        case 2:
            break;
        default:
            break;
    }
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
