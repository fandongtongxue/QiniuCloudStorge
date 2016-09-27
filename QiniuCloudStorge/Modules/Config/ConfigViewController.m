//
//  ConfigViewController.m
//  Qiniu
//
//  Created by 范东 on 16/9/21.
//  Copyright © 2016年 范东. All rights reserved.
//

#define kSubmitURL        @"http://fandong.me/App/QiniuCloudStorge/php-sdk-master/examples/submit.php"
#define kConfigTextFieldBaseTag 100

#import "ConfigViewController.h"

@interface ConfigViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accessKeyTextField;
@property (nonatomic, strong) UITextField *secretKeyTextField;
@property (nonatomic, strong) UITextField *bucketTextField;

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
    UITextField *accessKeyTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 64 + 20, kScreenSizeWidth - 40, 40)];
    accessKeyTextField.placeholder = @"输入你的七牛云存储AccessKey";
    accessKeyTextField.layer.borderWidth = 1;
    accessKeyTextField.layer.borderColor = [UIColor blackColor].CGColor;
    accessKeyTextField.font = [UIFont systemFontOfSize:15];
    accessKeyTextField.textColor = [UIColor blackColor];
    accessKeyTextField.delegate = self;
    accessKeyTextField.tag = kConfigTextFieldBaseTag;
    [self.view addSubview:accessKeyTextField];
    self.accessKeyTextField = accessKeyTextField;
    
    UITextField *secretKeyTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(accessKeyTextField.frame) + 20, kScreenSizeWidth - 40, 40)];
    secretKeyTextField.placeholder = @"输入你的七牛云存储SecretKey";
    secretKeyTextField.layer.borderWidth = 1;
    secretKeyTextField.layer.borderColor = [UIColor blackColor].CGColor;
    secretKeyTextField.font = [UIFont systemFontOfSize:15];
    secretKeyTextField.textColor = [UIColor blackColor];
    secretKeyTextField.delegate = self;
    secretKeyTextField.tag = kConfigTextFieldBaseTag + 1;
    [self.view addSubview:secretKeyTextField];
    self.secretKeyTextField = secretKeyTextField;
    
    UITextField *bucketTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(secretKeyTextField.frame) + 20, kScreenSizeWidth - 40, 40)];
    bucketTextField.placeholder = @"输入你的七牛云存储Bucket";
    bucketTextField.layer.borderWidth = 1;
    bucketTextField.layer.borderColor = [UIColor blackColor].CGColor;
    bucketTextField.font = [UIFont systemFontOfSize:15];
    bucketTextField.textColor = [UIColor blackColor];
    bucketTextField.delegate = self;
    bucketTextField.tag = kConfigTextFieldBaseTag + 2;
    [self.view addSubview:bucketTextField];
    self.bucketTextField = bucketTextField;
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(bucketTextField.frame) + 20, kScreenSizeWidth - 40, 40)];
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
    if (self.accessKeyTextField.text.length == 0) {
        [self showAlert:@"AppKey不能为空"];
        return;
    }
    if (self.secretKeyTextField.text.length == 0) {
        [self showAlert:@"AppSecret不能为空"];
        return;
    }
    if (self.bucketTextField.text.length == 0) {
        [self showAlert:@"BucketName不能为空"];
        return;
    }
    NSDictionary *dict = @{@"accessKey":self.accessKeyTextField.text,
                                          @"secretKey":self.secretKeyTextField.text,
                                          @"bucket":self.bucketTextField.text};
    [BaseNetworking shareInstance].responseContentType = ResponseContentTypeText;
    [[BaseNetworking shareInstance] GET:kSubmitURL dict:dict succeed:^(id data) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[resultDic objectForKey:@"status"] integerValue] == 1) {
            [self showAlert:[resultDic objectForKey:@"data"]];
            if (_finishBlock) {
                _finishBlock();
            }
        }else{
            [self showAlert:[resultDic objectForKey:@"error"]];
            if (_finishBlock) {
                _finishBlock();
            }
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
