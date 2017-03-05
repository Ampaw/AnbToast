//
//  PywProgressHUD.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/1.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywProgressHUD.h"

#define TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

static CGFloat const kMargin = 16;
static CGFloat const kPadding = 8;

@interface PywProgressHUD()

@property (nonatomic, strong) UIView    *indicator;
@property (nonatomic, strong) UILabel   *label;

@property (nonatomic, assign) CGSize    totalSize;
@property (nonatomic, strong) NSString  *labelText;
@property (nonatomic, assign) PywProgressHUDMode    mode;
@property (nonatomic, assign) PywProgressHUDStyle   style;

@end

@implementation PywProgressHUD

static NSMutableArray *toastArray = nil;

#pragma mark - classMethod
+ (void)hideHUD
{
    PywProgressHUD *hud = [[PywProgressHUD alloc] init];
    [hud hide];
}
+ (void)showWithMessage:(NSString *)message
                   mode:(PywProgressHUDMode)mode
                  style:(PywProgressHUDStyle)style
{
    [PywProgressHUD showWithMessage:message mode:mode style:style toView:nil];
}
+ (void)showWithMessage:(NSString *)message
                   mode:(PywProgressHUDMode)mode
                  style:(PywProgressHUDStyle)style
                 toView:(UIView *)view
{
    PywProgressHUD *hud = [[PywProgressHUD alloc] initWithView:view];
    hud.labelText = message;
    if (!message) {
        hud.mode = PywProgressHUDModeIndeterminate;
    }else{
        hud.mode = mode;
    }
    hud.style = style;
    [hud showToView:view];
}

#pragma mark - initial
- (instancetype)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _mode = PywProgressHUDModeIndeterminate;
        _labelText = nil;
        _totalSize = CGSizeZero;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.8;
        
        [self setupView];
        [self updateIndicators];
        [self registerForKVO];
    }
    return self;
}

- (void)setupView {
    if (!toastArray) {
        toastArray = [NSMutableArray new];
    }
    
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.adjustsFontSizeToFitWidth = NO;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightMedium];
    _label.textColor = [UIColor whiteColor];
    _label.text = self.labelText;
    [self addSubview:_label];
}


- (void)updateIndicators {
    
    BOOL isActivityIndicator = [_indicator isKindOfClass:[UIActivityIndicatorView class]];
    
    if (_mode == PywProgressHUDModeIndeterminate) {
        if (!isActivityIndicator) {
            [_indicator removeFromSuperview];
            self.indicator = ([[UIActivityIndicatorView alloc]
                               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
            [(UIActivityIndicatorView *)_indicator startAnimating];
            [self addSubview:_indicator];
        }
    } else if (_mode == PywProgressHUDModeText) {
        [_indicator removeFromSuperview];
        self.indicator = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 覆盖整个视图，屏蔽交互操作
    UIView *parent = self.superview;
    if (parent) {
        self.frame = parent.bounds;
    }
    CGRect bounds = self.bounds;
    
    CGFloat maxWidth = bounds.size.width - 4 * kMargin;
    CGSize totalSize = CGSizeZero;
    
    CGRect indicatorF = _indicator.bounds;
    indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
    totalSize.width = MAX(totalSize.width, indicatorF.size.width);
    totalSize.height += indicatorF.size.height;
    
    CGSize labelSize = TEXTSIZE(_label.text, _label.font);
    labelSize.width = MIN(labelSize.width, maxWidth);
    totalSize.width = MAX(totalSize.width, labelSize.width);
    totalSize.height += labelSize.height;
    if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
        totalSize.height += kPadding;
    }
    
    totalSize.width += 2 * kMargin;
    totalSize.height += 2 * kMargin;
    
    // Position elements
    CGFloat yPos = round(((bounds.size.height - totalSize.height) / 2)) + kMargin;
    CGFloat xPos = 0;
    indicatorF.origin.y = yPos;
    indicatorF.origin.x = round((bounds.size.width - indicatorF.size.width) / 2) + xPos;
    _indicator.frame = indicatorF;
    yPos += indicatorF.size.height;
    
    if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
        yPos += kPadding;
    }
    CGRect labelF;
    labelF.origin.y = yPos;
    labelF.origin.x = round((bounds.size.width - labelSize.width) / 2) + xPos;
    labelF.size = labelSize;
    _label.frame = labelF;
    
    _totalSize = totalSize;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    CGContextSetGrayFillColor(context, 0.0f, 0.8);
    
    CGRect allRect = self.bounds;
    CGRect boxRect = CGRectMake(round((allRect.size.width - _totalSize.width) / 2),
                                round((allRect.size.height - _totalSize.height) / 2),
                                _totalSize.width,
                                _totalSize.height);
    float radius = 10;
    if (self.style == PywProgressHUDStyleLine) { // 没圆角
        radius = 0;
    }
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    UIGraphicsPopContext();
}

#pragma mark - show & hide
- (void)showToView:(UIView *)view{

    //显示之前先把之前的移除
    if ([toastArray count] != 0) {
        [self performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:YES];
    }
    
    @synchronized (toastArray) {
        if (!view) {
            UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
            [windowView addSubview:self];
        }else
        {
            [view addSubview:self];
        }
        
        [UIView animateWithDuration:0.5f
                              delay:0.f
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0.5f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.alpha = 1.f;
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [toastArray addObject:self];
    }
}
-(void)hide{
    
    if (toastArray && [toastArray count] > 0) {
        @synchronized (toastArray) {
            
            PywProgressHUD *hud = toastArray[0];
            [NSRunLoop cancelPreviousPerformRequestsWithTarget:hud];
            [toastArray removeObject:hud];
            
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 hud.alpha = 0.f;
                             } completion:^(BOOL finished) {
                                 [hud removeFromSuperview];
                             }];
        }
    }
}

#pragma mark - KVO
- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"mode", @"labelText", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:)
                               withObject:keyPath
                            waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"mode"]) {
        [self updateIndicators];
    } else if ([keyPath isEqualToString:@"labelText"]) {
        _label.text = self.labelText;
    }
}
- (void)dealloc {
    [self unregisterFromKVO];
}

@end
