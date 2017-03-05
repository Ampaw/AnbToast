//
//  PywAlertSelectView.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/5.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywAlertSelectView.h"
#import "UIView+Frame.h"

#define AlertViewContactHeight 180
#define AlertViewAddressHeight 280

@interface PywAlertSelectView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentsView;
@property (nonatomic, strong) NSMutableArray *editSource;
@end

@implementation PywAlertSelectView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.3;
        [self addSubview:self.bgView];
        [[NSNotificationCenter  defaultCenter] addObserver:self
                                                  selector:@selector(keyboardWillChange:)
                                                      name:UIKeyboardWillChangeFrameNotification
                                                    object:nil];
    }
    return self;
}

- (void)alertSelectViewshow {
    if (self.contentsView) return;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentsView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT / 2)];
    self.contentsView.backgroundColor = [UIColor redColor];
    self.contentsView.userInteractionEnabled = YES;
    
    // 该显示的内容
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    view.backgroundColor = [UIColor blueColor];
    [self.contentsView addSubview:view];
    
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, self.contentsView.frame.size.height - 80, SCREENWIDTH, 40)];
    text.backgroundColor = [UIColor whiteColor];
    [self.contentsView addSubview:text];
    
    // 添加到父容器
    [self addSubview:self.contentsView];
    // 给背景View添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.bgView.userInteractionEnabled = YES;
    [self.bgView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentsView.y = SCREENHEIGHT / 2;
    }];
    [window addSubview:self];
}

- (void)alertSelectViewClose {
    [UIView animateWithDuration:0.5 animations:^{
        self.contentsView.y = SCREENHEIGHT;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.contentsView removeFromSuperview];
        self.contentsView = nil;
        [self removeFromSuperview];
    }];
}

- (void)alertViewSelectedBlock:(alertViewSelectedBlock)block {
    self.block = block;
}

#pragma mark - EventAction
- (void)tap:(UITapGestureRecognizer *)tap {
    [self alertSelectViewClose];
}

#pragma mark - Lazy
- (NSMutableArray *)editSource {
    if (!_editSource) {
        _editSource = [NSMutableArray array];
    }
    return _editSource;
}

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
