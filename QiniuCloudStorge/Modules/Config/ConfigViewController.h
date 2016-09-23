//
//  ConfigViewController.h
//  Qiniu
//
//  Created by 范东 on 16/9/21.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishBlock)();

@interface ConfigViewController : UIViewController

- (void)setFinishBlock:(finishBlock)block;

@end
