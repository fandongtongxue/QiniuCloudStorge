//
//  RootTabBarController.m
//  Live
//
//  Created by 范东 on 16/8/11.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "RootTabBarController.h"
#import "VideoViewController.h"
#import "ImageViewController.h"
#import "MoreViewController.h"
#import "RootNavigationController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubVC];
}

- (void)initSubVC{
    
    UITabBarItem *imageItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemRecents tag:0];
    UITabBarItem *videoItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    UITabBarItem *moreItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMore tag:2];
    
    ImageViewController *imageVC = [[ImageViewController alloc]init];
    RootNavigationController *imageNav = [[RootNavigationController alloc]initWithRootViewController:imageVC];
    imageNav.tabBarItem = imageItem;
    
    VideoViewController *videoVC = [[VideoViewController alloc]init];
    RootNavigationController *videoNav = [[RootNavigationController alloc]initWithRootViewController:videoVC];
    videoNav.tabBarItem = videoItem;
    
    MoreViewController *moreVC = [[MoreViewController alloc]init];
    RootNavigationController *moreNav = [[RootNavigationController alloc]initWithRootViewController:moreVC];
    moreNav.tabBarItem = moreItem;
    
    self.viewControllers = @[imageNav,videoNav,moreNav];
    
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
