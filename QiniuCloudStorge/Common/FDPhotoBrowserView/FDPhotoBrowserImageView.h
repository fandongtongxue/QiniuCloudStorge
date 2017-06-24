//
//  FDPhotoBrowserImageView.h
//  QiniuCloudStorge
//
//  Created by fandong on 2017/6/24.
//  Copyright © 2017年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^singleTapBlock)(void);

@interface FDPhotoBrowserImageView : UIImageView

- (void)setSingleTapBlock:(singleTapBlock)block;

@end
