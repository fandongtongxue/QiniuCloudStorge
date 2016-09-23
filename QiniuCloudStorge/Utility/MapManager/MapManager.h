//
//  MapManager.h
//  Qiniu
//
//  Created by 范东 on 16/8/13.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapManager : NSObject

+ (MapManager *)manager;

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)startAlwaysUpdatingLocation;

- (void)stopUpdatingLocation;

- (void)startUpdatingLocationFinishBlock:(void(^)(NSString *location))finishBlock ErrorBlock:(void(^)(NSError *error))errorBlock;

@end
