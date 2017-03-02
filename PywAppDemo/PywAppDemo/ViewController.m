//
//  ViewController.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/2/28.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "ViewController.h"
#import "PywCustomButton.h"
//#import "PywToast.h"
//#import "PywProgressHUD.h"
#import "PywHUDManager.h"
#import "OneViewController.h"

@interface ViewController ()
@property(nonatomic, strong) PywCustomButton *changeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PywCustomButton *btn5 = [PywCustomButton buttonWithAlignmentStatus:PywCustomButtonStatusLeft];
    [btn5 setBackgroundColor:[UIColor orangeColor]];
    [btn5 setImage:[UIImage imageNamed:@"tabbar_discover"] forState:UIControlStateNormal];
    [btn5 setTitle:@"按钮" forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn5.frame = CGRectMake(100, 100, 100, 40);
    [btn5 addTarget:self action:@selector(changeTitle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    self.changeBtn = btn5;
}
- (void)changeTitle:(id)sender
{
//    [PywToast showToastWithMessage:@"请求成功" position:PywToastPositionBottomWithFillet];
//    [PywToast showToastWithMessage:@"请求成功" iconImage:[UIImage imageNamed:@"toast_success"] position:PywToastPositionBottomWithFillet toView:self.view];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [PywToast hideToast];
//    });
    
//    [PywProgressHUD showWithMessage:@"正在载入..." mode:PywProgressHUDModeIndeterminate style:PywProgressHUDStyleDefault toView:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [PywProgressHUD hideHUD];
//    });
    
//    [PywHUDManager showWithMode:PywAlertMode_HUD message:@"正在加载..." iconImage:nil];
//    [PywHUDManager showWithMode:PywAlertMode_Waring message:@"正在加载..." iconImage:[UIImage imageNamed:@"toast_success"] toView:self.view];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [PywHUDManager hideWithMode:PywAlertMode_Waring];
//    });
    
    OneViewController *oneVC = [[OneViewController alloc] init];
    [self presentViewController:oneVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
