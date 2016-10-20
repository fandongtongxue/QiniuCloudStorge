//
//  MusicPlayerViewController.h
//  QiniuCloudStorge
//
//  Created by 范东 on 16/10/19.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayerViewController : UIViewController

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *modelsArray;

@end
