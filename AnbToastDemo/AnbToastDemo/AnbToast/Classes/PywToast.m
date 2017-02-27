//
//  PywToast.m
//  PywToastDemo
//
//  Created by Ampaw on 2017/2/26.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywToast.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define INDICATOR_W_H 35.f

#define VERTICAL_SPACE 10.f
#define HORIZONTAL_SPACE 16.f
#define BOTTOM_SPACE 80.f
#define BOTTOM_HORIZONTAL_MAX_SPACE 20.f


@interface PywToast ()
// Toast加载菊花
@property(nonatomic, strong) UIActivityIndicatorView *indicator;
// Toast图标ImageView
@property(nonatomic, strong) UIImageView    *iconImageView;
// Toast内容Label
@property(nonatomic, strong) UILabel        *messageLabel;
@property(nonatomic, strong) UIView         *hudView;

@property (nonatomic, copy) NSString        *messageString;
@property (nonatomic, strong) UIImage       *iconImage;

@property (nonatomic, assign) CGSize        messageLabelSize;
@property (nonatomic, assign) CGSize        iconImageSize;
@property (nonatomic, assign) CGRect        toastViewFrame;

// Toast显示位置
@property (nonatomic, assign) PywToastPosition toastPosition;

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

@implementation PywToast


static NSMutableArray* toastArray = nil;

#pragma mark - ClassMethod
+ (void)hideToast
{
    PywToast *toast = [[PywToast alloc] init];
    [toast hide];
}
+ (void)showToastWithMessage:(NSString *)message
                    position:(PywToastPosition)position
{
    [self showToastWithMessage:message iconImage:nil position:position];
}
+ (void)showToastWithMessage:(NSString *)message
                   iconImage:(UIImage *)iconImg
                    position:(PywToastPosition)position
{
    PywToast *toast = [[PywToast alloc] initToastWithMessage:message
                                                   iconImage:iconImg
                                                    duration:0
                                               toastPosition:position];
    [toast show];
}

#pragma mark - initial
/**
 初始化一个Toast，包含toastType
 
 @param message 内容
 @param iconImage 图标
 @param duration 显示时长
 @return 新建的Toast
 */
- (instancetype)initToastWithMessage:(NSString *)message
                           iconImage:(UIImage*)iconImage
                            duration:(NSTimeInterval)duration
                       toastPosition:(PywToastPosition)toastPosition{
    
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
        if (self.toastPosition == PywToastPositionDefault) {
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
        self.hudView = [[UIView alloc] init];
        self.hudView.backgroundColor = [UIColor darkGrayColor];
        
        self.indicator = [[UIActivityIndicatorView alloc] init];
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.indicator startAnimating];

        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.image = self.iconImage;
        
        
        self.messageLabel = [[UILabel alloc]init];
        self.messageLabel.text = self.messageString;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.numberOfLines = 0;
        
        
        if ([self isLoading])
        {
            [self.hudView addSubview:self.indicator];
            [self.hudView addSubview:self.messageLabel];
        } else
        {
            [self addSubview:self.iconImageView];
            [self addSubview:self.messageLabel];
        }
    }
    return self;
}


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
        case PywToastPositionDefault: {
            self.frame = CGRectMake(_toastViewFrame.origin.x,
                                    -_toastViewFrame.size.height,
                                    _toastViewFrame.size.width,
                                    _toastViewFrame.size.height);
            break;
        }
        case PywToastPositionBelowStatusBar: {
            self.frame = CGRectMake(_toastViewFrame.origin.x,
                                    -(_toastViewFrame.size.height + STATUSBAR_HEIGHT),
                                    _toastViewFrame.size.width,
                                    _toastViewFrame.size.height);
            break;
        }
        case PywToastPositionBelowStatusBarWithFillet: {
            self.frame = CGRectMake(_toastViewFrame.origin.x,
                                    -(_toastViewFrame.size.height + STATUSBAR_HEIGHT),
                                    _toastViewFrame.size.width,
                                    _toastViewFrame.size.height);
            break;
        }
        case PywToastPositionBottom: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case PywToastPositionBottomWithFillet: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case PywToastPositionCenterLoadingLeft: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case PywToastPositionCenterLoadingLeftWithFillet: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case PywToastPositionCenterLoadingTop: {
            self.frame = _toastViewFrame;
            self.alpha = 0.f;
            break;
        }
        case PywToastPositionCenterLoadingTopWithFillet: {
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
    if (self.toastPosition == PywToastPositionDefault) {
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
        messageLabelY = (_toastViewFrame.size.height - self.messageLabelSize.height - tempStatusBarHeight)/2 + tempStatusBarHeight;
    }
    else
    {
        // 菊花在文字左边
        if (self.toastPosition == PywToastPositionCenterLoadingLeft
            || self.toastPosition == PywToastPositionCenterLoadingLeftWithFillet)
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
        else if (self.toastPosition == PywToastPositionCenterLoadingTop
                 || self.toastPosition == PywToastPositionCenterLoadingTopWithFillet)
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
    
    if ([self isLoading]) {
        UIView *parent = self.superview;
        if (parent) {
            self.frame = parent.bounds;
        }
        parent.alpha = 0.8;
        self.hudView.frame = CGRectMake((SCREEN_WIDTH - self.toastViewFrame.size.width) / 2, (SCREEN_HEIGHT - self.toastViewFrame.size.height) / 2, self.toastViewFrame.size.width, self.toastViewFrame.size.height);
    }
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
            
            PywToast* toast = toastArray[0];
            [NSRunLoop cancelPreviousPerformRequestsWithTarget:toast];
            [toastArray removeObject:toast];
            
            if (self.dismissToastAnimated == YES
                && _toastPosition != PywToastPositionBottom
                && _toastPosition != PywToastPositionBottomWithFillet) {
                
                CGFloat tempStatusBarHeight = 0;
                if (self.toastPosition == PywToastPositionDefault) {
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
    
    if (self.toastPosition == PywToastPositionBelowStatusBar
        || self.toastPosition == PywToastPositionBelowStatusBarWithFillet) {
        textMaxWidth -= 2*HORIZONTAL_SPACE;
    }else if(self.toastPosition == PywToastPositionBottom
             || self.toastPosition == PywToastPositionBottomWithFillet){
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
        case PywToastPositionDefault: {
            toastViewW = SCREEN_WIDTH;
            toastViewH += STATUSBAR_HEIGHT;
            break;
        }
        case PywToastPositionBelowStatusBar: {
            toastViewY = STATUSBAR_HEIGHT;
            toastViewW = SCREEN_WIDTH;
            break;
        }
        case PywToastPositionBelowStatusBarWithFillet: {
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
        case PywToastPositionBottom: {
            
            toastViewW = _messageLabelSize.width + 2* HORIZONTAL_SPACE;
            
            if (self.iconImage != nil) {
                toastViewW += _iconImageSize.width + HORIZONTAL_SPACE;
                
            }
            
            toastViewX = (SCREEN_WIDTH - toastViewW)/2;
            toastViewY = SCREEN_HEIGHT - toastViewH - BOTTOM_SPACE;
            
            break;
        }
        case PywToastPositionBottomWithFillet: {
            
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
        case PywToastPositionCenterLoadingTop: {
            
            toastViewW = (_messageLabelSize.width + 2 * HORIZONTAL_SPACE) > (INDICATOR_W_H + 2 * HORIZONTAL_SPACE) ? (_messageLabelSize.width + 2 * HORIZONTAL_SPACE) : (INDICATOR_W_H + 2 * HORIZONTAL_SPACE);
            
            toastViewX = (SCREEN_WIDTH - toastViewW) / 2;
            toastViewY = (SCREEN_HEIGHT - toastViewH) / 2;
            toastViewH = INDICATOR_W_H + _messageLabelSize.height + 3 * VERTICAL_SPACE;
            
            break;
        }
        case PywToastPositionCenterLoadingTopWithFillet: {
            
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
        case PywToastPositionCenterLoadingLeft: {
            
            toastViewW = INDICATOR_W_H + _messageLabelSize.width + 2 * BOTTOM_HORIZONTAL_MAX_SPACE;
            
            toastViewX = (SCREEN_WIDTH - toastViewW) / 2;
            toastViewY = (SCREEN_HEIGHT - toastViewH) / 2;
            
            break;
        }
        case PywToastPositionCenterLoadingLeftWithFillet: {
            
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

- (UIImage*)imageNamed:(NSString*)name {
    NSBundle * pbundle = [NSBundle bundleForClass:[self class]];
    NSString *bundleURL = [pbundle pathForResource:@"Toast" ofType:@"bundle"];
    NSBundle *imagesBundle = [NSBundle bundleWithPath:bundleURL];
    UIImage * image = [UIImage imageNamed:name inBundle:imagesBundle compatibleWithTraitCollection:nil];
    return image;
}

/**
 *  Toast是否为网络请求样式
 */
- (BOOL)isLoading
{
    return (   self.toastPosition == PywToastPositionCenterLoadingLeft
            || self.toastPosition == PywToastPositionCenterLoadingLeftWithFillet
            || self.toastPosition == PywToastPositionCenterLoadingTop
            || self.toastPosition == PywToastPositionCenterLoadingTopWithFillet);
}

@end
