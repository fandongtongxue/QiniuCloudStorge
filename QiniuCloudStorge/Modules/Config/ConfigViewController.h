//
//  ConfigViewController.h
//  Qiniu
//
//  Created by 范东 on 16/9/21.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^finishSubmitBlock)();
typedef void(^finishReSubmitBlock)();

typedef NS_ENUM(NSInteger, ConfigVCType) {
    ConfigVCTypeSubmit,
    ConfigVCTypeReSubmit,
};

@interface ConfigViewController : UIViewController

@property (nonatomic, assign) ConfigVCType type;

- (void)setFinishSubmitBlock:(finishSubmitBlock)block;
- (void)setFinishReSubmitBlock:(finishReSubmitBlock)block;

@end
