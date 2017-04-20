//
//  PywOpenChestItem.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/19.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywOpenChestItem.h"
#import "Masonry.h"

@implementation PywOpenChestItem

#pragma mark - init
- (instancetype)initWithDelegate:(id<PywOpenChestItemDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setUpSubView];
        [self updateSubViewConstraints];
    }
    return self;
}

- (void)setUpSubView
{
    [self addSubview:self.openChestImgView];
    [self addSubview:self.openChestButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openChestTap:)];
    self.openChestImgView.userInteractionEnabled = YES;
    [self.openChestImgView addGestureRecognizer:tap];
    
    [self.openChestButton addTarget:self action:@selector(openChestButton:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)updateSubViewConstraints
{
    [self.openChestImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(60);
    }];
    [self.openChestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.openChestImgView.mas_bottom).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
}
- (void)openChestButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(openChestItem:buttonTag:)]) {
        [self.delegate openChestItem:self buttonTag:self.tag];
    }
}
- (void)openChestTap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(openChestItem:buttonTag:)]) {
        [self.delegate openChestItem:self buttonTag:self.tag];
    }
}

#pragma mark - Lazy
- (UIImageView *)openChestImgView
{
    if (!_openChestImgView) {
        _openChestImgView = [[UIImageView alloc] init];
        _openChestImgView.image = [UIImage imageNamed:@"icon_chestclosed_normal"];
    }
    return _openChestImgView;
}
- (UIButton *)openChestButton
{
    if (!_openChestButton) {
        _openChestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openChestButton.layer.cornerRadius = 3.f;
        _openChestButton.layer.masksToBounds = YES;
        _openChestButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _openChestButton.backgroundColor = UIColorFromRGB(0xFFB22D);
        [_openChestButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_openChestButton setTitle:@"开宝箱" forState:UIControlStateNormal];
    }
    return _openChestButton;
}

@end
