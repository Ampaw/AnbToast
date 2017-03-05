//
//  PywHUDManager.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/1.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywHUDManager.h"
#import "PywToast.h"
#import "PywProgressHUD.h"

@implementation PywHUDManager

+ (void)hideWithMode:(PywAlertMode)mode
{
    if (mode == PywAlertMode_Waring || mode == PywAlertMode_Toast)
    {
        [PywToast hideToast];
    }
    else if (mode == PywAlertMode_HUD)
    {
        [PywProgressHUD hideHUD];
    }
}
+ (void)showWithMode:(PywAlertMode)mode message:(NSString *)message iconImage:(UIImage *)iconImage
{
    switch (mode) {
        case PywAlertMode_Waring:   // 网络异常
        {
            [PywToast showToastWithMessage:message iconImage:iconImage position:PywToastPositionDefault];
        }
            break;
        case PywAlertMode_Toast:    // 请求成功、失败
        {
             [PywToast showToastWithMessage:message iconImage:iconImage position:PywToastPositionBottomWithFillet];
        }
            break;
        case PywAlertMode_HUD:      // 网络加载
        {
            [PywProgressHUD showWithMessage:message mode:PywProgressHUDModeIndeterminate style:PywProgressHUDStyleDefault];
        }
            break;
        default:
            break;
    }
}
+ (void)showWithMode:(PywAlertMode)mode message:(NSString *)message iconImage:(UIImage *)iconImage toView:(UIView *)view
{
    switch (mode) {
        case PywAlertMode_Waring:   // 网络异常
        {
            [PywToast showToastWithMessage:message iconImage:iconImage position:PywToastPositionDefault toView:view];
        }
            break;
        case PywAlertMode_Toast:    // 请求成功、失败
        {
            [PywToast showToastWithMessage:message iconImage:iconImage position:PywToastPositionBottomWithFillet toView:view];
        }
            break;
        case PywAlertMode_HUD:      // 网络加载
        {
            [PywProgressHUD showWithMessage:message mode:PywProgressHUDModeIndeterminate style:PywProgressHUDStyleDefault toView:view];
        }
            break;
        default:
            break;
    }
}

@end
