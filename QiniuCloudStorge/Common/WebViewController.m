//
//  WebViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/13.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initWebView];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initWebView{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    WKWebView *wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight - kNavigationBarHeight - kStatusBarHeight) configuration:configuration];
    [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    wkWebView.UIDelegate = self;
    wkWebView.navigationDelegate = self;
    [self.view addSubview:wkWebView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    //显示网页名称
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.title = title;
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    DLOG(@"WKWebView加载出错:%@",error);
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    DLOG(@"WKWebView加载出错:%@",error);
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
