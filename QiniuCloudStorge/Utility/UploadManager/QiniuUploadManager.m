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

#define kGetTokenUrl @"http://fandong.me/upload/examples/upload_token.php"

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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kGetTokenUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *token = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        successBlock(token);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

- (void)upload:(NSData *)data Key:(NSString *)key Token:(NSString *)token SuccessBlock:(void(^)(NSDictionary *info))successBlock failBlock:(void(^)(NSError *error))failBlock{
    QNUploadManager *manager = [[QNUploadManager alloc]init];
    [manager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"七牛上传完成后字典:%@",resp);
        successBlock(resp);
    } option:nil];
}

@end
