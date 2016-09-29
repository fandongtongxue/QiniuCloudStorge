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
#import "VideoFileDetailViewController.h"

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
            [self showAlert:@"您所提交的相关信息不正确"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [self showAlert:[NSString stringWithFormat:@"%@",error]];
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
    VideoFileDetailViewController *detailVC = [[VideoFileDetailViewController alloc]init];
    detailVC.key = model.key;
    [self.navigationController pushViewController:detailVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
