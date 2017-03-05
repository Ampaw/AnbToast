//
//  PywHUDManager.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/1.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PywAlertMode)
{
    PywAlertMode_Toast  = 0, // 用于成功与失败提示
    PywAlertMode_Waring = 1, // 用于网络异常提示
    PywAlertMode_HUD    = 2, // 用于网络加载提示
};

@interface PywHUDManager : UIView
// 隐藏
+ (void)hideWithMode:(PywAlertMode)mode;

/*  备注：当使用为HUD时，UIImage传nil  */
// 显示在windows上
+ (void)showWithMode:(PywAlertMode)mode
             message:(NSString *)message
           iconImage:(UIImage *)iconImage;
// 显示在view上
+ (void)showWithMode:(PywAlertMode)mode
             message:(NSString *)message
           iconImage:(UIImage *)iconImage
              toView:(UIView *)view;

@end
