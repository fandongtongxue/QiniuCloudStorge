//
//  ImageFileListViewController.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "ImageFileListViewController.h"
#import "ImageFileDetailCell.h"
#import "ImageFileDetailModel.h"
#import "ConfigViewController.h"
#import "MWPhotoBrowser.h"

#define kGetFileListUrl @"http://fandong.me/App/QiniuCloudStorge/php-sdk-master/examples/list_file_image.php"

static NSString * const cellID = @"imageCellID";

@interface ImageFileListViewController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ImageFileListViewController

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
    tableView.showsVerticalScrollIndicator = YES;
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
    // Browser
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    for (ImageFileDetailModel *model in self.dataArray) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
         [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]]];
         [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imageUrl]]];
    }
    self.photos = photos;
    self.thumbs = thumbs;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = NO;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:indexPath.row];
    
    // Reset selections
    if (displaySelectionButtons) {
        _selections = [NSMutableArray new];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    // Modal
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
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

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    DLOG(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    DLOG(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    DLOG(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
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
