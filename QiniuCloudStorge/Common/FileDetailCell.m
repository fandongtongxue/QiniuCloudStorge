//
//  ImageFileDetailCell.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "FileDetailCell.h"
#import "MJDownload.h"
#import <AVKit/AVKit.h>

@interface FileDetailCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *openButton;
@property (nonatomic, strong) MJProgressView *progressView;
@property (nonatomic, copy) tapOpenButtonBlock tapOpenButtonBlock;

@end

@implementation FileDetailCell

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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    leftImageView.clipsToBounds = YES;
    [self.contentView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UIButton *downloadButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [downloadButton addTarget:self action:@selector(downloadButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:downloadButton];
    self.downloadButton = downloadButton;
    
    UIButton *openButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [openButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [openButton addTarget:self action:@selector(openButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:openButton];
    self.openButton = openButton;
    
    MJProgressView *progressView = [[MJProgressView alloc]initWithFrame:CGRectZero];
    progressView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:progressView];
    self.progressView = progressView;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.downloadButton.mas_left).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.right.equalTo(self.downloadButton.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(5);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
    [self addGestureRecognizer:longPress];
    self.userInteractionEnabled = YES;
}

- (void)setModel:(FileDetailModel *)model{
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.key];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",[AppHelper fileSize:[NSString stringWithFormat:@"%@",model.fsize]]];
    NSString *fileUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSArray *fileUrlArray = [model.key componentsSeparatedByString:@"."];
    NSString *suffixString = fileUrlArray.lastObject;
    if ([suffixString isEqualToString:@"mp4"] || [suffixString isEqualToString:@"mov"] || [suffixString isEqualToString:@"avi"] || [suffixString isEqualToString:@"m4v"]) {
        [self.leftImageView setImage:[UIImage imageNamed:@"file_img_suffix_mov"]];
    }else if ([suffixString isEqualToString:@"pdf"]) {
        [self.leftImageView setImage:[UIImage imageNamed:@"file_img_suffix_pdf"]];
    }else if ([suffixString isEqualToString:@"mp3"]){
        [self.leftImageView setImage:[UIImage imageNamed:@"file_img_suffix_mp3"]];
    }else{
        NSString *slimImageUrl = [NSString stringWithFormat:@"%@?%@",fileUrl,@"imageView2/2/h/200"];
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:slimImageUrl]];
    }
    
    //关于下载
    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:fileUrl];
    if (info.state == MJDownloadStateCompleted) {
        self.openButton.hidden = NO;
        self.downloadButton.hidden = YES;
        self.progressView.hidden = YES;
    } else if (info.state == MJDownloadStateWillResume) {
        self.openButton.hidden = YES;
        self.downloadButton.hidden = NO;
        self.progressView.hidden = NO;
        
        [self.downloadButton setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
    } else {
        self.openButton.hidden = YES;
        self.downloadButton.hidden = NO;
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
        if (info.state == MJDownloadStateResumed) {
            [self.downloadButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        } else {
            [self.downloadButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
        }
    }
}

- (void)downloadButtonAction{
    NSString *fileUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[_model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    MJDownloadInfo *info = [[MJDownloadManager defaultManager] downloadInfoForURL:fileUrl];
    
    if (info.state == MJDownloadStateResumed || info.state == MJDownloadStateWillResume) {
        [[MJDownloadManager defaultManager] suspend:info.url];
    } else {
        [[MJDownloadManager defaultManager] download:fileUrl progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.model = self.model;
            });
        } state:^(MJDownloadState state, NSString *file, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.model = self.model;
            });
        }];
    }
}

- (void)openButtonAction{
    NSString *fileUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[_model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (_tapOpenButtonBlock) {
        _tapOpenButtonBlock(fileUrl);
    }
}

- (void)longPressAction{
    NSString *fileUrl = [NSString stringWithFormat:@"%@%@",kFileDetailUrlPrefix,[_model.key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSArray *activityItems = @[fileUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:activityVC animated:YES completion:nil];
}

- (void)setTapOpenButtonBlock:(tapOpenButtonBlock)block{
    _tapOpenButtonBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
