//
//  ConfigViewController.h
//  Qiniu
//
//  Created by 范东 on 16/9/21.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishSubmitBlock)();

@interface ConfigViewController : UIViewController

- (void)setFinishSubmitBlock:(finishSubmitBlock)block;

@end
