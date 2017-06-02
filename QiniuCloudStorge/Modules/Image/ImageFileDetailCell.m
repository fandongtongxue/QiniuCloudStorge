//
//  ImageFileDetailCell.m
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import "ImageFileDetailCell.h"
#import "ImageFileDetailModel.h"

@interface ImageFileDetailCell ()

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
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
    }];
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
