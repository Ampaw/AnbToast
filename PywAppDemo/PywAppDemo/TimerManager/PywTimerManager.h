//
//  PywTimerManager.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/3/2.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PywTimerManager : NSObject

+ (instancetype)manager;

- (void)showWithElement:(id)element
            currentDate:(NSDate *)currentDate
              storeDate:(NSDate *)storeDate;

@end
