//
//  RootTabBarController.m
//  Live
//
//  Created by 范东 on 16/8/11.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "RootTabBarController.h"
#import "MusicViewController.h"
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
    
    UITabBarItem *imageItem = [[UITabBarItem alloc]initWithTitle:@"图片" image:[UIImage imageNamed:@"tab_img_image"] selectedImage:[UIImage imageNamed:@"tab_img_image"]];
    UITabBarItem *musicItem = [[UITabBarItem alloc]initWithTitle:@"音乐" image:[UIImage imageNamed:@"tab_img_music"] selectedImage:[UIImage imageNamed:@"tab_img_music"]];
    UITabBarItem *videoItem = [[UITabBarItem alloc]initWithTitle:@"视频" image:[UIImage imageNamed:@"tab_img_video"] selectedImage:[UIImage imageNamed:@"tab_img_video"]];
    UITabBarItem *moreItem =  [[UITabBarItem alloc]initWithTitle:@"更多" image:[UIImage imageNamed:@"tab_img_more"] selectedImage:[UIImage imageNamed:@"tab_img_more"]];
    
    ImageViewController *imageVC = [[ImageViewController alloc]init];
    RootNavigationController *imageNav = [[RootNavigationController alloc]initWithRootViewController:imageVC];
    imageNav.tabBarItem = imageItem;
    
    MusicViewController *musicVC = [[MusicViewController alloc]init];
    RootNavigationController *musicNav = [[RootNavigationController alloc]initWithRootViewController:musicVC];
    musicNav.tabBarItem = musicItem;
    
    VideoViewController *videoVC = [[VideoViewController alloc]init];
    RootNavigationController *videoNav = [[RootNavigationController alloc]initWithRootViewController:videoVC];
    videoNav.tabBarItem = videoItem;
    
    MoreViewController *moreVC = [[MoreViewController alloc]init];
    RootNavigationController *moreNav = [[RootNavigationController alloc]initWithRootViewController:moreVC];
    moreNav.tabBarItem = moreItem;
    
    self.viewControllers = @[imageNav,musicNav,videoNav,moreNav];
    
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
