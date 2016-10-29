//
//  AboutViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "AboutViewController.h"
#import "ExampleWKWebViewController.h"

static NSString * const cellID = @"AboutCellID";

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initTableView];
    [self requestData];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于作者";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"0xffde00"];
    self.navigationController.navigationBar.translucent = NO;
    // 导航栏文字颜色、大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    // 设置导航栏左右按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)initTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)requestData{
    NSArray *dataArray = @[@{@"title":@"新浪微博",@"detail":@"范东同学"},@{@"title":@"GitHub",@"detail":@"范东同学"},@{@"title":@"JS交互测试",@"detail":@"范东同学"}];
    [self.dataArray addObjectsFromArray:dataArray];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    cell.detailTextLabel.text = self.dataArray[indexPath.row][@"detail"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            WebViewController *webViewController = [[WebViewController alloc]init];
            webViewController.url = @"http://weibo.com/fengzhizif2010";
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            break;
        case 1:
        {
            WebViewController *webViewController = [[WebViewController alloc]init];
            webViewController.url = @"http://github.com/fandongtongxue";
            [self.navigationController pushViewController:webViewController animated:YES];
        }
            break;
        case 2:
        {
            ExampleWKWebViewController* WKWebViewExampleController = [[ExampleWKWebViewController alloc] init];
            WKWebViewExampleController.title = @"WKWebView";
            [self.navigationController pushViewController:WKWebViewExampleController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
