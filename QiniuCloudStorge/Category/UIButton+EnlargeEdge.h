//
//  UIButton+EnlargeEdge.h
//  WhatsLive
//
//  Created by huangjiancheng on 15/12/4.
//  Copyright © 2015年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(EnlargeEdge)

- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
