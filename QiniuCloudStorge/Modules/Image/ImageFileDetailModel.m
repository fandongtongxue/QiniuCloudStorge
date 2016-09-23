//
//  ImageFileDetailModel.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "ImageFileDetailModel.h"

@implementation ImageFileDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    NSLog(@"未定义Key:%@",key);
}


@end
