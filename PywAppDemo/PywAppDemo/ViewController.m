//
//  ViewController.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/2/28.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "ViewController.h"
#import "PywButton.h"

@interface ViewController ()
@property(nonatomic, strong) PywButton *changeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PywButton *btn5 = [[PywButton alloc] initWithAlignmentStatus:PywButtonStatusRight];
    [btn5 setBackgroundColor:[UIColor orangeColor]];
    [btn5 setImage:[UIImage imageNamed:@"tabbar_discover"] forState:UIControlStateNormal];
    [btn5 setTitle:@"这里是按钮的文字" forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn5.frame = CGRectMake(100, 350, 200, 80);
    [btn5 addTarget:self action:@selector(changeTitle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    self.changeBtn = btn5;
}
- (void)changeTitle:(id)sender
{
    [self.changeBtn setTitle:@"按钮" forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
