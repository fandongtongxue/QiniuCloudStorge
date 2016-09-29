//
//  CheckViewController.h
//  QiniuCloudStorge
//
//  Created by 范东 on 16/9/29.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishCheckBlock)(BOOL canUse);

@interface CheckViewController : UIViewController

- (void)setFinishCheckBlock:(finishCheckBlock)block;

@end
