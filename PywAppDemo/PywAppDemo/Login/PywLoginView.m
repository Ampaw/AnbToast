//
//  PywLoginView.m
//  PywApp
//
//  Created by Ampaw on 2017/2/18.
//  Copyright © 2017年 Jade. All rights reserved.
//

#import "PywLoginView.h"
#import "PywTextField.h"
#import "Masonry.h"

@interface PywLoginView ()
@property(nonatomic, strong) UIButton       *closeBtn;      // 关闭按钮
@property(nonatomic, strong) UIImageView    *logoImg;       // Pyw_Logo_img
@property(nonatomic, strong) UIView         *phoneTFView;   // 手机号输入框
@property(nonatomic, strong) UIView         *smsCodeTFView; // 验证码输入框
@property(nonatomic, strong) UIButton       *loginBtn;      // 登录按钮

@property(nonatomic, strong) PywTextField   *phoneTF;       // 手机号输入框
@property(nonatomic, strong) PywTextField   *smsCodeTF;     // 验证码输入框
@property(nonatomic, strong) UIButton       *smsCodeGetBtn; // 获取短信验证码按钮
@end

@implementation PywLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpSubViews];
        [self makeConstraints];
        [self controlEvents];
    }
    return self;
}
- (instancetype)initWithDelegate:(id<PywLoginViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setUpSubViews];
        [self makeConstraints];
        [self controlEvents];
    }
    return self;
}

- (void)setUpSubViews
{
    [self addSubview:self.closeBtn];
    [self addSubview:self.logoImg];
    [self addSubview:self.phoneTFView];
    [self addSubview:self.smsCodeTFView];
    [self addSubview:self.loginBtn];
}
- (void)makeConstraints
{
    __weak typeof(self) weakSelf = self;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(22);
        make.left.equalTo(weakSelf.mas_left).offset(10);
    }];
    
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(weakSelf.phoneTFView.mas_top).offset(-60);
        make.width.mas_equalTo(133);
        make.height.mas_equalTo(60);
    }];
    
    [self.phoneTFView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(weakSelf.smsCodeTFView.mas_top).offset(-10);
        make.width.height.equalTo(weakSelf.loginBtn);
    }];
    
    [self.smsCodeTFView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(weakSelf.loginBtn.mas_top).offset(-30);
        make.width.height.equalTo(weakSelf.loginBtn);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(weakSelf.mas_centerY).offset(8);
        make.width.equalTo(weakSelf.mas_width).multipliedBy(0.9);
        make.height.mas_equalTo(44);
    }];
}
#pragma mark - getter & setter
- (NSString *)phoneNum
{
    return self.phoneTF.text;
}
- (NSString *)pwdOrCode
{
    return self.smsCodeTF.text;
}
#pragma mark - Control Events
- (void)controlEvents
{}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
#pragma mark - timer Or enableBtn
- (void)startTimeWithBtn:(UIButton *)button{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [button setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - Lazy Load
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor clearColor];
        _closeBtn.tag = ButtonTag_Close;
        [_closeBtn setImage:[UIImage imageNamed:@"icon_close_normal"] forState:UIControlStateNormal];
        [_closeBtn sizeToFit];
    }
    return _closeBtn;
}
- (UIImageView *)logoImg
{
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] init];
        _logoImg.image = [UIImage imageNamed:@"logo_start"];
        [_logoImg sizeToFit];
    }
    return _logoImg;
}
- (UIView *)phoneTFView
{
    if (!_phoneTFView) {
        _phoneTFView = [[UIView alloc] init];
        
        // 输入框
        _phoneTF = [PywTextField inputTextFieldWithLeftImgName:@"icon_phone_normal"
                                                   placeholder:@"输入手机号"
                                                  textFontSize:14];
        [_phoneTFView addSubview:_phoneTF];
        // 竖直分隔线
        UIView *v_Line = [[UIView alloc] init];
        v_Line.backgroundColor = [UIColor lightGrayColor];
        [_phoneTFView addSubview:v_Line];
        // 获取验证码按钮
        _smsCodeGetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _smsCodeGetBtn.backgroundColor = [UIColor clearColor];
        _smsCodeGetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _smsCodeGetBtn.tag = ButtonTag_SmsCode;
        [_smsCodeGetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_smsCodeGetBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_smsCodeGetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_smsCodeGetBtn sizeToFit];
        [_phoneTFView addSubview:_smsCodeGetBtn];
        // 底部分隔线
        UIView *h_Line = [[UIView alloc] init];
        h_Line.backgroundColor = [UIColor lightGrayColor];
        [_phoneTFView addSubview:h_Line];
        
        // 约束
        [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(_phoneTFView);
            make.height.equalTo(_phoneTFView.mas_height).offset(-1);
            make.right.equalTo(v_Line.mas_left);
        }];
        [v_Line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_phoneTFView.mas_centerY);
            make.left.equalTo(_phoneTF.mas_right);
            make.width.mas_equalTo(1);
            make.height.equalTo(_phoneTFView.mas_height).multipliedBy(0.6);
        }];
        [_smsCodeGetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_phoneTF.mas_centerY);
            make.width.mas_equalTo(90);
            make.left.equalTo(v_Line.mas_right);
            make.right.equalTo(_phoneTFView.mas_right);
        }];
        [h_Line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_phoneTFView);
            make.height.mas_equalTo(1);
        }];
    }
    return _phoneTFView;
}
- (UIView *)smsCodeTFView
{
    if (!_smsCodeTFView) {
        _smsCodeTFView = [[UIView alloc] init];
        
        // 输入框
        _smsCodeTF = [PywTextField inputTextFieldWithLeftImgName:@"icon_password_normal"
                                                     placeholder:@"验证码/密码"
                                                    textFontSize:14];
        [_smsCodeTFView addSubview:_smsCodeTF];
        // 底部分隔线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [_smsCodeTFView addSubview:bottomLine];
        
        // 约束
        [_smsCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_smsCodeTFView);
            make.height.equalTo(_smsCodeTFView.mas_height).offset(-1);
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_smsCodeTFView);
            make.height.mas_equalTo(1);
        }];
    }
    return _smsCodeTFView;
}
- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = [UIColor blueColor];
        _loginBtn.layer.cornerRadius = 5.0f;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.tag = ButtonTag_Login;
        
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    return _loginBtn;
}

@end
