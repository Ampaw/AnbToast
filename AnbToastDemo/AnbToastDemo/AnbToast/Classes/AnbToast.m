//
//  AnbToast.m
//  PywToastDemo
//
//  Created by Ampaw on 2017/2/23.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "AnbToast.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define INDICATOR_W_H 35.f

#define VERTICAL_SPACE 10.f
#define HORIZONTAL_SPACE 16.f
#define BOTTOM_SPACE 80.f
#define BOTTOM_HORIZONTAL_MAX_SPACE 20.f

// 背景色+图标
typedef NS_ENUM(NSInteger, AnbToastType) {
    
    AnbToastTypeDefault = 0, // 默认
    AnbToastTypeSuccess = 1, // 成功
    AnbToastTypeError   = 2, // 失败
    AnbToastTypeWarning = 3, // 警告
    AnbToastTypeLoading = 4, // 加载
    
};


@interface AnbToast ()

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
@property (nonatomic, strong) UIColor* toastBackgroundColor;
//Toast内容文字颜色
@property (nonatomic, strong) UIColor* messageTextColor;
//Toast文字字体
@property (nonatomic, strong) UIFont* messageFont;
//Toast View圆角
@property (nonatomic, assign) CGFloat toastCornerRadius;
//Toast View透明度
@property (nonatomic, assign) CGFloat toastAlpha;
//Toast消失动画是否启用
@property (nonatomic, assign) BOOL dismissToastAnimated;
//Toast显示时长
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation AnbToast

static NSMutableArray* toastArray = nil;

#pragma mark - ClassMethod
+ (void)hideToast
{
    AnbToast *toast = [[AnbToast alloc] init];
    [toast hide];
}
+ (void)showToastWithMessage:(NSString *)message
                    position:(AnbToastPosition)position
{
    [self showToastWithMessage:message iconImage:nil position:position];
}
+ (void)showToastWithMessage:(NSString *)message
                   iconImage:(UIImage *)iconImg
                    position:(AnbToastPosition)position
{
    AnbToast *toast = [[AnbToast alloc] initToastWithMessage:message
                                                   iconImage:iconImg
                                                    duration:0
                                                   toastType:AnbToastTypeDefault
                                               toastPosition:position];
    [toast show];
}

#pragma mark - initial
/**
 初始化一个Toast，包含toastType
 
 @param message 内容
 @param iconImage 图标
 @param duration 显示时长
 @param toastType toast类型
 @return 新建的Toast
 */
- (instancetype)initToastWithMessage:(NSString *)message
                           iconImage:(UIImage*)iconImage
                            duration:(NSTimeInterval)duration
                           toastType:(AnbToastType)toastType
                       toastPosition:(AnbToastPosition)toastPosition{
    
    self.toastType = toastType;
    self.duration = duration;
    self.toastPosition = toastPosition;
    
    return [self initToastWithMessage:message iconImage:iconImage];
}

- (instancetype)initToastWithMessage:(NSString *)message
                            iconImage:(UIImage*)iconImage{
    
    [self initToastConfig];
    
    if (!toastArray) {
        toastArray = [NSMutableArray new];
    }
    
    self.messageString = message;
    
    if (iconImage == nil) {
        if (self.toastType == AnbToastPositionDefault) {
            self.iconImage = nil;
        }
    }else{
        self.iconImage = iconImage;
    }
    
    self.iconImageSize = self.iconImage == nil ? CGSizeZero : CGSizeMake(35.f, 35.f);
    
    return [self init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        if ([self isLoading]) {
            
            self.indicator = [[UIActivityIndicatorView alloc] init];
            self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [self.indicator startAnimating];
            [self addSubview:self.indicator];
        }
        
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
    return self;
}


/**
 初始化Toast基本配置（可以在这里修改一些默认效果）
 */
-(void)initToastConfig{
    
    //默认背景色
    self.toastBackgroundColor = [UIColor darkGrayColor];
    
    //根据toastType设置背景色、icon
    switch (self.toastType) {
        case AnbToastPositionDefault: {
            self.toastBackgroundColor = [UIColor darkGrayColor];
            break;
        }
        case AnbToastTypeSuccess: {
            self.toastBackgroundColor = [UIColor colorWithRed:31.f/255.f green:177.f/255.f blue:138.f/255.f alpha:1.f];
            if (!_iconImage) {
                self.iconImage = [self imageNamed:@"toast_success"];
            }
            break;
        }
        case AnbToastTypeError: {
            self.toastBackgroundColor = [UIColor colorWithRed:255.f/255.f green:91.f/255.f blue:65.f/255.f alpha:1.f];
            if (!_iconImage) {
                self.iconImage = [self imageNamed:@"toast_error"];
            }
            break;
        }
        case AnbToastTypeWarning: {
            self.toastBackgroundColor = [UIColor colorWithRed:255.f/255.f green:134.f/255.f blue:0.f/255.f alpha:1.f];
            if (!_iconImage) {
                self.iconImage = [self imageNamed:@"toast_warning"];
            }
            break;
        }
        case AnbToastTypeLoading: {
            self.toastBackgroundColor = [UIColor colorWithRed:75.f/255.f green:107.f/255.f blue:122.f/255.f alpha:1.f];
            if (!_iconImage) {
                self.iconImage = [self imageNamed:@"toast_info"];
            }
            break;
        }
            
        default:
            break;
    }
    
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
#pragma mark - layout
/**
 设置Toast的frame、属性及内部控件的属性等
 */
-(void)layoutToastView{
    
    //设置子控件属性
    self.messageLabel.textColor = _messageTextColor;
    self.messageLabel.font = _messageFont;
    
    
    self.backgroundColor = _toastBackgroundColor;
    
    self.alpha = _toastAlpha;
    self.layer.cornerRadius = _toastCornerRadius;
    self.layer.masksToBounds = YES;
    
    self.toastViewFrame = [self toastViewFrame];
    
    //上滑消失
    switch (self.toastPosition) {
        case AnbToastPositionDefault: {
            self.frame = CGRectMake(_toastViewFrame.origin.x, -_toastViewFrame.size.height, _toastViewFrame.size.width, _toastViewFrame.size.height);
            break;
        }
        case AnbToastPositionBelowStatusBar: {
            self.frame = CGRectMake(_toastViewFrame.origin.x, -(_toastViewFrame.size.height + STATUSBAR_HEIGHT), _toastViewFrame.size.width, _toastViewFrame.size.height);
            break;
        }
        case AnbToastPositionBelowStatusBarWithFillet: {
            self.frame = CGRectMake(_toastViewFrame.origin.x, -(_toastViewFrame.size.height + STATUSBAR_HEIGHT), _toastViewFrame.size.width, _toastViewFrame.size.height);
            break;
        }
        case AnbToastPositionBottom: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case AnbToastPositionBottomWithFillet: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case AnbToastPositionCenterLoadingLeft: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case AnbToastPositionCenterLoadingLeftWithFillet: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case AnbToastPositionCenterLoadingTop: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case AnbToastPositionCenterLoadingTopWithFillet: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        default:
            break;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat tempStatusBarHeight = 0;
    if (self.toastPosition == AnbToastPositionDefault) {
        tempStatusBarHeight = STATUSBAR_HEIGHT;
    }
    
    CGFloat messageLabelX = 0;
    CGFloat messageLabelY = 0;
    
    // 判断是不是网络请求加载
    if (![self isLoading])
    {
    
        CGFloat iconImageViewX = HORIZONTAL_SPACE;
        if (_messageLabelSize.width == 0) {
            iconImageViewX = (_toastViewFrame.size.width - _iconImageSize.width) / 2;
        }
        CGFloat iconImageViewY = (_toastViewFrame.size.height - self.iconImageSize.width - tempStatusBarHeight)/2 + tempStatusBarHeight;
        CGFloat iconImageViewW = self.iconImageSize.width;
        CGFloat iconImageViewH = self.iconImageSize.height;
        self.iconImageView.frame = CGRectMake(iconImageViewX, iconImageViewY, iconImageViewW, iconImageViewH);
        
        messageLabelX = CGSizeEqualToSize(self.iconImageSize, CGSizeZero) ? HORIZONTAL_SPACE : iconImageViewX + iconImageViewW + HORIZONTAL_SPACE;
        if (_iconImageSize.width == 0) {
            messageLabelX = (_toastViewFrame.size.width - _messageLabelSize.width) / 2;
        }
        messageLabelY = (self.toastViewFrame.size.height - self.messageLabelSize.height - tempStatusBarHeight)/2 + tempStatusBarHeight;
    }
    else
    {
        // 菊花在文字左边
        if (self.toastPosition == AnbToastPositionCenterLoadingLeft
            || self.toastPosition == AnbToastPositionCenterLoadingLeftWithFillet)
        {
            
            CGFloat indicatorX = HORIZONTAL_SPACE;
            if (_messageLabelSize.width == 0) {
                indicatorX = (_toastViewFrame.size.width - INDICATOR_W_H) / 2;
            }
            CGFloat indicatorY = (_toastViewFrame.size.height - INDICATOR_W_H) / 2;
            CGFloat indicatorW = INDICATOR_W_H;
            CGFloat indicatorH = INDICATOR_W_H;
            self.indicator.frame = CGRectMake(indicatorX, indicatorY, indicatorW, indicatorH);
            
            messageLabelX = INDICATOR_W_H + 2 * HORIZONTAL_SPACE;
            messageLabelY = (self.toastViewFrame.size.height - self.messageLabelSize.height - tempStatusBarHeight)/2 + tempStatusBarHeight;
        }
        // 菊花在文字上边
        else if (self.toastPosition == AnbToastPositionCenterLoadingTop
                   || self.toastPosition == AnbToastPositionCenterLoadingTopWithFillet)
        {
            CGFloat indicatorX = (_toastViewFrame.size.width - INDICATOR_W_H) / 2;
            CGFloat indicatorY = VERTICAL_SPACE;
            CGFloat indicatorW = INDICATOR_W_H;
            CGFloat indicatorH = INDICATOR_W_H;
            self.indicator.frame = CGRectMake(indicatorX, indicatorY, indicatorW, indicatorH);
            
            messageLabelX = HORIZONTAL_SPACE;
            messageLabelY = INDICATOR_W_H + 2 * VERTICAL_SPACE;
        }
    }
    
    CGFloat messageLabelW = self.messageLabelSize.width;
    CGFloat messageLabelH = self.messageLabelSize.height;
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelW, messageLabelH);
}

- (UIImage*)imageNamed:(NSString*)name {
    NSBundle * pbundle = [NSBundle bundleForClass:[self class]];
    NSString *bundleURL = [pbundle pathForResource:@"FFToast" ofType:@"bundle"];
    NSBundle *imagesBundle = [NSBundle bundleWithPath:bundleURL];
    UIImage * image = [UIImage imageNamed:name inBundle:imagesBundle compatibleWithTraitCollection:nil];
    return image;
}


#pragma mark - show & hide
/**
 显示一个Toast
 */
- (void)show{
    
    [self layoutToastView];
    
    //显示之前先把之前的移除
    if ([toastArray count] != 0) {
        [self performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:YES];
    }
    
    @synchronized (toastArray) {
        
        UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
        [windowView addSubview:self];
        
        [UIView animateWithDuration:0.5f
                              delay:0.f
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0.5f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame = _toastViewFrame;
                             self.alpha = _toastAlpha;
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [toastArray addObject:self];
        if (![self isLoading]) {
            [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
        }
    }
}

/**
 隐藏一个Toast
 */
-(void)hide{
    
    if (toastArray && [toastArray count] > 0) {
        @synchronized (toastArray) {
            
            AnbToast* toast = toastArray[0];
            [NSRunLoop cancelPreviousPerformRequestsWithTarget:toast];
            [toastArray removeObject:toast];
            
            if (self.dismissToastAnimated == YES
                && _toastPosition != AnbToastPositionBottom
                && _toastPosition != AnbToastPositionBottomWithFillet) {
                
                CGFloat tempStatusBarHeight = 0;
                if (self.toastPosition == AnbToastPositionDefault) {
                    tempStatusBarHeight = STATUSBAR_HEIGHT;
                }
                
                [UIView animateWithDuration:0.2f
                                 animations:^{
                                     toast.alpha = 0.f;
                                     self.frame = CGRectMake(_toastViewFrame.origin.x,
                                                             -(_toastViewFrame.size.height + tempStatusBarHeight),
                                                             _toastViewFrame.size.width,
                                                             _toastViewFrame.size.height);
                                 } completion:^(BOOL finished) {
                                     [self.indicator stopAnimating];
                                     [toast removeFromSuperview];
                                 }];
                
                
            }else{
                [UIView animateWithDuration:0.2f
                                 animations:^{
                                     toast.alpha = 0.f;
                                 } completion:^(BOOL finished) {
                                     [self.indicator stopAnimating];
                                     [toast removeFromSuperview];
                                 }];
            }
            
        }
    }
}

#pragma mark - resource
/**
 计算ToastView的frame
 
 @return ToastView的frame
 */
-(CGRect)toastViewFrame{
    
    CGFloat textMaxWidth = 0;
    if (self.iconImage == nil) {
        textMaxWidth = SCREEN_WIDTH - 2*HORIZONTAL_SPACE;
    }else{
        textMaxWidth = SCREEN_WIDTH - _iconImageSize.width - 3*HORIZONTAL_SPACE;
    }
    
    if (self.toastPosition == AnbToastPositionBelowStatusBar
        || self.toastPosition == AnbToastPositionBelowStatusBarWithFillet) {
        textMaxWidth -= 2*HORIZONTAL_SPACE;
    }else if(self.toastPosition == AnbToastPositionBottom
             || self.toastPosition == AnbToastPositionBottomWithFillet){
        textMaxWidth -= 2*BOTTOM_HORIZONTAL_MAX_SPACE;
    }
    
    self.messageLabelSize = [self sizeForMessageString:_messageString maxWidth:textMaxWidth];
    
    
    CGFloat toastViewX = 0;
    CGFloat toastViewY = 0;
    CGFloat toastViewW = 0;
    CGFloat toastViewH = 0;
    if(self.iconImage == nil){
        //没有图标
        toastViewH = self.messageLabelSize.height + 2 * VERTICAL_SPACE;
        if ([self isLoading]) {
            if (_messageLabelSize.height == 0) {
                toastViewH = INDICATOR_W_H + 2 * VERTICAL_SPACE;
            }else{
                toastViewH = self.messageLabelSize.height + INDICATOR_W_H;
            }
        }
        
    }else{
        //有图标
        CGFloat toastViewHTemp = 0;
        CGFloat toastViewHTemp2 = self.iconImageSize.height + 2 * VERTICAL_SPACE;
        toastViewHTemp = self.messageLabelSize.height + 2 * VERTICAL_SPACE;
        toastViewH = toastViewHTemp > toastViewHTemp2 ? toastViewHTemp : toastViewHTemp2;
    }
    
    switch (self.toastPosition) {
        case AnbToastPositionDefault: {
            toastViewW = SCREEN_WIDTH;
            toastViewH += STATUSBAR_HEIGHT;
            break;
        }
        case AnbToastPositionBelowStatusBar: {
            toastViewY = STATUSBAR_HEIGHT;
            toastViewW = SCREEN_WIDTH;
            break;
        }
        case AnbToastPositionBelowStatusBarWithFillet: {
            toastViewX = HORIZONTAL_SPACE;
            toastViewY = STATUSBAR_HEIGHT;
            toastViewW = SCREEN_WIDTH - 2*HORIZONTAL_SPACE;
            
            if (self.toastCornerRadius == 0) {
                self.toastCornerRadius = 5.f;
            }
            self.layer.cornerRadius = _toastCornerRadius;
            self.layer.masksToBounds = YES;
            
            break;
        }
        case AnbToastPositionBottom: {
            
            toastViewW = _messageLabelSize.width + 2* HORIZONTAL_SPACE;
            
            if (self.iconImage != nil) {
                toastViewW += _iconImageSize.width + HORIZONTAL_SPACE;
                
            }
            
            toastViewX = (SCREEN_WIDTH - toastViewW)/2;
            toastViewY = SCREEN_HEIGHT - toastViewH - BOTTOM_SPACE;
            
            break;
        }
        case AnbToastPositionBottomWithFillet: {
            
            toastViewW = _messageLabelSize.width + 2* HORIZONTAL_SPACE;
            
            if (self.iconImage != nil) {
                toastViewW += _iconImageSize.width + HORIZONTAL_SPACE;
                
                if ((_messageLabelSize.height + 2*HORIZONTAL_SPACE) > _iconImageSize.height + 2*HORIZONTAL_SPACE) {
                    toastViewH = _messageLabelSize.height + 2*HORIZONTAL_SPACE;
                }else{
                    toastViewH = _iconImageSize.height + 2*HORIZONTAL_SPACE;
                }
            }
            
            toastViewX = (SCREEN_WIDTH - toastViewW)/2;
            toastViewY = SCREEN_HEIGHT - toastViewH - BOTTOM_SPACE;
            
            if (self.toastCornerRadius == 0) {
                self.toastCornerRadius = 5.f;
            }
            self.layer.cornerRadius = _toastCornerRadius;
            self.layer.masksToBounds = YES;
        
            break;
        }
        case AnbToastPositionCenterLoadingTop: {
            
            toastViewW = (_messageLabelSize.width + 2 * HORIZONTAL_SPACE) > (INDICATOR_W_H + 2 * HORIZONTAL_SPACE) ? (_messageLabelSize.width + 2 * HORIZONTAL_SPACE) : (INDICATOR_W_H + 2 * HORIZONTAL_SPACE);
            
            toastViewX = (SCREEN_WIDTH - toastViewW) / 2;
            toastViewY = (SCREEN_HEIGHT - toastViewH) / 2;
            toastViewH = INDICATOR_W_H + _messageLabelSize.height + 3 * VERTICAL_SPACE;
            
            break;
        }
        case AnbToastPositionCenterLoadingTopWithFillet: {
            
            toastViewW = (_messageLabelSize.width + 2 * HORIZONTAL_SPACE) > (INDICATOR_W_H + 2 * HORIZONTAL_SPACE) ? (_messageLabelSize.width + 2 * HORIZONTAL_SPACE) : (INDICATOR_W_H + 2 * HORIZONTAL_SPACE);
            
            toastViewX = (SCREEN_WIDTH - toastViewW)/2;
            toastViewY = (SCREEN_HEIGHT - toastViewH) / 2;
            toastViewH = INDICATOR_W_H + _messageLabelSize.height + 3 * VERTICAL_SPACE;
            
            if (self.toastCornerRadius == 0) {
                self.toastCornerRadius = 5.f;
            }
            self.layer.cornerRadius = _toastCornerRadius;
            self.layer.masksToBounds = YES;
            
            break;
        }
        case AnbToastPositionCenterLoadingLeft: {
            
            toastViewW = INDICATOR_W_H + _messageLabelSize.width + 2 * BOTTOM_HORIZONTAL_MAX_SPACE;
            
            toastViewX = (SCREEN_WIDTH - toastViewW) / 2;
            toastViewY = (SCREEN_HEIGHT - toastViewH) / 2;
            
            break;
        }
        case AnbToastPositionCenterLoadingLeftWithFillet: {
            
           toastViewW = INDICATOR_W_H + _messageLabelSize.width + 3 * HORIZONTAL_SPACE;
            
            toastViewX = (SCREEN_WIDTH - toastViewW)/2;
            toastViewY = (SCREEN_HEIGHT - toastViewH) / 2;
            
            if (self.toastCornerRadius == 0) {
                self.toastCornerRadius = 5.f;
            }
            self.layer.cornerRadius = _toastCornerRadius;
            self.layer.masksToBounds = YES;
            
            break;
        }
            
        default:
            break;
    }
    
    if (toastViewW > SCREEN_WIDTH * 0.8) {
        toastViewW = SCREEN_WIDTH * 0.8;
        toastViewX = (SCREEN_WIDTH - toastViewW) / 2;
    }
    
    return CGRectMake(toastViewX, toastViewY - 3, toastViewW, toastViewH + 3);
}


/**
 根据消息内容获取消息size
 
 @param message  消息文字
 @param maxWidth 消息最大宽度
 @return 消息size
 */
- (CGSize)sizeForMessageString:(NSString*)message maxWidth:(CGFloat) maxWidth{
    
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

/**
 *  Toast是否为网络请求样式
 */
- (BOOL)isLoading
{
    return (   self.toastPosition == AnbToastPositionCenterLoadingLeft
            || self.toastPosition == AnbToastPositionCenterLoadingLeftWithFillet
            || self.toastPosition == AnbToastPositionCenterLoadingTop
            || self.toastPosition == AnbToastPositionCenterLoadingTopWithFillet);
}

@end
