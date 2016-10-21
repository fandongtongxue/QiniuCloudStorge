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

@interface VoiceRecognizeViewController ()<IFlyRecognizerViewDelegate>

@property (nonatomic, strong)UILabel *resultLabel;
@property (nonatomic, strong)IFlyRecognizerView *iflyRecognizerView;

@end

@implementation VoiceRecognizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"语音识别";
    [self initSubviews];
}

- (void)initSubviews{
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:@"asrview.pcm " forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    UILabel *resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenSizeWidth - 20, kScreenSizeHeight - 140)];
    resultLabel.numberOfLines = 0;
    resultLabel.backgroundColor = [UIColor cyanColor];
    resultLabel.text = @"识别结果";
    [self.view addSubview:resultLabel];
    self.resultLabel = resultLabel;
    
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, resultLabel.bottom + 10, kScreenSizeWidth / 3, 40)];
    startBtn.centerX = self.view.centerX;
    [startBtn setTitle:@"开始识别" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setBackgroundColor:[UIColor blackColor]];
    [startBtn addTarget:self action:@selector(startRecoginze:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
}

- (void)startRecoginze:(UIButton *)sender{
    //启动识别服务
    [_iflyRecognizerView start];
}

/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    DLOG(@"语音识别结果:%@",resultArray);
    NSMutableString *resultString = [NSMutableString stringWithString:@"识别结果"];
    for (NSDictionary *dict in resultArray) {
        [resultString stringByAppendingString:[NSString stringWithFormat:@"%@",dict]];
    }
    self.resultLabel.text = resultString;
}

/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    DLOG(@"语音识别失败:%@",error);
    self.resultLabel.text = [NSString stringWithFormat:@"语音识别错误%@",error];
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
