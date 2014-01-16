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

@property (nonatomic,strong) NSUUID *uuid;
@property (nonatomic,strong) NSNumber *major;
@property (nonatomic,strong) NSNumber *minor;
@property (nonatomic,strong) CLBeaconRegion *region;


@end
