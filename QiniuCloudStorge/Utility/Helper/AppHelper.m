//
//  AppHelper.m
//  Qiniu
//
//  Created by 范东 on 16/8/8.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "AppHelper.h"
#include <sys/sysctl.h>
#include <sys/ioctl.h>

@implementation AppHelper

+ (AppHelper *)shareInstance{
    static AppHelper *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
//获取对应的机型
+ (NSString *)getPlatformString
{
    NSString *platform = [self getDeviceVersion];
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone1";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4s";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5C";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5C";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5S";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5S";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6S";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6SPlus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    
    //iPod Touch
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPodTouch";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPodTouch2";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPodTouch3";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPodTouch4";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPodTouch5";
    
    //iPad
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPadMini1";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPadMini1";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPadMini1";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPadAir";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPadAir";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPadAir";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPadMini2";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPadMini2";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPadMini2";
    
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPadMini3";
    
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPadMini3";
    
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPadMini3";
    
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPadAir2";
    
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPadAir2";
    
    if ([platform isEqualToString:@"iPhoneSimulator"] || [platform isEqualToString:@"x86_64"]) return @"iPhoneSimulator";
    
    return platform;
}

+ (NSString *)fileSize:(NSString *)size{
    float fileSize = size.floatValue;
    return [NSString stringWithFormat:@"%.2fMB",fileSize/1024/1024];
}

+ (BOOL)isConfig{
    return NO;
}

+ (NSString *)uuid{
    return @"259586d5e9c94567ab35f89b020baebe";
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" "account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""]){
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

@end
