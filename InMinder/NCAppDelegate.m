//
//  NCAppDelegate.m
//  InMinder
//
//  Created by nevercry on 1/12/14.
//  Copyright (c) 2014 nevercry. All rights reserved.
//

#import "NCAppDelegate.h"
#import "NCPlaceBeacon.h"

@implementation NCAppDelegate
{
    CLLocationManager *_locationManager;
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    // A user can transition in or out of a region while the application is not running.
    // When this happens CoreLocation will launch the application momentarily, call this delegate method
    // and we will let the user know via a local notification.
    UILocalNotification *inNotification = [[UILocalNotification alloc] init]; // 进入通知
    
    UILocalNotification *outNotification = [[UILocalNotification alloc] init]; // 离开通知
    
    NSArray *outToDoList = [[NSUserDefaults standardUserDefaults] objectForKey:kInMinderOutToDoList];
    
    NSArray *inToDoList = [[NSUserDefaults standardUserDefaults] objectForKey:kInMinderInToDoLinst];
    
    
    
    if(state == CLRegionStateInside)
    {
        // 1. 检查是否有到达的提醒事项
        
        if ([inToDoList count]) {
            inNotification.alertBody = [inToDoList firstObject];
        }
        
    }
    else if(state == CLRegionStateOutside)
    {
        // 2.检查是否有离开的提醒事项
        
        
        if ([outToDoList count])
        {
            outNotification.alertBody = [outToDoList firstObject];
        
        }
        
        
    }
    else
    {
        return;
    }
    
    // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
    // If its not, iOS will display the notification to the user.
    
    if ([inNotification.alertBody length]&&self.isAppInBackground)
    {
        // 只要通知信息长度不为0并且程序在后台运行
        // 如果通知的内容和前次一样则不推送通知
        if (![self.lastInNotificationBody isEqualToString:inNotification.alertBody])
        {
            
            // add notification sound
            inNotification.soundName = UILocalNotificationDefaultSoundName;
            inNotification.applicationIconBadgeNumber = 1;
            
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:inNotification];
            
            self.lastInNotificationBody = inNotification.alertBody;
        }
    }
    
    if ([outNotification.alertBody length]&&self.isAppInBackground)
    {
        // 只要通知信息长度不为0并且程序在后台运行
        // 如果通知的内容和前次一样则不推送通知
        if (![self.lastOutNotificationBody isEqualToString:outNotification.alertBody])
        {
            outNotification.soundName = UILocalNotificationDefaultSoundName;
            outNotification.applicationIconBadgeNumber = 1;
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:outNotification];
            
            self.lastOutNotificationBody = outNotification.alertBody;
        }
    }
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // This location manager will be used to notify the user of region state transitions.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    _isAppInBackground = NO;
    
    
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    _isAppInBackground = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    _isAppInBackground = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    _isAppInBackground  = YES;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
}


@end
