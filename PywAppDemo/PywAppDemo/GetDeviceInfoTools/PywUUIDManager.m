//
//  PywUUIDManager.m
//  PywAppDemo
//
//  Created by Ampaw on 2017/4/27.
//  Copyright © 2017年 Ampaw. All rights reserved.
//

#import "PywUUIDManager.h"
#import "PywKeyChainManager.h"

@implementation PywUUIDManager

static NSString * const KEY_IN_KEYCHAIN = @"com.myuuid.uuid";


+(void)saveUUID:(NSString *)uuid{
    if (uuid && uuid.length > 0) {
        [PywKeyChainManager save:KEY_IN_KEYCHAIN data:uuid];
    }
}


+(NSString *)getUUID{
    //先获取keychain里面的UUID字段，看是否存在
    NSString *uuid = (NSString *)[PywKeyChainManager load:KEY_IN_KEYCHAIN];
    
    //如果不存在则为首次获取UUID，所以获取保存。
    if (!uuid || uuid.length == 0) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        
        uuid = [NSString stringWithFormat:@"%@", uuidString];
        
        [self saveUUID:uuid];
        
        CFRelease(puuid);
        
        CFRelease(uuidString);
    }
    
    return uuid;
}



+(void)deleteUUID{
    [PywKeyChainManager delete:KEY_IN_KEYCHAIN];
}


@end
