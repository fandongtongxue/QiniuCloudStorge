//
//  MusicFileDetailCell.h
//  QiniuCloudStorge
//
//  Created by 范东 on 16/10/10.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageFileDetailModel;

@interface MusicFileDetailCell : UITableViewCell

@property (nonatomic, strong) ImageFileDetailModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
