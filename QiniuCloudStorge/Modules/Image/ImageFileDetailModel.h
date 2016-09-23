//
//  ImageFileDetailModel.h
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFileDetailModel : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSString *putTime;
@property (nonatomic, copy) NSNumber *fsize;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
