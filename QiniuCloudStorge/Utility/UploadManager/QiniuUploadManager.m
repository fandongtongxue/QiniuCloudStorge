//
//  QiniuUploadManager.m
//  Qiniu
//
//  Created by 范东 on 16/8/8.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "QiniuUploadManager.h"
#import "AFNetworking.h"
#import <QiniuSDK.h>

#define kGetTokenUrl @"http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/upload_token.php"

@implementation QiniuUploadManager

+ (QiniuUploadManager *)manager{
    static QiniuUploadManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)getUploadTokenSuccessBlock:(void(^)(NSString *token))successBlock failBlock:(void(^)(NSError *error))failBlock{
    NSDictionary *params = @{@"uuid":[AppHelper uuid]};
    [[BaseNetworking shareInstance] GET:kGetTokenUrl dict:params succeed:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
            successBlock([[(NSDictionary *)data objectForKey:@"data"] objectForKey:@"token"]);
        }else{
            failBlock([NSError errorWithDomain:@"com.QiniuCloudStorge" code:1 userInfo:@{@"info":@"获取Token失败"}]);
        }
    } failure:^(NSError *error) {
        failBlock(error);
    }];
}

- (void)upload:(NSData *)data Key:(NSString *)key Token:(NSString *)token SuccessBlock:(void(^)(NSDictionary *info))successBlock failBlock:(void(^)(NSError *error))failBlock ProgressBlock:(void(^)(float percent))progressBlock{
    QNUploadOption *option = [[QNUploadOption alloc]initWithProgressHandler:^(NSString *key, float percent) {
        progressBlock(percent);
    }];
    QNUploadManager *manager = [[QNUploadManager alloc]init];
    [manager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        DLOG(@"七牛上传完成后字典:%@",resp);
        if (resp) {
            successBlock(resp);
        }else{
            failBlock([NSError errorWithDomain:@"com.QiniuCloudStorge" code:1 userInfo:@{@"info":@"上传失败"}]);
        }
    } option:option];
}

@end
