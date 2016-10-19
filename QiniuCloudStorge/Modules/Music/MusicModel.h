//
//  MusicModel.h
//  QiniuCloudStorge
//
//  Created by 范东 on 16/10/19.
//  Copyright © 2016年 范东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioStreamer/DOUAudioFile.h>

@interface MusicModel : NSObject<DOUAudioFile>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *audioFileURL;

@end
