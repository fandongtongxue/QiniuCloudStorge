//
//  AppDefine.h
//  Qiniu
//
//  Created by 范东 on 16/8/8.
//  Copyright © 2016年 范东. All rights reserved.
//

#ifndef AppDefine_h
#define AppDefine_h

#define kWSelf __weak __typeof(self)weakSelf = self

#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )

#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define kScreenSizeHeight                    ([[UIScreen mainScreen] bounds].size.height)
#define kScreenSizeWidth                     ([[UIScreen mainScreen] bounds].size.width)

#define MIN_WIDTH MIN(kScreenSizeWidth,kScreenSizeHeight)
#define MAX_WIDTH MAX(kScreenSizeWidth,kScreenSizeHeight)

#define kNavigationBarHeight  44
#define kStatusBarHeight         [[UIApplication sharedApplication] statusBarFrame].size.height
#define kBottomBarHeight       49

#define kAppVersion                          ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#define kSystemVersion                       [[[UIDevice currentDevice] systemVersion] floatValue]

#define kFileDetailUrlPrefix @"http://oht4nlntk.bkt.clouddn.com/"
#define kDeleteFileUrl @"http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/deleteFile.php"
#define kVideoDetailLocalPrefix @"Library/Caches/UploadVideo/"

#define kLocationKey @"kLocationKey"

#define kAliyunAnaliticsKey            @"23464240"
#define kAliyunAnaliticsSecret        @"f4b5faa3c9abc665ae980e4cfbe30755"
#define kAliyunAnalitics                   [ALBBMANAnalytics getInstance]

//Debug日志
#define OPEN_LOG
#ifdef    OPEN_LOG
#define DLOG(fmt, ...)                        NSLog((@"[Line %d] %s\r\n" fmt), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__);
#define DLOG_POINT(fmt, Point, ...)           NSLog((@"[Line %d] %s" fmt @" Point :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromCGPoint(Point));
#define DLOG_SIZE(fmt, Size, ...)             NSLog((@"[Line %d] %s" fmt @" size :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromCGSize(Size));
#define DLOG_RECT(fmt, Rect, ...)             NSLog((@"[Line %d] %s" fmt @" Rect :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromCGRect(Rect));
#define DLOG_EDGEINSET(fmt, EdgeInsets, ...)  NSLog((@"[Line %d] %s" fmt @" EdgeInsets :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromUIEdgeInsets(EdgeInsets));
#define DLOG_OFFSET(fmt, Offset, ...)         NSLog((@"[Line %d] %s" fmt @" Offset :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromUIOffset(Offset));
#define DLOG_CLASS(fmt, Class, ...)           NSLog((@"[Line %d] %s" fmt @" Class :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromClass(Class));
#define DLOG_SELECTOR(fmt, Selector, ...)     NSLog((@"[Line %d] %s" fmt @" Selector :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromSelector(Selector));
#define DLOG_RANGE(fmt, Range, ...)           NSLog((@"[Line %d] %s" fmt @" Range :%@"), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__, NSStringFromRange(Range));
#else
#define DLOG(fmt, ...)
#define DLOG_POINT(fmt, Point, ...)
#define DLOG_SIZE(fmt, Size, ...)
#define DLOG_RECT(fmt, Rect, ...)
#define DLOG_EDGEINSET(fmt, EdgeInsets, ...)
#define DLOG_OFFSET(fmt, Offset, ...)
#define DLOG_CLASS(fmt, Class, ...)
#define DLOG_SELECTOR(fmt, Selector, ...)
#define DLOG_RANGE(fmt, Range, ...)
#endif

#endif /* AppDefine_h */
