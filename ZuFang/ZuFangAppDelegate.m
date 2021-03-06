//
//  ZuFangAppDelegate.m
//  ZuFang
//
//  Created by Summer on 14/1/14.
//  Copyright (c) 2014 chentoo. All rights reserved.
//

#import "ZuFangAppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "House.h"
#import <UMengAnalytics/MobClick.h>

@implementation ZuFangAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self initAVOSWithLaunchOptions:launchOptions];
    [MobClick startWithAppkey:@"5399689956240b395601d6bd"];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initAVOSWithLaunchOptions:(NSDictionary *)options
{
    [House registerSubclass];
    [AVOSCloud setApplicationId:@"yvl77dkjscth741rdrt9idjls508x514gczl5gwhsa69nn5y"
                      clientKey:@"11qzu7b6khd4qjetu3lfs6yjlv1wpoc7u3fwmr3jp3ydfp77"];
//    [AVAnalytics trackAppOpenedWithLaunchOptions:options];
}

@end
