//
//  NPDefaults.h
//  new position
//
//  Created by apple on 14-11-12.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@interface NPDefaults : NSObject
+ (NPDefaults *)sharedDefaults;

@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;

@property (nonatomic, copy, readonly) NSUUID *defaultProximityUUID;
@property (nonatomic, copy, readonly) NSNumber *defaultPower;


- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;
@end
