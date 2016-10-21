//
//  AppDelegate.m
//  QiniuDemo
//
//  Created by 范东 on 16/7/21.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "AppDelegate.h"
#import "ContainerViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[MapManager manager] application:application didFinishLaunchingWithOptions:launchOptions];
    [self registerAliyunAnalitics];
    [Fabric with:@[[Crashlytics class]]];
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"58081a9d"];
    [IFlySpeechUtility createUtility:initString];
    ContainerViewController *containerVC = [[ContainerViewController alloc]init];
    self.window.rootViewController = containerVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerAliyunAnalitics{
    // 获取MAN服务
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    // 打开调试日志，线上版本建议关闭
     [man turnOnDebug];
    // 初始化MAN
    [man initWithAppKey:kAliyunAnaliticsKey secretKey:kAliyunAnaliticsSecret];
    // appVersion默认从Info.list的CFBundleShortVersionString字段获取，如果没有指定，可在此调用setAppversion设定
    // 如果上述两个地方都没有设定，appVersion为"-"
    // 设置渠道（用以标记该app的分发渠道名称），如果不关心可以不设置即不调用该接口，渠道设置将影响控制台【渠道分析】栏目的报表展现。
    [man setChannel:@"Pgyer"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
