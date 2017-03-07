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

@interface ViewController ()<PywLoginViewDelegate>
@property(nonatomic, strong) Button *loginBtn;

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
    
    PywLoginView *loginView = [[PywLoginView alloc] initWithDelegate:self];
    loginView.backgroundColor = [UIColor whiteColor];
    loginView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT / 2);
    
    PywSelectAlertView *baseAlert = [[PywSelectAlertView alloc] initWithContentsSubView:loginView];
    baseAlert.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [baseAlert showSelectAlertView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
