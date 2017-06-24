//
//  FDPhotoBrowserView.m
//  QiniuCloudStorge
//
//  Created by fandong on 2017/6/24.
//  Copyright © 2017年 范东. All rights reserved.
//

#import "FDPhotoBrowserView.h"
#import "FDPhotoBrowserImageView.h"
#import "FDPhotoBrowserItem.h"

@interface FDPhotoBrowserView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation FDPhotoBrowserView

- (instancetype)initWithFrame:(CGRect)frame ItemArray:(NSArray *)itemArray CurrentIndex:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
        [self initSubviewsWithItemArray:itemArray CurrentIndex:index];
    }
    return self;
}

- (void)initSubviewsWithItemArray:(NSArray *)itemArray CurrentIndex:(NSInteger)index{
    //背景
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //滚动视图
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //图片
    for (NSInteger i = 0; i < itemArray.count; i++) {
        FDPhotoBrowserItem *item = itemArray[i];
        FDPhotoBrowserImageView *imageView = [[FDPhotoBrowserImageView alloc]initWithFrame:CGRectZero];
        [self.scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left).offset(i * kScreenSizeWidth);
//            make.right.equalTo(self.scrollView.mas_right).offset(i * kScreenSizeWidth);
            make.top.equalTo(self.scrollView.mas_top);
//            make.centerY.equalTo(self.scrollView).offset(kScreenSizeHeight / 2);
//            make.bottom.equalTo(self.scrollView.mas_bottom);
            make.width.mas_lessThanOrEqualTo(self.scrollView.mas_width);
            make.height.mas_lessThanOrEqualTo(self.scrollView.mas_height);
        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:nil options:SDWebImageProgressiveDownload];
        [imageView setSingleTapBlock:^{
            [self dismiss];
        }];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenSizeWidth * itemArray.count, kScreenSizeHeight);
    self.scrollView.contentOffset = CGPointMake(kScreenSizeWidth * index, 0);
    //PageControl
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(15);
        make.right.equalTo(self.scrollView.mas_right).offset(-15);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-15);
    }];
    self.pageControl.numberOfPages = 20;
    self.pageControl.currentPage = index % 20;
}

- (void)show:(UIView *)superView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        //do nothing
    }];
}

- (void)dismiss{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Lazy Load
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor blackColor];
    }
    return _backView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
//        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    }
    return _pageControl;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / kScreenSizeWidth;
    self.pageControl.currentPage = index % 20;
}

@end
