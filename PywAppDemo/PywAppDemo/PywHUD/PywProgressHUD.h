//
//  PywProgressHUD.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/1.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PywProgressHUDMode)
{
    PywProgressHUDModeIndeterminate,    // 转圈动画模式，默认值
    PywProgressHUDModeText              // 只显示标题
};

typedef NS_ENUM(NSInteger, PywProgressHUDStyle)
{
    PywProgressHUDStyleDefault, // 默认（带圆角）
    PywProgressHUDStyleLine,    // 没圆角
};

@interface PywProgressHUD : UIView

// 隐藏HUD
+ (void)hideHUD;

// 显示HUD
+(void)showWithMessage:(NSString*)message
                  mode:(PywProgressHUDMode)mode
                 style:(PywProgressHUDStyle)style;

+(void)showWithMessage:(NSString*)message
                  mode:(PywProgressHUDMode)mode
                 style:(PywProgressHUDStyle)style
                toView:(UIView*)view;


@end
