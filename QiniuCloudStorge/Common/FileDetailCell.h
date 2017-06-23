//
//  ImageFileDetailCell.h
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileDetailModel;

@interface FileDetailCell : UITableViewCell

@property (nonatomic, strong) FileDetailModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
