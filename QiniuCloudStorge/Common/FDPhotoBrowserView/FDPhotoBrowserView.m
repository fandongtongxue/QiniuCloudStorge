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
//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FDPhotoBrowserImageView *leftImageView;
@property (nonatomic, strong) FDPhotoBrowserImageView *middleImageView;
@property (nonatomic, strong) FDPhotoBrowserImageView *rightImageView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation FDPhotoBrowserView

- (instancetype)initWithFrame:(CGRect)frame ItemArray:(NSArray *)itemArray CurrentIndex:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
        self.itemArray = itemArray;
        _currentIndex = index;
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
//    for (NSInteger i = 0; i < itemArray.count; i++) {
//        FDPhotoBrowserItem *item = itemArray[i];
//        FDPhotoBrowserImageView *imageView = [[FDPhotoBrowserImageView alloc]initWithFrame:CGRectZero];
//        [self.scrollView addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.scrollView.mas_left).offset(i * kScreenSizeWidth);
//            make.top.equalTo(self.scrollView.mas_top);
//            make.width.mas_lessThanOrEqualTo(self.scrollView.mas_width);
//            make.height.mas_lessThanOrEqualTo(self.scrollView.mas_height);
//        }];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:nil options:SDWebImageProgressiveDownload];
//        [imageView setSingleTapBlock:^{
//            [self dismiss];
//        }];
//    }
    FDPhotoBrowserImageView *leftImageView = [[FDPhotoBrowserImageView alloc]initWithFrame:CGRectZero];
    [leftImageView setSingleTapBlock:^{
        [self dismiss];
    }];
    [self.scrollView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.scrollView.mas_top);
        make.width.mas_lessThanOrEqualTo(self.scrollView.mas_width);
        make.height.mas_lessThanOrEqualTo(self.scrollView.mas_height);
    }];
    FDPhotoBrowserImageView *middleImageView = [[FDPhotoBrowserImageView alloc]initWithFrame:CGRectZero];
    [middleImageView setSingleTapBlock:^{
        [self dismiss];
    }];
    [self.scrollView addSubview:middleImageView];
    [middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(kScreenSizeWidth);
        make.top.equalTo(self.scrollView.mas_top);
        make.width.mas_lessThanOrEqualTo(self.scrollView.mas_width);
        make.height.mas_lessThanOrEqualTo(self.scrollView.mas_height);
    }];
    FDPhotoBrowserImageView *rightImageView = [[FDPhotoBrowserImageView alloc]initWithFrame:CGRectZero];
    [rightImageView setSingleTapBlock:^{
        [self dismiss];
    }];
    [self.scrollView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(kScreenSizeWidth * 2);
        make.top.equalTo(self.scrollView.mas_top);
        make.height.mas_lessThanOrEqualTo(self.scrollView.mas_height);
    }];
    
    self.leftImageView = leftImageView;
    self.middleImageView = middleImageView;
    self.rightImageView = rightImageView;
    
    FDPhotoBrowserItem *leftItem = itemArray[index];
    FDPhotoBrowserItem *middleItem = itemArray[index + 1];
    FDPhotoBrowserItem *rightItem = itemArray[index + 2];
    
    [self.leftImageView setImageWithURL:leftItem.url];
    [self.middleImageView setImageWithURL:middleItem.url];
    [self.rightImageView setImageWithURL:rightItem.url];
    
    self.scrollView.contentSize = CGSizeMake(kScreenSizeWidth * 3, kScreenSizeHeight);
    self.scrollView.contentOffset = CGPointMake(kScreenSizeWidth * (index % 3), 0);
    //PageControl
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(15);
        make.right.equalTo(self.scrollView.mas_right).offset(-15);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-15);
    }];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = index % 3;
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

//- (UICollectionView *)collectionView{
//    if (!_collectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.minimumLineSpacing = 0;
//        layout.minimumInteritemSpacing = 0;
//        layout.itemSize = CGSizeMake(kScreenSizeWidth, kScreenSizeHeight);
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//    }
//    return _collectionView;
//}

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
    self.pageControl.currentPage = index % 3;
    DLOG(@"当前页码:%ld",_currentIndex);
//    if (scrollView.contentOffset.x == kScreenSizeWidth) {
//        _currentIndex ++;
//        [self resetImages];
//    }else if (scrollView.contentOffset.x == kScreenSizeWidth * 2){
//        _currentIndex +=2;
//        [self resetImages];
//    }
}

#pragma mark - Aid
- (void)resetImages{
    FDPhotoBrowserItem *leftItem = self.itemArray[_currentIndex - 1];
    FDPhotoBrowserItem *middleItem = self.itemArray[_currentIndex];
    FDPhotoBrowserItem *rightItem = self.itemArray[_currentIndex + 1];
    [self.leftImageView setImageWithURL:leftItem.url];
    [self.middleImageView setImageWithURL:middleItem.url];
    [self.rightImageView setImageWithURL:rightItem.url];
}

@end
