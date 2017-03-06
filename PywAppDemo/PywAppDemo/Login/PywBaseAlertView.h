//
//  PywBaseAlertView.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/6.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface PywBaseAlertView : UIView

- (instancetype)initWithContentsSubView:(UIView *)subView;

- (void)show;
- (void)hide;

@end
