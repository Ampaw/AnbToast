//
//  PywKeyChainManager.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/27.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PywKeyChainManager : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end
