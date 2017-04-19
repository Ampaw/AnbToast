//
//  PywCustomTextField.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/11.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PywCustomTextField : UITextField

/**
 init

 @param leftView 左边View
 @param rightView 右边View
 @param rightViewWidth 右边View宽度按
 @param textFieldHeight textField的高度
 */
- (instancetype)initWithLeftView:(id)leftView
                       rightView:(id)rightView
                  rightViewWidth:(CGFloat)rightViewWidth
                 textFieldHeight:(CGFloat)textFieldHeight;

@end
