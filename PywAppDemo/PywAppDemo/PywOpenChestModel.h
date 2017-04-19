//
//  PywOpenChestModel.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/19.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PywOpenChestModel : NSObject

/**
 宝箱金额
 */
@property(nonatomic, copy) NSString *chest_money;

/**
 是否打开宝箱
 */
@property(nonatomic, assign) BOOL is_open_chest;

@end
