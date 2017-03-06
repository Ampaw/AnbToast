//
//  PywTextField.h
//  PywApp
//
//  Created by Ampaw on 2017/2/18.
//  Copyright © 2017年 Jade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PywTextField : UITextField

/**
 *  默认情况 文本输入框
 *
 *  @param leftImgName 文本输入框左边的图片名称
 *  @param placeholder 文本输入宽的文字提示
 *  @param fontSize    文本输入框的文字大小
 *
 *  @return 默认情况 文本输入框
 */
+ (instancetype)inputTextFieldWithLeftImgName:(NSString *)leftImgName
                                  placeholder:(NSString *)placeholder
                                 textFontSize:(CGFloat)fontSize;

@end
