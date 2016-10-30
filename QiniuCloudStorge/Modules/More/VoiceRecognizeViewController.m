//
//  VoiceRecognizeViewController.m
//  QiniuCloudStorge
//
//  Created by 范东 on 16/10/20.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "VoiceRecognizeViewController.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechError.h"
#import "ISRDataHelper.h"

@interface VoiceRecognizeViewController ()<IFlyRecognizerViewDelegate>

@property (nonatomic, strong)UITextView *resultTextView;

@end

@implementation VoiceRecognizeViewController{
    IFlyRecognizerView      *_iflyRecognizerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"语音识别";
    [self initNavigationBar];
    [self initSubviews];
}

- (void)initNavigationBar{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(startRecoginze:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initSubviews{
    //初始化语音
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:@"asrview.pcm " forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    UITextView *resultTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, kScreenSizeWidth - 20, kScreenSizeHeight - kStatusBarHeight - kNavigationBarHeight - 20)];
    resultTextView.backgroundColor = [UIColor whiteColor];
    resultTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    resultTextView.layer.borderWidth = 0.5;
    resultTextView.font = [UIFont systemFontOfSize:15];
    resultTextView.text = @"";
    [self.view addSubview:resultTextView];
    self.resultTextView = resultTextView;
}

- (void)startRecoginze:(UIButton *)sender{
    //启动识别服务
    [_iflyRecognizerView start];
}

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL) isLast;{
    NSDictionary *dict = resultArray[0];
    NSMutableString *resultString = [[NSMutableString alloc] init];
    for (NSString *key in dict) {
        [resultString appendFormat:@"%@",key];
    }
    NSString *resultJson = [ISRDataHelper stringFromJson:resultString];
    [self.resultTextView setText:[self.resultTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@",resultJson]]];
}

/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError:(IFlySpeechError *)errorCode{
    if (errorCode.errorCode != 0) {
        self.resultTextView.text = [NSString stringWithFormat:@"errorCode:%ld\nerrorDesc:%@\nerrorType:%ld",(long)errorCode.errorCode,errorCode.errorDesc,(long)errorCode.errorType];
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
