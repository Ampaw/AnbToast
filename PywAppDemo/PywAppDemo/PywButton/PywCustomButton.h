//
//  PywCustomButton.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/2/28.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  图标和文本 位置变化
 */
typedef NS_ENUM(NSInteger, PywCustomButtonStatus)
{
    PywCustomButtonStatusNormal   = 0,  // 默认情况(图标在左，居中对齐)
    PywCustomButtonStatusLeft     = 1,  // 左对齐(图标在左)
    PywCustomButtonStatusCenter   = 2,  // 居中对齐(图标在右，居中对齐)
    PywCustomButtonStatusRight    = 3,  // 右对齐(图标在右)
    PywCustomButtonStatusTop      = 4,  // 图标在上，文本在下（居中）
    PywCustomButtonStatusBottom   = 5,  // 图标在下，文本在上（居中）
};

@interface PywCustomButton : UIButton
/**
 *  外界通过设置按钮的status属性，创建不同类型的按钮
 */
+ (instancetype)buttonWithAlignmentStatus:(PywCustomButtonStatus)status;
- (instancetype)initWithAlignmentStatus:(PywCustomButtonStatus)status;

@end
