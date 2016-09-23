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
@property (nonatomic, assign) BOOL isUploading;

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
    self.title = @"七牛视频云";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"视频列表" style:UIBarButtonItemStylePlain target:self action:@selector(toFileListVC)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearImage)];
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
    [selectImageButton setTitle:@"Select Video" forState:UIControlStateNormal];
    [selectImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [selectImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectImageButton setBackgroundColor:[UIColor blackColor]];
    selectImageButton.layer.cornerRadius = 5;
    selectImageButton.clipsToBounds = YES;
    [selectImageButton addTarget:self action:@selector(selectVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectImageButton];
    
    UIButton *uploadImageButton = [[UIButton alloc]initWithFrame:CGRectMake(selectImageButton.right + 10, currentImageView.bottom + 10, (kScreenSizeWidth - 30)/2, 40)];
    [uploadImageButton setTitle:@"Upload Video" forState:UIControlStateNormal];
    [uploadImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [uploadImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadImageButton setBackgroundColor:[UIColor blackColor]];
    uploadImageButton.layer.cornerRadius = 5;
    uploadImageButton.clipsToBounds = YES;
    [uploadImageButton addTarget:self action:@selector(uploadVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadImageButton];
}

- (void)toFileListVC{
    if (_isUploading) {
        [self showAlert:@"上传视频中..."];
        return;
    }
    VideoFileListViewController *videoListVC = [[VideoFileListViewController alloc]init];
    videoListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoListVC animated:YES];
}

- (void)clearImage{
    if (_isUploading) {
        [self showAlert:@"上传视频中..."];
        return;
    }
    self.currentImageView.image = nil;
    self.currentImage = nil;
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
        _isUploading = YES;
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [[QiniuUploadManager manager] getUploadTokenSuccessBlock:^(NSString *token) {
            [[QiniuUploadManager manager] upload:self.data Key:self.key Token:token SuccessBlock:^(NSDictionary *info) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                _isUploading = NO;
            } failBlock:^(NSError *error) {
                [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                _isUploading = NO;
            }];
        } failBlock:^(NSError *error) {
            [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            _isUploading = NO;
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

- (void)showAlert:(NSString *)alertString{
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"上传信息" message:alertString preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"上传信息" message:alertString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
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
