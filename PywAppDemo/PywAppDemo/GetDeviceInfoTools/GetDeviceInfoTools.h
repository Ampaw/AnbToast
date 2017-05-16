//
//  GetDeviceInfoTools.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/27.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetDeviceInfoTools : NSObject

+ (NSString *)UDID;
+ (NSString *)IMEI;

+ (void)getIMEI;
+ (NSString *)getIDFA;
+ (NSString *)getUUID;
+ (NSString *)getMacAddress;
+ (NSString *)get2MacAddress;

@end
