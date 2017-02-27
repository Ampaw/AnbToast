//
//  PywProgressHUD.m
//  AnbToastDemo
//
//  Created by Ampaw on 2017/2/27.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywProgressHUD.h"

#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

static CGFloat const kMargin = 20;
static CGFloat const kPadding = 4;

@interface PywProgressHUD ()
@property(nonatomic, strong) UIView   *indicator;
@property(nonatomic, strong) UILabel  *messageLabel;

@property(nonatomic, strong) UIView   *contentView;
@property(nonatomic, assign) CGSize   contentSize;

@property(nonatomic, assign) PywProgressHUDMode mode;
@property(nonatomic, strong) UIImage  *iconImage;
//Toast消失动画是否启用
@property (nonatomic, assign) BOOL dismissToastAnimated;
//Toast显示时长
@property (nonatomic, assign) NSTimeInterval duration;
@end

@implementation PywProgressHUD


- (instancetype)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupView];
        [self updateIndicators];
        [self initToastConfig];
    }
    return self;
}
/**
 初始化Toast基本配置（可以在这里修改一些默认效果）
 */
-(void)initToastConfig{
    _mode = PywProgressHUDModeBelowStatusBar;
    _contentSize = CGSizeZero;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
    
    //默认背景色
    self.contentView.backgroundColor = [UIColor darkGrayColor];
    
    //TextColor
    self.messageLabel.textColor = [UIColor whiteColor];
    
    //TextFont
    self.messageLabel.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightMedium];
    
    self.dismissToastAnimated = YES;
    
    //默认显示3s
    if (self.duration == 0) {
        self.duration = 3.f;
    }
}
- (void)setupView
{
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];

    
    _messageLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _messageLabel.adjustsFontSizeToFitWidth = NO;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.opaque = NO;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = [UIColor whiteColor];
    [self addSubview:_messageLabel];
}
- (void)updateIndicators
{
    
    BOOL isActivityIndicator = [_indicator isKindOfClass:[UIActivityIndicatorView class]];
    BOOL isImageView = [_indicator isKindOfClass:[UIImageView class]];
    
    if (_mode == [self isLoading])
    {
        if (!isActivityIndicator) {
            
            [_indicator removeFromSuperview];
            self.indicator = ([[UIActivityIndicatorView alloc]
                               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
            [(UIActivityIndicatorView *)_indicator startAnimating];
            [self.contentView addSubview:_indicator];
        }
    }
    else if (_mode != [self isLoading])
    {
        if (!isImageView) {
            
            [_indicator removeFromSuperview];
            self.indicator = ([[UIImageView alloc] initWithImage:self.iconImage]);
            [self.contentView addSubview:_indicator];
        }
    }
}
/**
 *  Toast是否为网络请求样式
 */
- (BOOL)isLoading
{
    return (   self.mode == PywProgressHUDModeCenterLoadingLeft
            || self.mode == PywProgressHUDModeCenterLoadingLeftWithFillet
            || self.mode == PywProgressHUDModeCenterLoadingTop
            || self.mode == PywProgressHUDModeCenterLoadingTopWithFillet);
}

@end
