//
//  ImageFileDetailViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "ImageFileDetailViewController.h"

@interface ImageFileDetailViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat imageViewScale;

@end

@implementation ImageFileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initSubview];
    [self requestData];
    [self initStart];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"图片详情";
}

- (void)initSubview{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight - kNavigationBarHeight - kStatusBarHeight)];
    imageView.center = self.view.center;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.multipleTouchEnabled = YES;
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImageView:)];
    [imageView addGestureRecognizer:pinchGestureRecognizer];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapImageView:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTapGestureRecognizer];
    
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

- (void)initStart{
    _imageViewScale = 1;
}

- (void)pinchImageView:(UIPinchGestureRecognizer *)pinch{
    UIView *view = pinch.view;
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinch.scale, pinch.scale);
        pinch.scale = 1;
    }else if (pinch.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.25 animations:^{
            view.transform = CGAffineTransformIdentity;
            view.center = self.view.center;
        }];
    }
}

- (void)doubleTapImageView:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    if (_imageViewScale == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            view.transform = CGAffineTransformScale(view.transform, 3, 3);
            _imageViewScale = 2;
            view.center = self.view.center;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            view.transform = CGAffineTransformIdentity;
            _imageViewScale = 1;
            view.center = self.view.center;
        }];
    }
}

- (void)requestData{
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[self.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
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
