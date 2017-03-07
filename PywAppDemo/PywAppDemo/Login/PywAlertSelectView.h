//
//  PywAlertSelectView.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/5.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
typedef void(^alertViewSelectedBlock)(NSMutableArray * alertViewData);

@interface PywAlertSelectView : UIView
@property (nonatomic, copy) alertViewSelectedBlock block;

- (void)alertSelectViewshow;
- (void)alertSelectViewClose;
- (void)alertViewSelectedBlock:(alertViewSelectedBlock)block;  // 回调数据
@end
