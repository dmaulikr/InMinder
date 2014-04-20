//
//  NCPlaceBeacon.h
//  InMinder
//
//  Created by nevercry on 1/14/14.
//  Copyright (c) 2014 nevercry. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface NCPlaceBeacon : NSObject

@property (nonatomic,weak) NSUUID *uuid;
@property (nonatomic,weak) NSNumber *major;
@property (nonatomic,weak) NSNumber *minor;
@property (nonatomic,strong) CLBeaconRegion *region;

- (instancetype)initWithUUID:(NSUUID *)uuid
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor;

@end
