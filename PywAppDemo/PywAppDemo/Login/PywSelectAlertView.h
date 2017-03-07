//
//  PywSelectAlertView.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/6.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface PywSelectAlertView : UIView

/**
 创建 含有内容的AlertView

【备注：在创建subView的时候，一定要设置它的frame值，因为它的高度是AlertView中显示内容的高度】
 @param subView AlertView的子控件
 @return <#return value description#>
 */
- (instancetype)initWithContentsSubView:(UIView *)subView;


/**
 显示 与 隐藏
 */
- (void)showSelectAlertView;
- (void)dismissSelectAlertView;

@end
