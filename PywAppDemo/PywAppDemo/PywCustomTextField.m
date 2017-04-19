//
//  PywCustomTextField.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/11.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywCustomTextField.h"
#import "Masonry/Masonry.h"

@interface PywCustomTextField ()
@property(nonatomic, strong) UIView *separatorLine; // 底部边框线

@property(nonatomic, strong) id customLeftView;
@property(nonatomic, strong) id customRightView;
@property(nonatomic, assign) CGFloat rightViewWidth;
@property(nonatomic, assign) CGFloat textFieldHeight;
@end

@implementation PywCustomTextField

CGFloat const spacing = 5; // 间隔
CGFloat const leftViewWidth_Height = 32; // leftView的宽高

#pragma mark - override
- (instancetype)initWithLeftView:(id)leftView
                       rightView:(id)rightView
                  rightViewWidth:(CGFloat)rightViewWidth
                 textFieldHeight:(CGFloat)textFieldHeight
{
    self = [super init];
    if (self) {
        self.customLeftView = leftView;
        self.customRightView = rightView;
        self.rightViewWidth = rightViewWidth;
        self.textFieldHeight = textFieldHeight;
        
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.keyboardType = UIKeyboardTypeASCIICapable;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.leftView = self.customLeftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    if (self.customRightView) {
        self.rightView = self.customRightView;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    
    [self addSubview:self.separatorLine];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - rewriteSuperClassMethod
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    if (self.customLeftView){
        return CGRectMake(bounds.origin.x + spacing,
                          (bounds.size.height - leftViewWidth_Height - 2) * 0.5,
                          leftViewWidth_Height,
                          leftViewWidth_Height);
    } else {
        return CGRectZero;
    }
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    if (self.customRightView){
        return CGRectMake(bounds.size.width - self.rightViewWidth,
                          bounds.origin.y + 1,
                          self.rightViewWidth,
                          self.textFieldHeight - 2);
    } else {
        return CGRectZero;
    }
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect rect = [super placeholderRectForBounds:bounds];
    return CGRectMake(rect.origin.x,
                      (bounds.size.height - rect.size.height) * 0.5,
                      rect.size.width,
                      rect.size.height);
}
- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectMake(rect.origin.x + spacing,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}
-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect = [super editingRectForBounds:bounds];
    return CGRectMake(rect.origin.x + spacing,
                      rect.origin.y,
                      rect.size.width,
                      rect.size.height);
}

/// 禁止TextField文本框的  选择、全选和粘贴 功能
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - Lazy
- (UIView *)separatorLine
{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _separatorLine;
}

@end
