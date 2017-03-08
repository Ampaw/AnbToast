//
//  SegmentViewController.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/8.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "SegmentViewController.h"

@interface SegmentViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation SegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    // 适应scrollView
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"first", @"second"]];
    self.segmentedControl.frame = CGRectMake(50, 50, 200, 44);
    [self.segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmentedControl];
    
    
    // 创建scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200)];
    [self.view addSubview:self.scrollView];
    
    
    // 设置scrollView的内容
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, [UIScreen mainScreen].bounds.size.height - 64);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor orangeColor];
    
    UITextField *text1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, 200, 44)];
    text1.backgroundColor = [UIColor whiteColor];
    text1.placeholder = @"第1个Text";
    [view1 addSubview:text1];
    
    view1.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, CGRectGetHeight(self.scrollView.frame));
    [self.scrollView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor redColor];
    
    UITextField *text2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, 200, 44)];
    text2.backgroundColor = [UIColor whiteColor];
    text2.placeholder = @"第2个Text";
    [view2 addSubview:text2];
    
    view2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, self.scrollView.frame.size.width, CGRectGetHeight(self.scrollView.frame));
    [self.scrollView addSubview:view2];
    
    // 设置scrollView的代理
    self.scrollView.delegate = self;
}
- (void)segmentedControlAction:(UISegmentedControl *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.scrollView setContentOffset:CGPointMake(sender.selectedSegmentIndex * self.scrollView.frame.size.width, 0) animated:NO];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger n = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.segmentedControl.selectedSegmentIndex = n;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
