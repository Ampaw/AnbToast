//
//  PywTextField.m
//  PywApp
//
//  Created by Ampaw on 2017/2/18.
//  Copyright © 2017年 Jade. All rights reserved.
//

#import "PywTextField.h"

#define spacing 5
#define leftView_Width_Height 30
#define notImgLeftView_Width_Height 10

@interface PywTextField ()
@property (nonatomic, copy) NSString  *leftImgName;
@end

@implementation PywTextField

#pragma mark - override
- (instancetype)init{
    self = [super init];
    if (self) {
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return self;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    if (self.leftImgName.length > 0){
        return CGRectMake(bounds.origin.x + spacing,
                          (bounds.size.height - leftView_Width_Height) * 0.5,
                          leftView_Width_Height,
                          leftView_Width_Height);
    } else {
        return CGRectMake(bounds.origin.x + spacing,
                          (bounds.size.height - notImgLeftView_Width_Height) * 0.5,
                          notImgLeftView_Width_Height,
                          notImgLeftView_Width_Height);
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

#pragma mark - classMethod
+ (instancetype)inputTextFieldWithLeftImgName:(NSString *)leftImgName
                                  placeholder:(NSString *)placeholder
                                 textFontSize:(CGFloat)fontSize{
    
    PywTextField *textField = [[PywTextField alloc] init];
    textField.layer.cornerRadius = 5.0;
    textField.tintColor = [UIColor grayColor];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.leftImgName = leftImgName;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (textField.leftImgName.length > 0) {
        UIImageView *TextFieldLeftImg = [[UIImageView alloc] init];
        TextFieldLeftImg.backgroundColor = [UIColor clearColor];
        TextFieldLeftImg.image = [UIImage imageNamed:leftImgName];
        textField.leftView = TextFieldLeftImg;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return textField;
}

@end
