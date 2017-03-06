//
//  PywLoginView.h
//  PywApp
//
//  Created by Ampaw on 2017/2/18.
//  Copyright © 2017年 Jade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PywLoginView;

typedef NS_ENUM(NSInteger, ButtonTag) {
    ButtonTag_Close     = 1000, // 关闭
    ButtonTag_Login     = 2000, // 登录
    ButtonTag_SmsCode   = 3000, // 验证码
};

@protocol PywLoginViewDelegate <NSObject>
@optional
- (void)loginView:(PywLoginView *)loginView didSelectButton:(UIButton *)button tag:(NSInteger)tag;
@end

@interface PywLoginView : UIView
@property (nonatomic, weak) id<PywLoginViewDelegate> delegate;

@property(nonatomic, copy) NSString *phoneNum;  // 手机号
@property(nonatomic, copy) NSString *pwdOrCode; // 验证码|密码

- (instancetype)initWithDelegate:(id<PywLoginViewDelegate>)delegate;

@end
