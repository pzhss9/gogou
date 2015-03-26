//
//  NPDefaults.m
//  new position
//
//  Created by apple on 14-11-12.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import "NPDefaults.h"

@implementation NPDefaults
- (id)init
{
    self = [super init];
    if(self)
    {
       //需要被监控的uuid
        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],[[NSUUID alloc] initWithUUIDString:  @"999557E7-23E4-4BED-988A-A02FE47F9001"]];
        _defaultPower = @-59;
    }
    
    return self;
}

+ (NPDefaults *)sharedDefaults
{
    static id sharedDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDefaults = [[self alloc] init];
    });
    
    return sharedDefaults;
}


- (NSUUID *)defaultProximityUUID
{
    return _supportedProximityUUIDs[0];
}



@end
