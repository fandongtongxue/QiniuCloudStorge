//
//  CheckViewController.m
//  QiniuCloudStorge
//
//  Created by 范东 on 16/9/29.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "CheckViewController.h"

#define kCheckURL        @"http://fandong.me/App/QiniuCloudStorge/php-sdk-master/examples/check.php"

@interface CheckViewController ()

@property (nonatomic, copy) finishCheckBlock finishCheckBlock;

@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
}

- (void)initSubviews{
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    [startBtn setTitle:@"开始使用" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor blackColor]];
    [startBtn.layer setCornerRadius:25];
    [startBtn setClipsToBounds:YES];
    [startBtn setCenter:self.view.center];
    [startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    self.startBtn = startBtn;
}

- (void)startBtnAction:(UIButton *)sender{
    kWSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BaseNetworking shareInstance] GET:kCheckURL dict:@{@"uuid":[AppHelper uuid]} succeed:^(id data) {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (data) {
            NSDictionary *resultDic = (NSDictionary *)data;
            if ([resultDic[@"status"] integerValue] == 1 && resultDic) {
                if (_finishCheckBlock) {
                    _finishCheckBlock(YES);
                }
            }else{
                [self showAlert:@"数据库错误"];
                [self.startBtn setTitle:@"重试" forState:UIControlStateNormal];
            }
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"未提交审核" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"去提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (_finishCheckBlock) {
                    _finishCheckBlock(NO);
                }
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            }]];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
            [self.startBtn setTitle:@"重试" forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [self showAlert:[NSString stringWithFormat:@"%@",error]];
        [self.startBtn setTitle:@"重试" forState:UIControlStateNormal];
    }];
}

- (void)setFinishCheckBlock:(finishCheckBlock)block{
    _finishCheckBlock = block;
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
