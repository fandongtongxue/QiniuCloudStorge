//
//  ImageFileListViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "MusicViewController.h"
#import "ImageFileDetailCell.h"
#import "ImageFileDetailModel.h"
#import "ConfigViewController.h"
#import "MusicPlayerViewController.h"

#define kGetFileListUrl @"http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/list_file_music.php"

static NSString * const cellID = @"musicCellID";

@interface MusicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableString *marker;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initTableView];
    [self initRefreshUI];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"音乐";
}

- (void)initTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ImageFileDetailCell class] forCellReuseIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initRefreshUI{
    kWSelf;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_marker setString:@""];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf requestFirstPageData];
    }];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMoreData];
    }];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestFirstPageData{
    kWSelf;
    NSDictionary *params = @{@"uuid":[AppHelper uuid],
                             @"marker":self.marker};
    [[BaseNetworking shareInstance] GET:kGetFileListUrl dict:params succeed:^(id data) {
        [self.tableView.mj_header endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
            NSDictionary *resultDic = (NSDictionary *)data;
            NSArray *resultArray = resultDic[@"data"][@"data"];
            if ([resultDic[@"data"][@"marker"] isKindOfClass:[NSString class]] && resultDic[@"data"][@"marker"] !=NULL) {
                [weakSelf.marker setString:resultDic[@"data"][@"marker"]];
            }
            for (NSInteger i = 0; i<resultArray.count; i++) {
                ImageFileDetailModel *model = [ImageFileDetailModel modelWithDict:resultArray[i]];
                [weakSelf.dataArray addObject:model];
            }
            if (resultArray.count < 10) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                if (resultArray.count == 0) {
                     [JDStatusBarNotification showWithStatus:@"暂无文件" dismissAfter:1.5 styleName:JDStatusBarStyleDark];
                }
            }
            [weakSelf.tableView reloadData];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您提交的信息有误,无法获取文件列表" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"重新提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ConfigViewController *configVC = [[ConfigViewController alloc]init];
                configVC.type = ConfigVCTypeReSubmit;
                __weak typeof(configVC) weakConfigVC = configVC;
                [weakSelf.navigationController pushViewController:configVC animated:YES];
                [configVC setFinishReSubmitBlock:^{
                    [weakConfigVC.navigationController popToRootViewControllerAnimated:YES];
                    [weakSelf showAlert:@"请重新打开App"];
                }];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }]];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)requestMoreData{
    kWSelf;
    NSDictionary *params = @{@"uuid":[AppHelper uuid],
                             @"marker":self.marker};
    [[BaseNetworking shareInstance] GET:kGetFileListUrl dict:params succeed:^(id data) {
        [self.tableView.mj_footer endRefreshing];
        if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
            NSDictionary *resultDic = (NSDictionary *)data;
            NSArray *resultArray = resultDic[@"data"][@"data"];
            if ([resultDic[@"data"][@"marker"] isKindOfClass:[NSString class]] && resultDic[@"data"][@"marker"] !=NULL) {
                [weakSelf.marker setString:resultDic[@"data"][@"marker"]];
            }
            for (NSInteger i = 0; i<resultArray.count; i++) {
                ImageFileDetailModel *model = [ImageFileDetailModel modelWithDict:resultArray[i]];
                [weakSelf.dataArray addObject:model];
            }
            if (resultArray.count < 10) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [weakSelf.tableView reloadData];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您提交的信息有误,无法获取文件列表" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"重新提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ConfigViewController *configVC = [[ConfigViewController alloc]init];
                configVC.type = ConfigVCTypeReSubmit;
                __weak typeof(configVC) weakConfigVC = configVC;
                [weakSelf.navigationController pushViewController:configVC animated:YES];
                [configVC setFinishReSubmitBlock:^{
                    [weakConfigVC.navigationController popToRootViewControllerAnimated:YES];
                    [weakSelf showAlert:@"请重新打开App"];
                }];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }]];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
    }];
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
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    MusicPlayerViewController *playerVC = [[MusicPlayerViewController alloc]init];
//    playerVC.key = model.key;
//    playerVC.modelsArray = self.dataArray;
//    playerVC.index = indexPath.row;
//    playerVC.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:playerVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageFileDetailModel *model = self.dataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除视频
        kWSelf;
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        NSDictionary *params = @{@"uuid":[AppHelper uuid],
                                 @"key":model.key
                                 };
        [[BaseNetworking shareInstance] GET:kDeleteFileUrl dict:params succeed:^(id data) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (data && [data isKindOfClass:[NSDictionary class]] && [[(NSDictionary *)data objectForKey:@"status"] integerValue] == 1) {
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NSMutableString *)marker{
    if (!_marker) {
        _marker = [[NSMutableString alloc]init];
    }
    return _marker;
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
