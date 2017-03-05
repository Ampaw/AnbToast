//
//  OneViewController.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/2.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "OneViewController.h"
#import "CountDownLabel.h"

@interface OneViewController ()
{
    dispatch_source_t _timer;
}

@property(nonatomic, strong) CountDownLabel *timerLabel;
@end

@implementation OneViewController

/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
-(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}
- (void)timer
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *endDate = [dateFormatter dateFromString:[self getyyyymmdd]];
    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24*3600)];
    NSDate *startDate = [NSDate date];
    // - (NSTimeInterval)timeIntervalSinceDate:(NSDate *)refDate; 该方法以refDate为基准时间，返回实例保存的时间与refDate的时间间隔
    NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.dayLabel.text = @"";
//                        self.hourLabel.text = @"00";
//                        self.minuteLabel.text = @"00";
//                        self.secondLabel.text = @"00";
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
//                        self.dayLabel.text = @"";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days==0) {
//                            self.dayLabel.text = @"0天";
                        }else{
//                            self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
                            NSLog(@"===%d天===",days);
                        }
                        if (hours<10) {
//                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }else{
//                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        NSLog(@"===%d小时===",hours);
                        if (minute<10) {
//                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
//                            self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        NSLog(@"===%d分钟===",minute);
                        if (second<10) {
//                            self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }else{
//                            self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
                        NSLog(@"===%d秒===",second);
                        
                        self.timerLabel.text = [NSString stringWithFormat:@"%d:%d",minute,second];
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self timer];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 80, 44)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.timerLabel = [[CountDownLabel alloc] initWithFrame:CGRectMake(20, 100, 300, 40)];
    [self.view addSubview:self.timerLabel];
    
    
    // 开始时间（相当于上次存储时间）
    NSDate *startDate = [NSDate date];
    
//    [NSThread sleepForTimeInterval:40];
    for (int i = 0; i < 10000; i++) {
        NSLog(@"%d",i);
    }
    
    // 结束时间（相当于当前时间）
    NSDate *endDate = [NSDate date];
    // 将上次存储的时间转换为Date
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:25708];
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    if (timeInterval < 0.001) { // 时间差为大于等于15分钟,说明订单过期
        NSLog(@"订单过期");
    }else{
        NSLog(@"");
        // 25708
//        [self.timerLabel setupCountDownWithTargetTime:endDate];
        if (_timer==nil) {
            __block int timeout = timeInterval; //倒计时时间
            
            if (timeout!=0) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout<=0){ //倒计时结束，关闭
                        dispatch_source_cancel(_timer);
                        _timer = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"倒计时结束，关闭");
                        });
                    }else{
                        int days = (int)(timeout/(3600*24));
                        if (days==0) {
                            \
                        }
                        int hours = (int)((timeout-days*24*3600)/3600);
                        int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                        int second = timeout-days*24*3600-hours*3600-minute*60;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (days==0) {
                                
                            }else{
                                
                                NSLog(@"===%d天===",days);
                            }
                            if (hours<10) {
                                
                            }else{
                                
                            }
                            NSLog(@"===%d小时===",hours);
                            if (minute<10) {
                              
                            }else{
                              
                            }
                            NSLog(@"===%d分钟===",minute);
                            if (second<10) {
                              
                            }else{
                              
                            }
                            NSLog(@"===%d秒===",second);
                            
                            self.timerLabel.text = [NSString stringWithFormat:@"%d:%d",minute,second];
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }
        }
    }
    
}
- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
