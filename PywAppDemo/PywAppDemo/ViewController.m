//
//  ViewController.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/2/28.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "ViewController.h"
#import "Button.h"
#import "Masonry.h"
#import "PywAlertSelectView.h"
#import "PywSelectAlertView.h"
#import "PywLoginView.h"
#import "UIView+Frame.h"
#import "SegmentViewController.h"
#import "PywCustomTextField.h"

#import "PywOpenChestItem.h"
#import "PywOpenChestAlertView.h"

@interface ViewController ()<PywLoginViewDelegate>
@property(nonatomic, strong) Button *loginBtn;
@property(nonatomic, strong) UIView *accountLoginView;
@property(nonatomic, strong) UILabel *praceLabel;

@property(nonatomic, assign) BOOL is_open_chest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Button *loginBtn = [[Button alloc] initWithAlignmentStatus:ButtonStatusNormal];
    [loginBtn setBackgroundColor:[UIColor blueColor]];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    loginBtn.frame = CGRectMake(100, 100, 80, 40);
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    _praceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 160, 100, 30)];
    _praceLabel.layer.borderColor = [UIColor blackColor].CGColor;
    _praceLabel.layer.borderWidth = 1.f;
    _praceLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_praceLabel];
    
//    UIImageView *leftView = [[UIImageView alloc] init];
//    leftView.image = [UIImage imageNamed:@"tabbar_discover"];
//    
//    UIView *rightView = [[UIView alloc] init];
//    
//    UIView *v_line = [[UIView alloc] initWithFrame:CGRectMake(0, (44 - (44 * 0.6)) * 0.5, 1, (44 * 0.6))];
//    v_line.backgroundColor = [UIColor lightGrayColor];
//    [rightView addSubview:v_line];
//    
//    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    getCodeBtn.frame = CGRectMake(CGRectGetMaxX(v_line.frame), 0, 99, 44);
//    getCodeBtn.backgroundColor = [UIColor orangeColor];
//    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [getCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [rightView addSubview:getCodeBtn];
//    
//    PywCustomTextField *textField = [[PywCustomTextField alloc] initWithLeftView:leftView
//                                                                       rightView:nil
//                                                                  rightViewWidth:0
//                                                                 textFieldHeight:44];
//    textField.frame = CGRectMake(50, 160, 320, 44);
//    [self.view addSubview:textField];
    
//    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"账号登录", @"验证码登录"]];
//    segment.frame = CGRectMake(50, 160, 300, 40);
//    segment.selectedSegmentIndex = 0;//设置默认选择项索引
//    segment.layer.cornerRadius = 20;
//    segment.backgroundColor = [UIColor lightGrayColor];
//    segment.tintColor = [UIColor whiteColor];
//    segment.layer.masksToBounds = YES;
//    segment.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    segment.layer.borderWidth = 1.f;
//    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                             NSForegroundColorAttributeName: [UIColor orangeColor]};
//    [segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                               NSForegroundColorAttributeName: [UIColor blackColor]};
//    [segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
//    
//    [segment setBackgroundImage:[self imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [segment setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    
//    segment.apportionsSegmentWidthsByContent = NO; //是否根据内容的大小自动调整宽度
//    [segment addTarget:self action:@selector(segment:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segment];
//    
//    [self.view addSubview:self.accountLoginView];
//    
//    __weak typeof(self) wSelf = self;
//    [self.accountLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.offset(20);
//        make.left.equalTo(wSelf.view.mas_left);
//        make.width.mas_equalTo(2 * SCREENWIDTH);
//        make.height.mas_equalTo(50);
//    }];
}
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)segment:(UISegmentedControl *)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            NSLog(@"00000000000");
            [UIView animateWithDuration:0.5 animations:^{
                self.accountLoginView.x = 0;
            }];
        }
            
            break;
        case 1:
        {
            NSLog(@"11111111111");
            [UIView animateWithDuration:0.5 animations:^{
                self.accountLoginView.x = -SCREENWIDTH;
            }];
        }
           
            break;
            
        default:
            break;
    }
}


- (void)login:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT / 2)];
//    view.backgroundColor = [UIColor blueColor];
//    
//    UIButton *btn = [[UIButton alloc] init];
//    btn.backgroundColor = [UIColor whiteColor];
//    [view addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.offset(0);
//        make.height.mas_equalTo(50);
//    }];
//    
//    UITextField *text = [[UITextField alloc] init];
//    text.backgroundColor = [UIColor whiteColor];
//    [view addSubview:text];
//    [text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.offset(0);
//        make.height.mas_equalTo(50);
//    }];
    
//    PywLoginView *loginView = [[PywLoginView alloc] initWithDelegate:self];
//    loginView.backgroundColor = [UIColor whiteColor];
//    loginView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT / 2);
//    
//    PywSelectAlertView *baseAlert = [[PywSelectAlertView alloc] initWithContentsSubView:loginView];
//    baseAlert.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//    [baseAlert showSelectAlertView];
    
//    SegmentViewController *segmentVC = [[SegmentViewController alloc] init];
//    [self presentViewController:segmentVC animated:YES completion:nil];
    
    
    PywOpenChestAlertView *openAlertView = [[PywOpenChestAlertView alloc] initWithChestMsg:@"开宝箱一句话说明" chestOffsetCost:@"0.09" isOpenChest:self.is_open_chest target:self completion:^(BOOL is_open_chest, NSString *chest_money, typeof(self) target) {
        target.is_open_chest = is_open_chest;
        target.praceLabel.text = chest_money;
        
        NSLog(@"\n**** is_open_chest = %d ****\n**** chest_money = %@ ****\n**** target = %@ ****\n",is_open_chest,chest_money,target);
    }];
    [openAlertView show];
}

- (UIView *)accountLoginView
{
    if (!_accountLoginView) {
        _accountLoginView = [[UIView alloc] init];
        _accountLoginView.backgroundColor = [UIColor blueColor];
        
        __weak typeof(self) wSelf = self;
        UIView *account = [[UIView alloc] init];
        account.backgroundColor = [UIColor orangeColor];
        [_accountLoginView addSubview:account];
        [account mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf.accountLoginView.mas_centerY);
            make.left.equalTo(wSelf.accountLoginView.mas_left);
            make.width.mas_equalTo(SCREENWIDTH);
            make.height.mas_equalTo(40);
        }];
        
        UIView *smscode = [[UIView alloc] init];
        smscode.backgroundColor = [UIColor redColor];
        [_accountLoginView addSubview:smscode];
        [smscode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf.accountLoginView.mas_centerY);
            make.right.equalTo(wSelf.accountLoginView.mas_right);
            make.width.mas_equalTo(SCREENWIDTH);
            make.height.mas_equalTo(40);
        }];
    }
    return _accountLoginView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
