//
//  AppHelper.h
//  Qiniu
//
//  Created by 范东 on 16/8/8.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject

+ (AppHelper *)shareInstance;

+ (NSString *)getPlatformString;

+ (NSString *)fileSize:(NSString *)size;

+ (BOOL)isConfig;

+ (NSString *)uuid;

@end
