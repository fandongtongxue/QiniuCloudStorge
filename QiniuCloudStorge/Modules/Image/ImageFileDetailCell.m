//
//  ImageFileDetailCell.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "ImageFileDetailCell.h"
#import "ImageFileDetailModel.h"
#import <DownloadButton/PKDownloadButton.h>
#import "MJDownload.h"

@interface ImageFileDetailCell ()<PKDownloadButtonDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation ImageFileDetailCell

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
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, kScreenSizeWidth - 40, 50)];
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
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, kScreenSizeWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}

- (void)setModel:(ImageFileDetailModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"文件名: %@",model.key];
    self.detailLabel.text = [NSString stringWithFormat:@"文件大小: %@",[AppHelper fileSize:[NSString stringWithFormat:@"%@",model.fsize]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
