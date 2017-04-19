//
//  PywOpenChestAlertView.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/19.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Completion)(BOOL is_open_chest, NSString *chest_money, id target);

@interface PywOpenChestAlertView : UIView

/**
 init

 @param chest_msg 宝箱一句话说明
 @param chest_offset_cost 宝箱减免金额
 @param is_open_chest 是否已打开宝箱
 @param target 当前对象
 @param completion 打开宝箱完成回调
 */
- (instancetype)initWithChestMsg:(NSString *)chest_msg
                 chestOffsetCost:(NSString *)chest_offset_cost
                     isOpenChest:(BOOL)is_open_chest
                          target:(id)target
                      completion:(Completion)completion;

/**
 显示提示框
 */
- (void)show;


@end
