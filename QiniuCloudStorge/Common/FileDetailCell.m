//
//  ImageFileDetailCell.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "FileDetailCell.h"

@interface FileDetailCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

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
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setModel:(FileDetailModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"文件名: %@",model.key];
    self.detailLabel.text = [NSString stringWithFormat:@"文件大小: %@",[AppHelper fileSize:[NSString stringWithFormat:@"%@",model.fsize]]];
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
