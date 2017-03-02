//
//  PywCustomButton.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/2/28.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywCustomButton.h"

//    按钮中文本和图片的间隔
#define padding 10
//    获得按钮的大小
#define buttonWidth self.bounds.size.width
#define buttonHeight self.bounds.size.height
//    获得按钮中UILabel文本的大小
#define labelWidth self.titleLabel.bounds.size.width
#define labelHeight self.titleLabel.bounds.size.height
//    获得按钮中image图标的大小
#define imageWidth self.imageView.bounds.size.width
#define imageHeight self.imageView.bounds.size.height

@interface PywCustomButton ()
@property(nonatomic, assign) PywCustomButtonStatus status;
@end

@implementation PywCustomButton

+ (instancetype)buttonWithAlignmentStatus:(PywCustomButtonStatus)status
{
    return [[self alloc] initWithAlignmentStatus:status];
}
- (instancetype)initWithAlignmentStatus:(PywCustomButtonStatus)status
{
    PywCustomButton *button = [[PywCustomButton alloc] init];
    button.status = status;
    return button;
}
- (void)setStatus:(PywCustomButtonStatus)status
{
    _status = status;
}
#pragma mark - 左对齐
- (void)alignmentLeft
{
    // 获取按钮的图片frame，设置其x坐标为0【左对齐】
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = 0;
    // 获取按钮的文本frame，设置其x坐标紧跟文本后面
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = (self.imageView.frame.size.width != 0) ? CGRectGetWidth(imageFrame) : padding;
    // 重新赋值frame
    self.titleLabel.frame = titleFrame;
    self.imageView.frame = imageFrame;
}
#pragma mark - 右对齐
- (void)alignmentRight
{
    // 计算文本的宽度
    CGRect frmae = [self calculateTitleFrame];
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = buttonWidth - imageWidth;
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = (self.imageView.frame.size.width != 0) ? (imageFrame.origin.x - frmae.size.width) : (imageFrame.origin.x - frmae.size.width - padding);
    // 重新赋值frame
    self.titleLabel.frame = titleFrame;
    self.imageView.frame = imageFrame;
}
#pragma mark - 居中对齐
- (void)alignmentCenter
{
    // 计算文本的坐标，并设置label的frame
    CGFloat labelX = (buttonWidth - labelWidth - imageWidth) * 0.5;
    CGFloat labelY = (buttonHeight - labelHeight) * 0.5;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    // 计算图片的坐标，并设置label的frame
    CGFloat imageX = CGRectGetMaxX(self.titleLabel.frame);
    CGFloat imageY = (buttonHeight - imageHeight) * 0.5;
    self.imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
}
#pragma mark - 图标在上，文本在下(居中)
- (void)alignmentTop
{
    CGFloat imageX = (buttonWidth - imageWidth) * 0.5;
    CGFloat imageY = buttonHeight * 0.5 - imageHeight;
    self.imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
    CGRect frmae = [self calculateTitleFrame];
    CGFloat labelX = (self.center.x - frmae.size.width) * 0.5;
    CGFloat labelY = buttonHeight * 0.5;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    
    // 设置中心对齐
    CGPoint labelCenter = self.titleLabel.center;
    labelCenter.x = self.imageView.center.x;
    self.titleLabel.center = labelCenter;
}
#pragma mark - 图标在下，文本在上(居中)
- (void)alignmentBottom
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGRect frame = [self calculateTitleFrame];
    CGFloat labelX = (self.center.x - frame.size.width) * 0.5;
    CGFloat labelY = buttonHeight * 0.5 - labelHeight;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    
    CGFloat imageX = (buttonWidth - imageWidth) * 0.5;
    CGFloat imageY = buttonHeight * 0.5;
    self.imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    
    // 设置中心对齐
    CGPoint labelCenter = self.titleLabel.center;
    labelCenter.x = self.imageView.center.x;
    self.titleLabel.center = labelCenter;
}
#pragma mark - 计算文本的宽度
- (CGRect)calculateTitleFrame
{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    dicM[NSFontAttributeName] = self.titleLabel.font;
    CGRect frmae = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:dicM
                                                      context:nil];
    return frmae;
}
#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (_status) {
        case PywCustomButtonStatusNormal:
            break;
        case PywCustomButtonStatusLeft:
        {
            [self alignmentLeft];
        }
            break;
        case PywCustomButtonStatusRight:
        {
            [self alignmentRight];
        }
            break;
        case PywCustomButtonStatusCenter:
        {
            [self alignmentCenter];
        }
            break;
        case PywCustomButtonStatusTop:
        {
            [self alignmentTop];
        }
            break;
        case PywCustomButtonStatusBottom:
        {
            [self alignmentBottom];
        }
            break;
        default:
            break;
    }
}

@end
