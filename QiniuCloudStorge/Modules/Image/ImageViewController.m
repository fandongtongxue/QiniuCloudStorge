//
//  ViewController.m
//  QiniuDemo
//
//  Created by 范东 on 16/7/21.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "ImageViewController.h"
#import "QiniuUploadManager.h"
#import "ImageFileListViewController.h"

@interface ImageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) BOOL isUploading;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initNavigationBar];
    [self initSubViews];
}

#pragma mark - UI

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"图片列表" style:UIBarButtonItemStylePlain target:self action:@selector(toFileListVC)];
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
    [selectImageButton setTitle:@"选取图片" forState:UIControlStateNormal];
    [selectImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [selectImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectImageButton setBackgroundColor:[UIColor blackColor]];
    selectImageButton.layer.cornerRadius = 5;
    selectImageButton.clipsToBounds = YES;
    [selectImageButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectImageButton];
    
    UIButton *uploadImageButton = [[UIButton alloc]initWithFrame:CGRectMake(selectImageButton.right + 10, currentImageView.bottom + 10, (kScreenSizeWidth - 30)/2, 40)];
    [uploadImageButton setTitle:@"上传图片" forState:UIControlStateNormal];
    [uploadImageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [uploadImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadImageButton setBackgroundColor:[UIColor blackColor]];
    uploadImageButton.layer.cornerRadius = 5;
    uploadImageButton.clipsToBounds = YES;
    [uploadImageButton addTarget:self action:@selector(uploadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadImageButton];
}

#pragma mark - Action

-(void)selectImage{
    kWSelf;
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [[UIAlertController alloc]init];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.view.backgroundColor = [UIColor whiteColor];
            [weakSelf.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.view.backgroundColor = [UIColor whiteColor];
            [weakSelf.navigationController presentViewController:imagePicker animated:YES completion:nil];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
        [actionSheet showInView:self.view];
    }
}

- (void)uploadImage{
    kWSelf;
    if (!self.currentImage) {
        [self showAlert:@"请先选择需要上传的图片"];
    }else{
        _isUploading = YES;
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [[QiniuUploadManager manager] getUploadTokenSuccessBlock:^(NSString *token) {
            NSData *data = UIImageJPEGRepresentation(self.currentImage, 1.0);
            [[QiniuUploadManager manager] upload:data Key:self.key Token:token SuccessBlock:^(NSDictionary *info) {
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

- (void)clearImage{
    if (_isUploading) {
        [self showAlert:@"上传图片中..."];
        return;
    }
    self.currentImage = nil;
    self.currentImageView.image = nil;
}

- (void)toFileListVC{
    if (_isUploading) {
        [self showAlert:@"上传图片中..."];
        return;
    }
    ImageFileListViewController *imageFileListVC = [[ImageFileListViewController alloc]init];
    imageFileListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imageFileListVC animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.currentImageView.image = info[@"UIImagePickerControllerOriginalImage"];
    self.currentImage = info[@"UIImagePickerControllerOriginalImage"];
    self.key = [NSString stringWithFormat:@"Image_%@%@",[AppHelper getPlatformString],[NSDate dateWithTimeIntervalSinceNow:3600 * 8]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
            break;
        }
        case 2:
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
