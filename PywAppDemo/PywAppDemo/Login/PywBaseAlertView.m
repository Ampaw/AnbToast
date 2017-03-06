//
//  PywBaseAlertView.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/6.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywBaseAlertView.h"
#import "UIView+Frame.h"
#import "Masonry.h"

#define AlertViewContactHeight 180
#define AlertViewAddressHeight 280

@interface PywBaseAlertView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentsView;

@property (nonatomic, strong) UIView *subView;
@end

@implementation PywBaseAlertView

- (instancetype)initWithContentsSubView:(UIView *)subView
{
    self = [super init];
    if (self) {
        self.subView = subView;
        
        [self setupSubviews];
        [self updateSubViewConstraints];
    }
    return self;
}

- (void)setupSubviews
{
    [self addSubview:self.bgView];
    
    [[NSNotificationCenter  defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillChange:)
                                                  name:UIKeyboardWillChangeFrameNotification
                                                object:nil];
}
- (void)updateSubViewConstraints
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
}

- (void)show {
    if (self.contentsView) return;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentsView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 SCREENHEIGHT,
                                                                 SCREENWIDTH,
                                                                 self.subView.frame.size.height)];
    self.contentsView.backgroundColor = [UIColor clearColor];
    self.contentsView.userInteractionEnabled = YES;
    [self.contentsView addSubview:self.subView];
    
    // 添加到父容器
    [self addSubview:self.contentsView];
    // 给背景View添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tap:)];
    self.bgView.userInteractionEnabled = YES;
    [self.bgView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentsView.y = (SCREENHEIGHT - self.subView.frame.size.height);
    }];
    [window addSubview:self];
}

- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        self.contentsView.y = SCREENHEIGHT;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.contentsView removeFromSuperview];
        self.contentsView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark - EventAction
- (void)tap:(UITapGestureRecognizer *)tap {
    [self hide];
}

#pragma mark - Lazy
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
    }
    return _bgView;
}

#pragma mark - keyboardNotification
/**
 *  键盘弹起
 */
- (void)keyboardWillChange:(NSNotification  *)notification
{
    // 获取键盘的Y值
    NSDictionary *dict  = notification.userInfo;
    CGRect keyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    // 获取动画执行时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    // 计算需要移动的距离
    CGFloat selfY = keyboardY - self.height;
    
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        // 需要执行动画的代码
        self.y = selfY;
    } completion:^(BOOL finished) {
        // 动画执行完毕执行的代码
        if (_contentsView == nil) {
            [self removeFromSuperview];
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
