//
//  PywProgressHUD.h
//  AnbToastDemo
//
//  Created by Ampaw on 2017/2/27.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PywProgressHUDMode) {
    PywProgressHUDModeBelowStatusBar                  = 1, // status下滑（没圆角）
    PywProgressHUDModeBelowStatusBarWithFillet        = 2, // status下滑（带圆角）
    PywProgressHUDModeBottom                          = 3, // bottom弹窗（没圆角）
    PywProgressHUDModeBottomWithFillet                = 4, // bottom弹窗（带圆角）
    PywProgressHUDModeCenterLoadingLeft               = 5, // center加载（没圆角,菊花在文字左边）
    PywProgressHUDModeCenterLoadingLeftWithFillet     = 6, // center加载（带圆角,菊花在文字左边）
    PywProgressHUDModeCenterLoadingTop                = 7, // center加载（没圆角,菊花在文字上边）
    PywProgressHUDModeCenterLoadingTopWithFillet      = 8, // center加载（带圆角,菊花在文字上边）
};

@interface PywProgressHUD : UIView

/**
 展示一个文字内容的HUD
 
 @param message  展示内容
 @param mode     mode样式
 */
+ (void)showToastWithMessage:(NSString *)message
                        mode:(PywProgressHUDMode)mode;
/**
 展示一个带图片内容的HUD
 
 @param message 展示内容
 @param iconImg 展示图片
 @param mode    mode样式
 */
+ (void)showToastWithMessage:(NSString *)message
                   iconImage:(UIImage *)iconImg
                        mode:(PywProgressHUDMode)mode;

/**
 隐藏HUD
 */
+ (void)hideHUD;

//显示到keywindon上
+(instancetype)showWithMessage:(NSString*)message;
+(void)hide;

//显示到view上
+(instancetype)showToView:(UIView*)view message:(NSString*)message;
+(void)hideForView:(UIView*)view;

@end
