//
//  MoreViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "MoreViewController.h"
#import <MessageUI/MessageUI.h>
#import "AboutViewController.h"

static NSString * const cellID = @"moreCellID";

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL canCleanImage;
@property (nonatomic, assign) BOOL canCleanVideo;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[MapManager manager] stopUpdatingLocation];
}

- (void)initNavigationBar{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更多";
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
    [self.dataArray removeAllObjects];
    kWSelf;
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        if (totalSize == 0) {
            _canCleanImage = NO;
        }else{
            _canCleanImage = YES;
        }
        NSDictionary *imageDict = @{@"title":@"清除图片缓存",@"detail":[NSString stringWithFormat:@"%.2fMB",(float)totalSize/1024/1024]};
        NSString *localFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kVideoDetailLocalPrefix];
        NSDictionary *videoDict = @{@"title":@"清除视频缓存",@"detail":[NSString stringWithFormat:@"%.2fMB",[self fileSizeForPath:localFilePath]]};
        if ([self fileSizeForPath:localFilePath] == 0) {
            _canCleanVideo = NO;
        }else{
            _canCleanVideo = YES;
        }
        NSDictionary *feedDict = @{@"title":@"反馈意见",@"detail":@""};
        NSDictionary *aboutDict = @{@"title":@"关于作者",@"detail":@"范东"};
        NSDictionary *versionDict = @{@"title":@"软件版本",@"detail":[NSString stringWithFormat:@"V%@",kAppVersion]};
        NSString *location;
        if ([UserDefault objectForKey:kLocationKey]) {
            location = [UserDefault objectForKey:kLocationKey];
        }else{
            location = @"未获取";
        }
        NSDictionary *locationDict = @{@"title":@"您的位置",@"detail":location};
        [weakSelf.dataArray addObject:imageDict];
        [weakSelf.dataArray addObject:videoDict];
        [weakSelf.dataArray addObject:feedDict];
        [weakSelf.dataArray addObject:aboutDict];
        [weakSelf.dataArray addObject:versionDict];
        [weakSelf.dataArray addObject:locationDict];
        [weakSelf.tableView reloadData];
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    kWSelf;
    switch (indexPath.row) {
        case 0:
            //清除缓存
            if (!_canCleanImage) {
                [self showAlert:@"没有图片缓存"];
                return;
            }
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                // Do something useful in the background and update the HUD periodically.
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.label.text = @"清除缓存中...";
                });
                sleep(1);
                [[SDImageCache sharedImageCache] clearDisk];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [[UIImage imageNamed:@"more_complete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = @"清除完成";
                });
                sleep(1);
                [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB",(float)totalSize/1024/1024];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        _canCleanImage = NO;
                    });
                }];
                
            });
        }
            break;
        case 1:
            if (!_canCleanVideo) {
                [self showAlert:@"没有视频缓存"];
                return;
            }
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                // Do something useful in the background and update the HUD periodically.
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.label.text = @"清除缓存中...";
                });
                sleep(1);
                [[SDImageCache sharedImageCache] clearDisk];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [[UIImage imageNamed:@"more_complete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    hud.customView = imageView;
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.label.text = @"清除完成";
                });
                sleep(1);
                NSString *localFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kVideoDetailLocalPrefix];
                [[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB",[self fileSizeForPath:localFilePath]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    _canCleanVideo = NO;
                });
                
            });
        }
            break;
        case 2:
        {
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                [self sendEmail]; // 调用发送邮件的代码
            }else{
                [self showAlert:@"未设置系统邮箱"];
            }
        }
            break;
        case 3:
        {
            AboutViewController *aboutVC = [[AboutViewController alloc]init];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 5:
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                // Do something useful in the background and update the HUD periodically.
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.label.text = @"获取位置中...";
                    cell.detailTextLabel.text = @"获取位置中...";
                });
                [[MapManager manager] startUpdatingLocationFinishBlock:^(NSString *location) {
                    [self showAlert:location];
                    cell.detailTextLabel.text = location;
                    [UserDefault saveObject:location ForKey:kLocationKey];
                    [[MapManager manager] stopUpdatingLocation];
                    sleep(1);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                    });
                } ErrorBlock:^(NSError *error) {
                    [weakSelf showAlert:[NSString stringWithFormat:@"%@",error]];
                    [UserDefault saveObject:@"未获取" ForKey:kLocationKey];
                    cell.detailTextLabel.text = @"未获取";
                    [[MapManager manager] stopUpdatingLocation];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                    });
                }];
            });
            
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)sendEmail{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"七牛云存储 - 意见反馈"];
    // 设置收件人
    [mailCompose setToRecipients:@[@"admin@fandong.me"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"fand@wisenjoy.com"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"fengzhizif@icloud.com"]];
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = [NSString stringWithFormat:@"<html><body><p>%@</p><br><br><p>%@</p><p>%@</p></body></html>",@"请输入反馈意见",[NSString stringWithFormat:@"App版本:V%@",kAppVersion],[NSString stringWithFormat:@"系统版本:iOS %.2f",kSystemVersion]];
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:YES];
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)fileSizeForPath:(NSString*)path//计算文件夹下文件的总大小
{
    float size = 0;
    NSArray* array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
        else
        {
            [self fileSizeForPath:fullPath];
        }
    }
    return size;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    // 关闭邮件发送视图
    kWSelf;
    [self dismissViewControllerAnimated:YES completion:^{
        switch (result)
        {
            case MFMailComposeResultCancelled: // 用户取消编辑
                [weakSelf showAlert:@"用户取消编辑"];
                break;
            case MFMailComposeResultSaved: // 用户保存邮件
                [weakSelf showAlert:@"用户保存邮件"];
                break;
            case MFMailComposeResultSent: // 用户点击发送
                [weakSelf showAlert:@"用户点击发送"];
                break;
            case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
                [weakSelf showAlert:[NSString stringWithFormat:@"用户发送失败:%@", [error localizedDescription]]];
                break;
        }
    }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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
