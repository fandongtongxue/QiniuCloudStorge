//
//  QiniuUploadManager.h
//  Qiniu
//
//  Created by 范东 on 16/8/8.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiniuUploadManager : NSObject

+ (QiniuUploadManager *)manager;

- (void)getUploadTokenSuccessBlock:(void(^)(NSString *token))successBlock failBlock:(void(^)(NSError *error))failBlock;

- (void)upload:(NSData *)data Key:(NSString *)key Token:(NSString *)token SuccessBlock:(void(^)(NSDictionary *info))successBlock failBlock:(void(^)(NSError *error))failBlock ProgressBlock:(void(^)(float percent))progressBlock;

@end
