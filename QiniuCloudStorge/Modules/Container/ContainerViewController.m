//
//  ContainerViewController.m
//  Qiniu
//
//  Created by 范东 on 16/9/21.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "ContainerViewController.h"
#import "ConfigViewController.h"
#import "RootTabBarController.h"

@interface ContainerViewController ()

@property (nonatomic, strong) ConfigViewController *configVC;
@property (nonatomic, strong) RootTabBarController *tabBarVC;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubVC];
}

- (void)initSubVC{
    if ([AppHelper isConfig]) {
        [self initRootTabBarVC];
    }else{
        if (_configVC == nil) {
            ConfigViewController *configVC = [[ConfigViewController alloc]init];
            self.configVC = configVC;
        }
        __weak typeof(self) weakSelf = self;
        [self.configVC setFinishBlock:^{
            [weakSelf.configVC dismissViewControllerAnimated:YES completion:nil];
            [weakSelf transitionFromViewController:weakSelf.configVC toViewController:weakSelf.tabBarVC duration:0.25 options:UIViewAnimationOptionAutoreverse animations:nil completion:nil];
        }];
        [self addChildViewController:self.configVC];
        [self.view addSubview:self.configVC.view];
    }
}

- (void)initRootTabBarVC{
    if (_tabBarVC == nil) {
        RootTabBarController *tabBarVC = [[RootTabBarController alloc]init];
        [self addChildViewController:tabBarVC];
        [self.view addSubview:tabBarVC.view];
        self.tabBarVC = tabBarVC;
    }
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
