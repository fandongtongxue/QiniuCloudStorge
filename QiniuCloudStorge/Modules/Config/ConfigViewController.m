//
//  ConfigViewController.m
//  Qiniu
//
//  Created by 范东 on 16/9/21.
//  Copyright © 2016年 范东. All rights reserved.
//

#define kSubmitURL        @"http://fandong.me/App/QiniuCloudStorge/Submit/submit.php"
#define kConfigTextFieldBaseTag 100

#import "ConfigViewController.h"

@interface ConfigViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *appKeyTextField;
@property (nonatomic, strong) UITextField *appSecretTextField;
@property (nonatomic, strong) UITextField *appBucketTextField;

@property (nonatomic, copy) finishBlock finishBlock;

@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
}

- (void)initSubviews{
    UITextField *appKeyTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 64 + 20, kScreenSizeWidth - 40, 40)];
    appKeyTextField.placeholder = @"输入你的七牛云存储AppKey";
    appKeyTextField.layer.borderWidth = 1;
    appKeyTextField.layer.borderColor = [UIColor blackColor].CGColor;
    appKeyTextField.font = [UIFont systemFontOfSize:15];
    appKeyTextField.textColor = [UIColor blackColor];
    appKeyTextField.delegate = self;
    appKeyTextField.tag = kConfigTextFieldBaseTag;
    [self.view addSubview:appKeyTextField];
    self.appKeyTextField = appKeyTextField;
    
    UITextField *appSecretTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(appKeyTextField.frame) + 20, kScreenSizeWidth - 40, 40)];
    appSecretTextField.placeholder = @"输入你的七牛云存储AppSecret";
    appSecretTextField.layer.borderWidth = 1;
    appSecretTextField.layer.borderColor = [UIColor blackColor].CGColor;
    appSecretTextField.font = [UIFont systemFontOfSize:15];
    appSecretTextField.textColor = [UIColor blackColor];
    appSecretTextField.delegate = self;
    appSecretTextField.tag = kConfigTextFieldBaseTag + 1;
    [self.view addSubview:appSecretTextField];
    self.appSecretTextField = appSecretTextField;
    
    UITextField *appBucketTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(appSecretTextField.frame) + 20, kScreenSizeWidth - 40, 40)];
    appBucketTextField.placeholder = @"输入你的七牛云存储Bucket";
    appBucketTextField.layer.borderWidth = 1;
    appBucketTextField.layer.borderColor = [UIColor blackColor].CGColor;
    appBucketTextField.font = [UIFont systemFontOfSize:15];
    appBucketTextField.textColor = [UIColor blackColor];
    appBucketTextField.delegate = self;
    appBucketTextField.tag = kConfigTextFieldBaseTag + 2;
    [self.view addSubview:appBucketTextField];
    self.appBucketTextField = appBucketTextField;
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(appBucketTextField.frame) + 20, kScreenSizeWidth - 40, 40)];
    [confirmBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor blackColor]];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)confirm{
    if (self.appKeyTextField.text.length == 0) {
        [self showAlert:@"AppKey不能为空"];
        return;
    }
    if (self.appSecretTextField.text.length == 0) {
        [self showAlert:@"AppSecret不能为空"];
        return;
    }
    if (self.appBucketTextField.text.length == 0) {
        [self showAlert:@"BucketName不能为空"];
        return;
    }
    NSDictionary *dict = @{@"appKey":self.appKeyTextField.text,
                                          @"appSecret":self.appSecretTextField.text,
                                          @"bucketName":self.appBucketTextField.text};
    [BaseNetworking shareInstance].responseContentType = ResponseContentTypeText;
    [[BaseNetworking shareInstance] POST:kSubmitURL dict:dict succeed:^(id data) {
        NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self showAlert:resultStr];
        if (_finishBlock) {
            _finishBlock();
        }
    } failure:^(NSError *error) {
        [self showAlert:[NSString stringWithFormat:@"%@",error]];
    }];
}

#pragma mark - 关于UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)showAlert:(NSString *)alertString{
    if (IOS8_OR_LATER) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:alertString message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)setFinishBlock:(finishBlock)block{
    _finishBlock = block;
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
