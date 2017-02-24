//
//  AnbToast.h
//  PywToastDemo
//
//  Created by Ampaw on 2017/2/23.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  各Toast展示出现位置描述
 */
typedef NS_ENUM(NSInteger, AnbToastPosition) {
    
    AnbToastPositionDefault                         = 0, // 默认顶部下滑
    AnbToastPositionBelowStatusBar                  = 1, // status下滑（没圆角）
    AnbToastPositionBelowStatusBarWithFillet        = 2, // status下滑（带圆角）
    AnbToastPositionBottom                          = 3, // bottom弹窗（没圆角）
    AnbToastPositionBottomWithFillet                = 4, // bottom弹窗（带圆角）
    AnbToastPositionCenterLoadingLeft               = 5, // center加载（没圆角,菊花在文字左边）
    AnbToastPositionCenterLoadingLeftWithFillet     = 6, // center加载（带圆角,菊花在文字左边）
    AnbToastPositionCenterLoadingTop                = 7, // center加载（没圆角,菊花在文字上边）
    AnbToastPositionCenterLoadingTopWithFillet      = 8, // center加载（带圆角,菊花在文字上边）
};


@interface AnbToast : UIView

/**
 展示一个文字内容的Toast

 @param message  展示内容
 @param position 展示Toast位置及样式
 */
+ (void)showToastWithMessage:(NSString *)message
                    position:(AnbToastPosition)position;
/**
 展示一个带图片内容的Toast

 @param message 展示内容
 @param iconImg 展示图片
 @param position 展示Toast位置及样式
 */
+ (void)showToastWithMessage:(NSString *)message
                   iconImage:(UIImage *)iconImg
                    position:(AnbToastPosition)position;

/**
 隐藏Toast
 */
+ (void)hideToast;

@end
