//
//  FDPhotoBrowserImageView.h
//  QiniuCloudStorge
//
//  Created by fandong on 2017/6/24.
//  Copyright © 2017年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^singleTapBlock)(void);

@interface FDPhotoBrowserImageView : UIView

/**
 设置单击手势回调
 
 @param block block
 */
- (void)setSingleTapBlock:(singleTapBlock)block;

- (void)setImageWithURL:(NSString *)url;

@end
