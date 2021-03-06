//
//  AllViewController.m
//  QiniuCloudStorge
//
//  Created by fandong on 2017/6/23.
//  Copyright © 2017年 范东. All rights reserved.
//

#import "AllViewController.h"
#import "ConfigViewController.h"
#import <AVKit/AVKit.h>
#import "FDPhotoBrowserHeader.h"
#import "MJDownload.h"
#import "FDVideoPlayerController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "QiniuUploadManager.h"

#define kGetFileImageListUrl @"http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/list_file_image.php"
#define kGetFileVideoListUrl @"http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/list_file_video.php"
#define kGetFileMusicListUrl @"http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/list_file_music.php"
#define kGetFileFileListUrl @"http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/list_file.php"

static NSString * const cellID = @"fileCellID";

@interface AllViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableString *marker;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImageView *currentImageView;

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) AllViewControllerUploadType uploadType;

@end

@implementation AllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _url = kGetFileImageListUrl;
    [self initNavigationBar];
    [self initSegmentedControl];
    [self initTableView];
    [self initRefreshUI];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"七牛云";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(uploadFile)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initSegmentedControl{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"图片", @"视频", @"音乐", @"文件"]];
    [segmentedControl addTarget:self action:@selector(segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(5);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(self.view).offset(5);
        make.height.mas_equalTo(30);
    }];
    self.segmentedControl = segmentedControl;
}

- (void)initTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[FileDetailCell class] forCellReuseIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)uploadFile{
    kWSelf;
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [[UIAlertController alloc]init];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.view.backgroundColor = [UIColor whiteColor];
            [weakSelf.navigationController presentViewController:imagePicker animated:YES completion:nil];
            weakSelf.uploadType = AllViewControllerUploadTypePhoto;
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.view.backgroundColor = [UIColor whiteColor];
            [weakSelf.navigationController presentViewController:imagePicker animated:YES completion:nil];
            weakSelf.uploadType = AllViewControllerUploadTypePhoto;
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
            weakSelf.uploadType = AllViewControllerUploadTypeVideo;
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"录像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
            weakSelf.uploadType = AllViewControllerUploadTypeVideo;
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择照片",@"拍照",@"从相册选择视频",@"录像", nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            self.uploadType = AllViewControllerUploadTypePhoto;
            break;
        }
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            self.uploadType = AllViewControllerUploadTypePhoto;
            break;
        }
        case 2:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
            [self presentViewController:imagePicker animated:YES completion:nil];
            self.uploadType = AllViewControllerUploadTypeVideo;
            break;
        }
        case 3:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
            [self presentViewController:imagePicker animated:YES completion:nil];
            self.uploadType = AllViewControllerUploadTypeVideo;
            break;
        }
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (self.uploadType == AllViewControllerUploadTypePhoto) {
        self.currentImageView.image = info[@"UIImagePickerControllerOriginalImage"];
        self.currentImage = info[@"UIImagePickerControllerOriginalImage"];
        self.key = [NSString stringWithFormat:@"Image_%@%@",[AppHelper getPlatformString],[NSDate dateWithTimeIntervalSinceNow:3600 * 8]];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self uploadImage];
    }else{
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
            
            self.key = [NSString stringWithFormat:@"Video_%@%@.mov",[AppHelper getPlatformString],[NSDate dateWithTimeIntervalSinceNow:3600 * 8]];
            
            NSString *lastPathComponent = self.key;
            NSString *videoPath = [videoCacheDir stringByAppendingPathComponent:lastPathComponent];
            [[NSFileManager defaultManager] copyItemAtPath:moviePath toPath:videoPath error:nil];
            self.data = [NSData dataWithContentsOfFile:videoPath];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        [self uploadVideo];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerThumbnailImageRequestDidFinish:(NSNotification *)noti{
    
    [self.player stop];
    
    self.player = nil;
    
    NSDictionary *userInfo = [noti userInfo];
    
    UIImage *image =[userInfo objectForKey: @"MPMoviePlayerThumbnailImageKey"];
    
    self.currentImageView.image = image;
    
    self.currentImage = image;
}

- (void)uploadImage{
    kWSelf;
    if (!self.currentImage) {
        [self showAlert:@"请先选择需要上传的图片"];
    }else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Set the annular determinate mode to show task progress.
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"上传中";
        
        [[QiniuUploadManager manager] getUploadTokenSuccessBlock:^(NSString *token) {
            NSData *data = UIImageJPEGRepresentation(self.currentImage, 1.0);
            [[QiniuUploadManager manager] upload:data Key:self.key Token:token SuccessBlock:^(NSDictionary *info) {
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

- (void)uploadVideo{
    kWSelf;
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

- (void)segmentedControlDidChange:(UISegmentedControl *)sender{
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    switch (sender.selectedSegmentIndex) {
        case 0:
            //图片
            _url = kGetFileImageListUrl;
            break;
        case 1:
            //视频
            _url = kGetFileVideoListUrl;
            break;
        case 2:
            //音乐
            _url = kGetFileMusicListUrl;
            break;
        case 3:
            //文件
            _url = kGetFileFileListUrl;
            break;
        default:
            break;
    }
    self.tableView.mj_footer = nil;
    [_marker setString:@""];
    [self requestFirstPageData];
}

- (void)initRefreshUI{
    kWSelf;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_marker setString:@""];
        [weakSelf requestFirstPageData];
    }];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestFirstPageData{
    if (![self.tableView.mj_header isRefreshing]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    kWSelf;
    NSDictionary *params = @{@"uuid":[AppHelper uuid],
                             @"marker":self.marker};
    [[BaseNetworking shareInstance] GET:_url dict:params succeed:^(id data) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
            [self.dataArray removeAllObjects];
            NSDictionary *resultDic = (NSDictionary *)data;
            NSArray *resultArray = resultDic[@"data"][@"data"];
            if ([resultDic[@"data"][@"marker"] isKindOfClass:[NSString class]] && resultDic[@"data"][@"marker"] !=NULL) {
                [weakSelf.marker setString:resultDic[@"data"][@"marker"]];
            }
            for (NSInteger i = 0; i<resultArray.count; i++) {
                FileDetailModel *model = [FileDetailModel modelWithDict:resultArray[i]];
                [weakSelf.dataArray addObject:model];
            }
            if (resultArray.count < 20) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                if (resultArray.count == 0) {
                    [JDStatusBarNotification showWithStatus:@"暂无文件" dismissAfter:1.5 styleName:JDStatusBarStyleDark];
                }
            }else{
                if (!self.tableView.mj_footer) {
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf requestMoreData];
                    }];
                    self.tableView.mj_footer = footer;
                }
            }
            [weakSelf.tableView reloadData];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您提交的信息有误,无法获取文件列表" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"重新提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ConfigViewController *configVC = [[ConfigViewController alloc]init];
                configVC.type = ConfigVCTypeReSubmit;
                __weak typeof(configVC) weakConfigVC = configVC;
                configVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:configVC animated:YES];
                [configVC setFinishReSubmitBlock:^{
                    [weakConfigVC.navigationController popToRootViewControllerAnimated:YES];
                    [weakSelf showAlert:@"请重新打开App"];
                }];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }]];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)requestMoreData{
    kWSelf;
    NSDictionary *params = @{@"uuid":[AppHelper uuid],
                             @"marker":self.marker};
    [[BaseNetworking shareInstance] GET:_url dict:params succeed:^(id data) {
        [self.tableView.mj_footer endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
            NSDictionary *resultDic = (NSDictionary *)data;
            NSArray *resultArray = resultDic[@"data"][@"data"];
            if ([resultDic[@"data"][@"marker"] isKindOfClass:[NSString class]] && resultDic[@"data"][@"marker"] !=NULL) {
                [weakSelf.marker setString:resultDic[@"data"][@"marker"]];
            }
            for (NSInteger i = 0; i<resultArray.count; i++) {
                FileDetailModel *model = [FileDetailModel modelWithDict:resultArray[i]];
                [weakSelf.dataArray addObject:model];
            }
            if (resultArray.count < 20) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [weakSelf.tableView reloadData];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您提交的信息有误,无法获取文件列表" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"重新提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ConfigViewController *configVC = [[ConfigViewController alloc]init];
                configVC.type = ConfigVCTypeReSubmit;
                __weak typeof(configVC) weakConfigVC = configVC;
                [weakSelf.navigationController pushViewController:configVC animated:YES];
                [configVC setFinishReSubmitBlock:^{
                    [weakConfigVC.navigationController popToRootViewControllerAnimated:YES];
                    [weakSelf showAlert:@"请重新打开App"];
                }];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }]];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    FileDetailModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    [cell setTapOpenButtonBlock:^(NSString *fileUrl) {
        NSArray *fileUrlArray = [model.key componentsSeparatedByString:@"."];
        NSString *suffixString = fileUrlArray.lastObject;
        if ([suffixString isEqualToString:@"mp4"] || [suffixString isEqualToString:@"mov"] || [suffixString isEqualToString:@"avi"] || [suffixString isEqualToString:@"m4v"] || [suffixString isEqualToString:@"mp3"]) {
            MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:fileUrl];
            AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
            playerVC.player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:info.file]];
            [playerVC.player play];
            UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
            [vc presentViewController:playerVC animated:YES completion:nil];
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FileDetailModel *model = self.dataArray[indexPath.row];
    NSString *fileUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:fileUrl];
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.dataArray.count];
            for (int i = 0; i<self.dataArray.count; i++) {
                //替换为中等尺寸图片
                FileDetailModel *detailModel = self.dataArray[i];
                NSString *url = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[detailModel.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];;
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:url]; //图片路径
                photo.srcImageView = nil; //来源于哪个UIImageView
                [photos addObject:photo];
            }
            //显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = indexPath.row; //弹出相册时显示的第一张图片是？
            browser.photos = photos; //设置所有的图片
            [browser show];
            
        }
            break;
        case 1:
        {
            //本地路径
            NSString *videoCacheDir = [NSHomeDirectory() stringByAppendingPathComponent:kVideoDetailLocalPrefix];
            NSString *lastPathComponent = [NSString stringWithFormat:@"%@.mov", model.key];
            NSString *videoPath = [videoCacheDir stringByAppendingPathComponent:lastPathComponent];
            if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
//                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
//                playerVC.player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:videoPath]];
//                [playerVC.player play];
//                [self presentViewController:playerVC animated:YES completion:nil];
                FDVideoPlayerController *playerVC = [[FDVideoPlayerController alloc]initWithURL:[NSURL fileURLWithPath:videoPath]];
                playerVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:playerVC animated:YES];
            }else{
                if (info.state == MJDownloadStateCompleted) {
                    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:fileUrl];
//                    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
//                    playerVC.player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:info.file]];
//                    [playerVC.player play];
//                    [self presentViewController:playerVC animated:YES completion:nil];
                    FDVideoPlayerController *playerVC = [[FDVideoPlayerController alloc]initWithURL:[NSURL fileURLWithPath:info.file]];
                    playerVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:playerVC animated:YES];
                }else{
//                    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
//                    playerVC.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:fileUrl]];
//                    [playerVC.player play];
//                    [self presentViewController:playerVC animated:YES completion:nil];
                    FDVideoPlayerController *playerVC = [[FDVideoPlayerController alloc]initWithURL:[NSURL URLWithString:fileUrl]];
                    playerVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:playerVC animated:YES];
                }
            }
        }
            break;
        case 2:
        {
            if (info.state == MJDownloadStateCompleted) {
                MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:fileUrl];
                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
                playerVC.player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:info.file]];
                [playerVC.player play];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                                       error:nil];
                [self presentViewController:playerVC animated:YES completion:nil];
            }else{
                AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
                playerVC.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:fileUrl]];
                [playerVC.player play];
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                                       error:nil];
                [self presentViewController:playerVC animated:YES completion:nil];
            }
        }
            break;
        case 3:
        {
            WebViewController *webVC = [[WebViewController alloc]init];
            webVC.url = fileUrl;
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    FileDetailModel *model = self.dataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否删除此文件？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //do nothing
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删除视频
            kWSelf;
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            NSDictionary *params = @{@"uuid":[AppHelper uuid],
                                     @"key":model.key
                                     };
            [[BaseNetworking shareInstance] GET:kDeleteFileUrl dict:params succeed:^(id data) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }else{
                    
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
            }];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NSMutableString *)marker{
    if (!_marker) {
        _marker = [[NSMutableString alloc]init];
    }
    return _marker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
