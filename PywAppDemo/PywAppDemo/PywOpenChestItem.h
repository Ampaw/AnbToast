//
//  PywOpenChestItem.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/19.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/*  屏幕宽高 */
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@class PywOpenChestItem;
@protocol PywOpenChestItemDelegate <NSObject>
@optional
- (void)openChestItem:(PywOpenChestItem *)item buttonTag:(NSInteger)tag;

@end

@interface PywOpenChestItem : UIView
@property(nonatomic, weak) id<PywOpenChestItemDelegate> delegate;
@property(nonatomic, strong) UIImageView *openChestImgView;
@property(nonatomic, strong) UIButton    *openChestButton;

- (instancetype)initWithDelegate:(id<PywOpenChestItemDelegate>)delegate;

@end
