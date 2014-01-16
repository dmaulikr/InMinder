//
//  NCPlaceBeacon.m
//  InMinder
//
//  Created by nevercry on 1/14/14.
//  Copyright (c) 2014 nevercry. All rights reserved.
//

#import "NCPlaceBeacon.h"

@implementation NCPlaceBeacon

- (instancetype)initWithUUID:(NSUUID *)uuid
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor
{
    self = [super init];
    if (self) {
        self.uuid = uuid;
        self.major = major;
        self.minor = minor;
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:[major shortValue] minor:[minor shortValue] identifier:@"com.nevercry.apps.InMinder"];
    }
    
    return self;
}




- (instancetype) init
{
    return [self initWithUUID:[NSUUID UUID] major:0 minor:0];
}


@end
