//
//  FDPhotoBrowserImageView.m
//  QiniuCloudStorge
//
//  Created by fandong on 2017/6/24.
//  Copyright © 2017年 范东. All rights reserved.
//

#import "FDPhotoBrowserImageView.h"

@interface FDPhotoBrowserImageView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) singleTapBlock singleTapBlock;

@end

@implementation FDPhotoBrowserImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self customUI];
    }
    return self;
}

- (void)customUI{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.userInteractionEnabled = YES;
}

- (void)dismiss{
    if (_singleTapBlock) {
        _singleTapBlock();
    }
}

- (void)zoomToDoubleSize{
    DLOG(@"双击两次");
}

- (void)setImageWithURL:(NSString *)url{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageProgressiveDownload];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_imageView addGestureRecognizer:singleTap];
//        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomToDoubleSize)];
//        doubleTap.numberOfTapsRequired = 2;
//        [_imageView addGestureRecognizer:doubleTap];
    }
    return _imageView;
}

- (void)setSingleTapBlock:(singleTapBlock)block{
    _singleTapBlock = block;
}

@end
