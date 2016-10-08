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

#define kNavigationBarHeight 44
#define kStatusBarHeight     20
#define kBottomBarHeight     49

#define kAppVersion                          ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#define kSystemVersion                       [[[UIDevice currentDevice] systemVersion] floatValue]

#define kFileDetailUrlPrefix @"http://7xqh0l.dl1.z0.glb.clouddn.com/"
#define kVideoDetailLocalPrefix @"Library/Caches/UploadVideo/"

#define kLocationKey @"kLocationKey"

#define kAliyunAnaliticsKey            @"23464240"
#define kAliyunAnaliticsSecret        @"f4b5faa3c9abc665ae980e4cfbe30755"
#define kAliyunAnalitics                   [ALBBMANAnalytics getInstance]

#endif /* AppDefine_h */
