//
//  ImageFileDetailCell.h
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageFileDetailModel;

@interface ImageFileDetailCell : UITableViewCell

@property (nonatomic, strong) ImageFileDetailModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
