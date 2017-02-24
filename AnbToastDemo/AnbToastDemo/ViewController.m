//
//  ViewController.m
//  AnbToastDemo
//
//  Created by Ampaw on 2017/2/24.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "ViewController.h"
#import "AnbToast.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(150, 200, 80, 40)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"Show" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toast:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(150, 260, 80, 40)];
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitle:@"Hide" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];

}

- (void)toast:(id)sender
{
    NSLog(@"*****************");
    // [UIImage imageNamed:@"toast_warning"]
    [AnbToast showToastWithMessage:@"正在请求..." position:AnbToastPositionCenterLoadingTopWithFillet];
//    [AnbToast showToastWithMessage:@"成功" iconImage:[UIImage imageNamed:@"toast_warning"] position:AnbToastPositionCenterLoadingLeft];
}
- (void)hide:(id)sender
{
    NSLog(@"================");
    [AnbToast hideToast];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
