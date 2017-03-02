//
//  PywToast.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/1.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  各Toast展示出现位置描述
 */
typedef NS_ENUM(NSInteger, PywToastPosition) {
    
    PywToastPositionDefault                         = 0, // 默认顶部下滑
    PywToastPositionBelowStatusBar                  = 1, // status下滑（没圆角）
    PywToastPositionBelowStatusBarWithFillet        = 2, // status下滑（带圆角）
    PywToastPositionBottom                          = 3, // bottom弹窗（没圆角）
    PywToastPositionBottomWithFillet                = 4, // bottom弹窗（带圆角）
};

@interface PywToast : UIView

/**
 展示一个文字内容的Toast
 
 @param message  展示内容
 @param position 展示Toast位置及样式
 */
+ (void)showToastWithMessage:(NSString *)message
                    position:(PywToastPosition)position;
+ (void)showToastWithMessage:(NSString *)message
                    position:(PywToastPosition)position
                      toView:(UIView*)view;
/**
 展示一个带图片内容的Toast
 
 @param message 展示内容
 @param iconImg 展示图片
 @param position 展示Toast位置及样式
 */
+ (void)showToastWithMessage:(NSString *)message
                   iconImage:(UIImage *)iconImg
                    position:(PywToastPosition)position;
+ (void)showToastWithMessage:(NSString *)message
                   iconImage:(UIImage *)iconImg
                    position:(PywToastPosition)position
                      toView:(UIView*)view;

/**
 隐藏Toast
 */
+ (void)hideToast;

@end
