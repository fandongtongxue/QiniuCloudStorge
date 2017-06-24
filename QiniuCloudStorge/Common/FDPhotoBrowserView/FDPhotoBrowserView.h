//
//  FDPhotoBrowserView.h
//  QiniuCloudStorge
//
//  Created by fandong on 2017/6/24.
//  Copyright © 2017年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDPhotoBrowserView : UIView

/**
 init method
 
 @param frame 遵循Masonry
 @param itemArray 数组<FDPhotoBrowserItem>
 @param index 当前位置
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame ItemArray:(NSArray *)itemArray CurrentIndex:(NSInteger)index;


/**
 显示在父视图上
 
 @param superView 父视图
 */
- (void)show:(UIView *)superView;

@end
