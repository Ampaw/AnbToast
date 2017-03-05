//
//  PywLoginView.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/2/28.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywLoginView.h"
#import "Masonry.h"
/*  屏幕宽高 */
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface PywLoginView ()

@property(nonatomic, strong) UIView *logingView;
@property(nonatomic, strong) UITextField *textF;

@end

@implementation PywLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
        self.alpha = 0.8;
        
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews
{
    self.logingView = [[UIView alloc] init];
    self.logingView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.logingView];
    
    self.textF = [[UITextField alloc] init];
    self.textF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textF.layer.borderWidth = 1;
    self.textF.placeholder = @"请输入内容";
    [self addSubview:self.logingView];

}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    }];
}
-(void)hide{
    [UIView animateWithDuration:.3 animations:^{
        
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 让数组中的每一个view都调用移除
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

@end
