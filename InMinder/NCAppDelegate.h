//
//  NCAppDelegate.h
//  InMinder
//
//  Created by nevercry on 1/12/14.
//  Copyright (c) 2014 nevercry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NCAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *places;

@property (nonatomic) BOOL isAppInBackground;  // 检测程序是否在后台运行，只有在后台的情况下，可以通知提醒用户。

@property (nonatomic,strong) NSString *lastOutNotificationBody;

@property (nonatomic,strong) NSString *lastInNotificationBody;


@end
