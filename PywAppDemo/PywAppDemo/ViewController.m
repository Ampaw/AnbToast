//
//  ViewController.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/2/28.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "ViewController.h"
#import "Button.h"
#import "PywLoginView.h"
#import "Masonry.h"
#import "PywAlertSelectView.h"

@interface ViewController ()
@property(nonatomic, strong) Button *loginBtn;
@property(nonatomic, strong) PywLoginView *loginView;

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
    
    self.loginView = [[PywLoginView alloc] init];
    
}
- (void)login:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
//    [self.loginView show];
    PywAlertSelectView *alertView = [[PywAlertSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [alertView alertSelectViewshow];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
