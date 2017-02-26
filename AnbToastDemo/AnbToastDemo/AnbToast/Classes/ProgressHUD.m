//
//  ProgressHUD.m
//  AnbToastDemo
//
//  Created by Ampaw on 2017/2/26.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "ProgressHUD.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width        // 屏幕宽度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height      // 屏幕高度
// 状态栏高度
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define INDICATOR_W_H 35.f          // 转动菊花宽高
#define VERTICAL_SPACE 10.f         // 竖直间隔
#define HORIZONTAL_SPACE 16.f       // 水平间隔

// 背景色+图标
typedef NS_ENUM(NSInteger, AnbToastType) {
    
    AnbToastTypeDefault = 0, // 默认
    AnbToastTypeSuccess = 1, // 成功
    AnbToastTypeError   = 2, // 失败
    AnbToastTypeWarning = 3, // 警告
    AnbToastTypeLoading = 4, // 加载
    
};

typedef NS_ENUM(NSInteger, AnbToastPosition) {
    
    AnbToastPositionDefault                         = 0, // 默认顶部下滑
    AnbToastPositionBelowStatusBar                  = 1, // status下滑（没圆角）
    AnbToastPositionBelowStatusBarWithFillet        = 2, // status下滑（带圆角）
    AnbToastPositionBottom                          = 3, // bottom弹窗（没圆角）
    AnbToastPositionBottomWithFillet                = 4, // bottom弹窗（带圆角）
    AnbToastPositionCenterLoadingLeft               = 5, // center加载（没圆角,菊花在文字左边）
    AnbToastPositionCenterLoadingLeftWithFillet     = 6, // center加载（带圆角,菊花在文字左边）
    AnbToastPositionCenterLoadingTop                = 7, // center加载（没圆角,菊花在文字上边）
    AnbToastPositionCenterLoadingTopWithFillet      = 8, // center加载（带圆角,菊花在文字上边）
};
@interface ProgressHUD ()

// Toast加载菊花
@property(nonatomic, strong) UIActivityIndicatorView *indicator;
// Toast图标ImageView
@property(nonatomic, strong) UIImageView    *iconImageView;
// Toast内容Label
@property(nonatomic, strong) UILabel        *messageLabel;

@property (nonatomic, copy) NSString        *messageString;
@property (nonatomic, strong) UIImage       *iconImage;

@property (nonatomic, assign) CGSize        messageLabelSize;
@property (nonatomic, assign) CGSize        iconImageSize;
@property (nonatomic, assign) CGRect        toastViewFrame;

// 背景色
@property (nonatomic, assign) AnbToastType  toastType;
// Toast显示位置
@property (nonatomic, assign) AnbToastPosition toastPosition;
//背景颜色
@property (nonatomic, strong) UIColor *toastBackgroundColor;
//Toast内容文字颜色
@property (nonatomic, strong) UIColor *messageTextColor;
//Toast文字字体
@property (nonatomic, strong) UIFont *messageFont;
//Toast View圆角
@property (nonatomic, assign) CGFloat toastCornerRadius;
//Toast View透明度
@property (nonatomic, assign) CGFloat toastAlpha;
//Toast消失动画是否启用
@property (nonatomic, assign) BOOL dismissToastAnimated;
//Toast显示时长
@property (nonatomic, assign) NSTimeInterval duration;

@end


@implementation ProgressHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
#pragma mark - prepareUI
- (void)setupSubviews
{
    self.indicator = [[UIActivityIndicatorView alloc] init];
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.indicator startAnimating];
    [self addSubview:self.indicator];
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.image = self.iconImage;
    [self addSubview:self.iconImageView];
    
    self.messageLabel = [[UILabel alloc]init];
    self.messageLabel.text = self.messageString;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    [self addSubview:self.messageLabel];
}
#pragma mark - getSize & initial
/**
 初始化Toast基本配置（可以在这里修改一些默认效果）
 */
-(void)initToastConfig{
    
    //默认背景色
    self.toastBackgroundColor = [UIColor darkGrayColor];
    
    //TextColor
    self.messageTextColor = [UIColor whiteColor];
    
    //TextFont
    self.messageFont = [UIFont systemFontOfSize:20.f weight:UIFontWeightMedium];
    
    self.toastCornerRadius = 0.f;
    self.toastAlpha = 1.f;
    
    self.dismissToastAnimated = YES;
    
    //默认显示3s
    if (self.duration == 0) {
        self.duration = 3.f;
    }
}

/**
 根据消息内容获取消息size
 
 @param message  消息文字
 @param maxWidth 消息最大宽度
 @return 消息size
 */
- (CGSize)sizeForMessageString:(NSString*)message maxWidth:(CGFloat)maxWidth{
    
    if (!message || message.length == 0) {
        return CGSizeMake(0, 0);
    }
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    
    CGSize messageSize = [message boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSParagraphStyleAttributeName : paragraphStyle,
                                                         NSFontAttributeName : _messageFont}
                                               context:nil].size;
    return messageSize;
}

@end
