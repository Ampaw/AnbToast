//
//  PywOpenChestAlertView.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/19.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywOpenChestAlertView.h"
#import "PywOpenChestItem.h"
#import "PywOpenChestModel.h"
#import "Masonry.h"

@interface PywOpenChestAlertView ()<PywOpenChestItemDelegate>
@property(nonatomic, strong) UIView         *mainView;
@property(nonatomic, strong) UIButton       *closeButton;       // 关闭按钮
@property(nonatomic, strong) UIImageView    *titleBackgrounImg; // 标题背景图片
@property(nonatomic, strong) UILabel        *titleLabel;        // 标题Label
@property(nonatomic, strong) UILabel        *subTitleLabel;     // 副标题Label
@property(nonatomic, strong) UIView         *openChestItemView; // 宝箱ItemView
@property(nonatomic, strong) UIButton       *applyButton;       // 应用按钮

@property(nonatomic, strong) id target;
@property(nonatomic, copy) NSString *chest_msg;        // 开宝箱一句话说明
@property(nonatomic, assign) double chest_offset_cost; // 宝箱优惠金额
@property(nonatomic, assign) BOOL is_open_chest;       // 是否已经完全打开宝箱
@property(nonatomic, copy) Completion completion;      // 完全打开宝箱的回调
@property(nonatomic, strong) NSMutableArray *modelArr; // 存储model的数组
@property(nonatomic, assign) NSInteger count;          // 选择计数变量
@property(nonatomic, strong) NSMutableArray *tagArr;   // 存储tag的数组
@property(nonatomic, copy) NSString *chest_money;      // 宝箱使用金额
@end

@implementation PywOpenChestAlertView

CGFloat const NormalOpenChest_Height = 330; // 默认高度
CGFloat const isOpenChest_Height     = 370; // 打开宝箱后高度

- (instancetype)initWithChestMsg:(NSString *)chest_msg
                 chestOffsetCost:(NSString *)chest_offset_cost
                     isOpenChest:(BOOL)is_open_chest
                          target:(id)target
                      completion:(Completion)completion
{
    self = [super init];
    if (self) {
        self.target = target;
        self.chest_msg = chest_msg;
        self.chest_offset_cost = [chest_offset_cost doubleValue];
        self.is_open_chest = is_open_chest;
        self.completion = completion;
        
        [self setUpModelContents:is_open_chest];
        [self setUpSubView];
        [self updateSubViewConstraints];
    }
    return self;
}

- (void)setUpSubView
{
    self.count = 0;
    self.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    [self addSubview:self.mainView];
    [self addSubview:self.closeButton];
    
    [self.mainView addSubview:self.titleBackgrounImg];
    [self.mainView addSubview:self.titleLabel];
    [self.mainView addSubview:self.subTitleLabel];
    [self.mainView addSubview:self.openChestItemView];
}
- (void)updateSubViewConstraints
{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.equalTo(self.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(NormalOpenChest_Height);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainView.mas_top).offset(-5);
        make.right.equalTo(self.mainView.mas_right);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.titleBackgrounImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.mainView.mas_top).offset(15);
        make.width.mas_equalTo(203);
        make.height.mas_equalTo(37);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.titleBackgrounImg.mas_top);
        make.bottom.equalTo(self.titleBackgrounImg.mas_bottom).offset(-8);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.titleBackgrounImg.mas_bottom).offset(5);
    }];
    [self.openChestItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.mainView);
        make.height.mas_equalTo(200);
    }];
    
    [self setUpOpenChestItem];
}
- (void)setUpOpenChestItem
{
    for (NSInteger i = 1; i <= self.modelArr.count; i++) {
        PywOpenChestItem *openChestItem = [[PywOpenChestItem alloc] initWithDelegate:self];
        
        CGFloat openChestItemW = 70;
        CGFloat openChestItemH = 90;
        CGFloat spacing = ((SCREEN_WIDTH * 0.8) - (openChestItemW * 3)) / 4;
        CGFloat openChestItemX = spacing + ((i - 1) * (openChestItemW + spacing));
        CGFloat openChestItemY = 0;
        if (i > 3) {
            openChestItemX = spacing + ((i - 3) * (openChestItemW + spacing)) - (openChestItemW + spacing) * 0.5;
            openChestItemY = openChestItemH + 20;
        }
        openChestItem.frame = CGRectMake(openChestItemX, openChestItemY, openChestItemW, openChestItemH);
        openChestItem.tag = i;
        
        // 是否已经打开宝箱
        if (self.is_open_chest) {
            openChestItem.openChestImgView.image = [UIImage imageNamed:@"img_chest_open111"];
            
            PywOpenChestModel *chestModel = self.modelArr[i-1];
            NSString *chest_money = [NSString stringWithFormat:@"-￥%@",chestModel.chest_money];
            [openChestItem.openChestButton setTitle:chest_money forState:UIControlStateNormal];
            
            openChestItem.openChestButton.backgroundColor = [UIColor clearColor];
            openChestItem.openChestButton.layer.borderColor = UIColorFromRGB(0xCFCFCF).CGColor;
            openChestItem.openChestButton.layer.borderWidth = 1.f;
            [openChestItem.openChestButton setTitleColor:UIColorFromRGB(0xFF9900) forState:UIControlStateNormal];
            
            [self normalSelectOpenChestMaxMoney:openChestItem];
        }
        
        [self.openChestItemView addSubview:openChestItem];
    }
    
    [self isOpenChest:self.is_open_chest];
}

/**
 设置Model数组的值
 */
- (void)setUpModelContents:(BOOL)is_open_chest
{
    // 设置虚拟宝箱金额
    int cost_money = self.chest_offset_cost * 100;
    for (NSInteger i = 1; i <= 4; i++) {
        PywOpenChestModel *chestModel = [[PywOpenChestModel alloc] init];
        chestModel.chest_money = [NSString stringWithFormat:@"%.2f",[self getRandomNumber:1 to:cost_money] / 100];
        chestModel.is_open_chest = is_open_chest;
        [self.modelArr addObject:chestModel];
    }
    // 设置固定宝箱金额
    PywOpenChestModel *chestModel = [[PywOpenChestModel alloc] init];
    chestModel.chest_money = [NSString stringWithFormat:@"%.2f",self.chest_offset_cost];
    chestModel.is_open_chest = is_open_chest;
    NSInteger index = [self getRandomNumber:0 to:4];
    [self.modelArr insertObject:chestModel atIndex:index];
}

/**
 获取一个随机整数，范围在[from,to），包括from，不包括to
 */
-(double)getRandomNumber:(int)from to:(int)to
{
    return (double)(from + (arc4random() % (to - from)));
}

/**
 取最大值的对应下标
 */
- (int)getMaxIndexWithMaxNumber:(double)maxNumber
{
    int max_index = 0; // 最大值的下标
    
    for (int i = 0; i < self.modelArr.count; i++)
    {
        // 取最大值的对应下标
        PywOpenChestModel *chestModel = self.modelArr[i];
        if ([chestModel.chest_money doubleValue] == maxNumber)
        {
            max_index = i;
        }
    }
    return max_index;
}

/**
 判断是否已全部打开 开宝箱
 */
- (void)isOpenChest:(BOOL)is_open_chest
{
    if (is_open_chest) {
        [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(isOpenChest_Height);
        }];
        
        [self.mainView addSubview:self.applyButton];
        [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.left.offset(10);
            make.right.offset(-10);
            make.bottom.equalTo(self.mainView.mas_bottom).offset(-20);
            make.height.mas_equalTo(44);
        }];
    }
    
    // 宝箱打开后，使用按钮的显示
    NSString *applyChestMoney = [NSString stringWithFormat:@"使用￥%@优惠",self.chest_money];
    [self.applyButton setTitle:applyChestMoney forState:UIControlStateNormal];
}

/**
 判断，默认选择最大金额Item
 */
- (void)normalSelectOpenChestMaxMoney:(PywOpenChestItem *)openChestItem
{
    [self.tagArr setArray:@[@"1",@"2",@"3",@"4",@"5"]];
    // 遍历tag数组，显示最大金额的Item
    for (NSNumber *tag in self.tagArr) {
        PywOpenChestItem *item_ =  [self.openChestItemView viewWithTag:[tag integerValue]];
        NSInteger index = [self getMaxIndexWithMaxNumber:self.chest_offset_cost]; // 最大金额下标
        if ([tag integerValue] == index + 1) {
            item_.openChestButton.layer.borderWidth = 1.f;
            item_.openChestButton.layer.borderColor = UIColorFromRGB(0xFFB22D).CGColor;
            
            PywOpenChestModel *model = self.modelArr[index];
            self.chest_money = model.chest_money;
            NSString *applyChestMoney = [NSString stringWithFormat:@"使用￥%@优惠",self.chest_money];
            [self.applyButton setTitle:applyChestMoney forState:UIControlStateNormal];
        }else{
            item_.openChestButton.layer.borderWidth = 1.f;
            item_.openChestButton.layer.borderColor = UIColorFromRGB(0xCFCFCF).CGColor;
        }
    }
}

#pragma mark - PywOpenChestItemDelegate
- (void)openChestItem:(PywOpenChestItem *)item buttonTag:(NSInteger)tag
{
    // 获取该Item的model数据
    PywOpenChestModel *chest_model = self.modelArr[tag - 1];
    
    // 切换选择
    if (chest_model.is_open_chest) {
        for (NSNumber *tag in self.tagArr) {
            PywOpenChestItem *item_ =  [self.openChestItemView viewWithTag:[tag integerValue]];
            item_.openChestButton.layer.borderWidth = 1.f;
            item_.openChestButton.layer.borderColor = UIColorFromRGB(0xCFCFCF).CGColor;
        }
        item.openChestButton.layer.borderWidth = 1.f;
        item.openChestButton.layer.borderColor = UIColorFromRGB(0xFFB22D).CGColor;
        self.chest_money = chest_model.chest_money;
        NSString *applyChestMoney = [NSString stringWithFormat:@"使用￥%@优惠",self.chest_money];
        [self.applyButton setTitle:applyChestMoney forState:UIControlStateNormal];
    }else{
        item.openChestButton.layer.borderWidth = 1.f;
        item.openChestButton.layer.borderColor = UIColorFromRGB(0xCFCFCF).CGColor;
    }
    
    // 点击打开宝箱
    if (!chest_model.is_open_chest) {
        [self setOpenChestItem:item index:tag-1];
        
        PywOpenChestModel *chestModel = self.modelArr[tag - 1];
        chestModel.is_open_chest = YES;
        self.count += 1;
        
        // 存储tag到数组中
        [self.tagArr addObject:[NSNumber numberWithInteger:tag]];
        
        if (self.count >= self.modelArr.count) {
            // 遍历tag数组，显示最大金额的Item
            for (NSNumber *tag in self.tagArr) {
                PywOpenChestItem *item_ =  [self.openChestItemView viewWithTag:[tag integerValue]];
                NSInteger index = [self getMaxIndexWithMaxNumber:self.chest_offset_cost]; // 最大金额下标
                if ([tag integerValue] == index + 1) {
                    item_.openChestButton.layer.borderWidth = 1.f;
                    item_.openChestButton.layer.borderColor = UIColorFromRGB(0xFFB22D).CGColor;
                    
                    PywOpenChestModel *model = self.modelArr[index];
                    self.chest_money = model.chest_money;
                    NSString *applyChestMoney = [NSString stringWithFormat:@"使用￥%@优惠",self.chest_money];
                    [self.applyButton setTitle:applyChestMoney forState:UIControlStateNormal];
                }else{
                    item_.openChestButton.layer.borderWidth = 1.f;
                    item_.openChestButton.layer.borderColor = UIColorFromRGB(0xCFCFCF).CGColor;
                }
            }
            
            // 设置是否完全打开状态,
            self.is_open_chest = YES;
            [self isOpenChest:self.is_open_chest];
            
            // 回调数据
            if (self.completion) {
                self.completion(self.is_open_chest, self.chest_money,self.target);
            }
        }
    }
}

/**
 设置开宝箱Item显示
 */
- (void)setOpenChestItem:(PywOpenChestItem *)item index:(NSInteger)index
{
    item.openChestImgView.image = [UIImage imageNamed:@"img_chest_open111"];
    PywOpenChestModel *chestModel = self.modelArr[index];
    NSString *chest_money = [NSString stringWithFormat:@"-￥%@",chestModel.chest_money];
    [item.openChestButton setTitle:chest_money forState:UIControlStateNormal];
    item.openChestButton.backgroundColor = [UIColor clearColor];
    item.openChestButton.layer.borderColor = UIColorFromRGB(0xCFCFCF).CGColor;
    item.openChestButton.layer.borderWidth = 1.f;
    [item.openChestButton setTitleColor:UIColorFromRGB(0xFF9900) forState:UIControlStateNormal];
}

#pragma mark - Action
- (void)applyButton:(UIButton *)btn
{
    [self hide];
    NSLog(@"chest_money = %@",self.chest_money);
}

#pragma mark - Public
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
}
- (void)hide
{
    [self removeFromSuperview];
}
- (void)close:(UIButton *)sender
{
    [self hide];
}

#pragma mark - Setter & Getter
- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [[NSMutableArray alloc] init];
    }
    return _modelArr;
}
- (NSMutableArray *)tagArr
{
    if (!_tagArr) {
        _tagArr = [[NSMutableArray alloc] init];
    }
    return _tagArr;
}

#pragma mark - Lazy
- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = UIColorFromRGB(0xFFFAE4);
        _mainView.layer.cornerRadius = 12.f;
        _mainView.layer.masksToBounds = YES;
    }
    return _mainView;
}
- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton setImage:[UIImage imageNamed:@"icon_closedwhite72_normal"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIImageView *)titleBackgrounImg
{
    if (!_titleBackgrounImg) {
        _titleBackgrounImg = [[UIImageView alloc] init];
        _titleBackgrounImg.image = [UIImage imageNamed:@"img_jingyanzhi111"];
    }
    return _titleBackgrounImg;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = self.chest_msg;
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = UIColorFromRGB(0xFFB713);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.text = @"开启宝箱享减免优惠";
    }
    return _subTitleLabel;
}
- (UIView *)openChestItemView
{
    if (!_openChestItemView) {
        _openChestItemView = [[UIView alloc] init];
    }
    return _openChestItemView;
}
- (UIButton *)applyButton
{
    if (!_applyButton) {
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyButton.layer.cornerRadius = 6.f;
        _applyButton.layer.masksToBounds = YES;
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _applyButton.backgroundColor = UIColorFromRGB(0xFFB22D);
        [_applyButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [_applyButton addTarget:self action:@selector(applyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}

@end
