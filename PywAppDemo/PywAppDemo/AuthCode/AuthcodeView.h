//
//  AuthcodeView.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/5/16.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 图形验证码
 */
@interface AuthcodeView : UIView

/**
 字符素材数组
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 验证码字符串
 */
@property (nonatomic, strong) NSMutableString *authCodeStr;

@end
