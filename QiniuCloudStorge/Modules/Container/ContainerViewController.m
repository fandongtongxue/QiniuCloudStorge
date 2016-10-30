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
#import "CheckViewController.h"

@interface ContainerViewController ()

@property (nonatomic, strong) ConfigViewController *configVC;
@property (nonatomic, strong) RootTabBarController *tabBarVC;
@property (nonatomic, strong) CheckViewController *checkVC;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubVC];
}

- (void)initSubVC{
    kWSelf;
    CheckViewController *checkVC = [[CheckViewController alloc]init];
    [checkVC setFinishCheckBlock:^(BOOL canUse) {
        if (canUse) {
            [weakSelf initRootTabBarVC];
            [weakSelf transitionFromViewController:weakSelf.checkVC toViewController:weakSelf.tabBarVC duration:0.25 options:UIViewAnimationOptionTransitionNone animations:nil completion:nil];
        }else{
            if (_configVC == nil) {
                ConfigViewController *configVC = [[ConfigViewController alloc]init];
                weakSelf.configVC = configVC;
                weakSelf.configVC.type = ConfigVCTypeSubmit;
            }
            __weak typeof(self) weakSelf = self;
            [self.configVC setFinishSubmitBlock:^{
                [weakSelf initRootTabBarVC];
                [weakSelf transitionFromViewController:weakSelf.configVC toViewController:weakSelf.tabBarVC duration:0.25 options:UIViewAnimationOptionTransitionNone animations:nil completion:nil];
            }];
            [weakSelf addChildViewController:self.configVC];
            [weakSelf.view addSubview:self.configVC.view];
        }
    }];
    [self addChildViewController:checkVC];
    [self.view addSubview:checkVC.view];
    self.checkVC = checkVC;
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
