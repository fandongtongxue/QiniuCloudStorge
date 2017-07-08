//
//  ImageFileDetailCell.h
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileDetailModel;

typedef void(^tapOpenButtonBlock)(NSString *fileUrl);

@interface FileDetailCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) FileDetailModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setTapOpenButtonBlock:(tapOpenButtonBlock)block;

@end
