//
//  PywUUIDManager.h
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/27.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PywUUIDManager : NSObject

+(void)saveUUID:(NSString *)uuid;

+(NSString *)getUUID;

+(void)deleteUUID;

@end
