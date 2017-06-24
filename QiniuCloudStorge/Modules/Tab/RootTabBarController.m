//
//  RootTabBarController.m
//  Live
//
//  Created by 范东 on 16/8/11.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootNavigationController.h"
#import "MoreViewController.h"
#import "AllViewController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubVC];
}

- (void)initSubVC{
    
    UITabBarItem *allItem = [[UITabBarItem alloc]initWithTitle:@"全部" image:[UIImage imageNamed:@"tab_img_image"] selectedImage:[UIImage imageNamed:@"tab_img_file"]];
    UITabBarItem *moreItem =  [[UITabBarItem alloc]initWithTitle:@"更多" image:[UIImage imageNamed:@"tab_img_more"] selectedImage:[UIImage imageNamed:@"tab_img_more"]];
    
    AllViewController *allVC = [[AllViewController alloc]init];
    RootNavigationController *allNav = [[RootNavigationController alloc]initWithRootViewController:allVC];
    allNav.tabBarItem = allItem;
    
    MoreViewController *moreVC = [[MoreViewController alloc]init];
    RootNavigationController *moreNav = [[RootNavigationController alloc]initWithRootViewController:moreVC];
    moreNav.tabBarItem = moreItem;
    
    self.viewControllers = @[allNav,moreNav];
    
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
