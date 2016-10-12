//
//  ImageFileListViewController.h
//  Qiniu
//
//  Created by 范东 on 16/8/12.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageFileListViewController : UIViewController{
    NSMutableArray *_selections;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end
