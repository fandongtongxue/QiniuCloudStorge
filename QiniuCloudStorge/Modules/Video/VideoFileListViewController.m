//
//  VideoFileListViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "VideoFileListViewController.h"
#import "ImageFileDetailCell.h"
#import "ImageFileDetailModel.h"
#import "ConfigViewController.h"

#define kGetFileListUrl @"http://fandong.me/App/QiniuCloudStorge/php-sdk-master/examples/list_file_video.php"

static NSString * const cellID = @"videoCellID";

@interface VideoFileListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation VideoFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initTableView];
    [self requestData];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"文件列表";
}

- (void)initTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSizeWidth, kScreenSizeHeight - kNavigationBarHeight - kStatusBarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ImageFileDetailCell class] forCellReuseIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)requestData{
    kWSelf;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    NSDictionary *params = @{@"uuid":[AppHelper uuid]
                             };
    [[BaseNetworking shareInstance] GET:kGetFileListUrl dict:params succeed:^(id data) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
            NSDictionary *resultDic = (NSDictionary *)data;
            NSArray *resultArray = resultDic[@"data"];
            [weakSelf handleSuccess:resultArray];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您提交的信息有误,无法获取文件列表" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"重新提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ConfigViewController *configVC = [[ConfigViewController alloc]init];
                configVC.type = ConfigVCTypeReSubmit;
                __weak typeof(configVC) weakConfigVC = configVC;
                [weakSelf.navigationController pushViewController:configVC animated:YES];
                [configVC setFinishReSubmitBlock:^{
                    [weakConfigVC.navigationController popToRootViewControllerAnimated:YES];
                    [self showAlert:@"请重新打开App"];
                }];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)handleSuccess:(NSArray *)resultArray{
    for (NSInteger i = 0; i<resultArray.count; i++) {
        ImageFileDetailModel *model = [ImageFileDetailModel modelWithDict:resultArray[i]];
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    ImageFileDetailModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageFileDetailModel *model = self.dataArray[indexPath.row];
    NSString *videoUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:videoUrl]];
    [self presentMoviePlayerViewControllerAnimated:playerVC];
    [playerVC.moviePlayer play];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate{
    //是否允许转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //viewController所支持的全部旋转方向
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //viewController初始显示的方向
    return UIInterfaceOrientationPortrait;
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
