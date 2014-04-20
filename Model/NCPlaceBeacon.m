//
//  NCPlaceBeacon.m
//  InMinder
//
//  Created by nevercry on 1/14/14.
//  Copyright (c) 2014 nevercry. All rights reserved.
//

#import "NCPlaceBeacon.h"


static NSString *const InMinderRegionIdentifier = @"com.nevercry.apps.InMinder";

@implementation NCPlaceBeacon

- (instancetype)initWithUUID:(NSUUID *)uuid
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor
{
    self = [super init];
    if (self) {
        _region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[major shortValue] minor:[minor shortValue] identifier:InMinderRegionIdentifier];
        _uuid = _region.proximityUUID;
        _major = _region.major;
        _minor = _region.minor;
        
    }
    
    return self;
}




- (instancetype) init
{
    return [self initWithUUID:[NSUUID UUID] major:0 minor:0];
}


@end
