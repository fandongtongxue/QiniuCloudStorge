//
//  FDPhotoBrowserImageView.m
//  QiniuCloudStorge
//
//  Created by fandong on 2017/6/24.
//  Copyright © 2017年 范东. All rights reserved.
//

#import "FDPhotoBrowserImageView.h"

@interface FDPhotoBrowserImageView ()

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
    self.contentMode = UIViewContentModeScaleToFill;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}

- (void)dismiss{
    if (_singleTapBlock) {
        _singleTapBlock();
    }
}

- (void)setSingleTapBlock:(singleTapBlock)block{
    _singleTapBlock = block;
}

@end
