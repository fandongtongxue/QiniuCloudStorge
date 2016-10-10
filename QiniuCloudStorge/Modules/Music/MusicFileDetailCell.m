//
//  ImageFileDetailCell.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "MusicFileDetailCell.h"
#import "ImageFileDetailModel.h"
#import "MJProgressView.h"

@interface MusicFileDetailCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) MJProgressView *progressView;

@end

@implementation MusicFileDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, kScreenSizeWidth - 100, 50)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.bottom, kScreenSizeWidth - 40, 20)];
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    UIButton *downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    downloadBtn.right = kScreenSizeWidth - 20;
    downloadBtn.centerY = 100/2;
    [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downloadBtn setBackgroundColor:[UIColor blackColor]];
    [downloadBtn.layer setCornerRadius:10];
    [downloadBtn setClipsToBounds:YES];
    [downloadBtn addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:downloadBtn];
    self.downloadBtn = downloadBtn;
    
    MJProgressView *progressView = [[MJProgressView alloc]initWithFrame:CGRectMake(0, 94.5, kScreenSizeWidth, 5)];
    progressView.hidden = NO;
    progressView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:progressView];
    self.progressView = progressView;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, kScreenSizeWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}

- (void)setModel:(ImageFileDetailModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"文件名: %@",model.key];
    self.detailLabel.text = [NSString stringWithFormat:@"文件大小: %@",[AppHelper fileSize:[NSString stringWithFormat:@"%@",model.fsize]]];
}

- (void)setProgress:(NSString *)url{
    // 控制状态
    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:url];
    if (info.state == MJDownloadStateCompleted) {
        self.progressView.hidden = YES;
    } else if (info.state == MJDownloadStateWillResume) {
        self.progressView.hidden = NO;
    } else {
        if (info.state == MJDownloadStateNone ) {
            self.progressView.hidden = YES;
        } else {
            self.progressView.hidden = NO;
            if (info.totalBytesExpectedToWrite) {
                self.progressView.progress = 1.0 * info.totalBytesWritten / info.totalBytesExpectedToWrite;
            } else {
                self.progressView.progress = 0.0;
            }
        }
    }
}

- (void)download:(UIButton *)sender{
    //测试下载
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path = [docDir stringByAppendingString:@"/Music/"];
    NSString *finalPath = [path stringByAppendingString:_model.key];
    NSString *url = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[self.model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[MJDownloadManager defaultManager] download:url toDestinationPath:finalPath progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        DLOG(@"bytesWritten:%ld  totalBytesWritten:%.2f  totalBytesExpectedToWrite:%.2f",bytesWritten,(float)totalBytesWritten/1024/1024,(float)totalBytesExpectedToWrite/1024/1024);
        [self setProgress:url];
    } state:^(MJDownloadState state, NSString *file, NSError *error) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
