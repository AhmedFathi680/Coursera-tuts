//
//  AppDelegate.m
//  PeerReview203
//
//  Created by Ahmed Fathi on 6/30/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // reset the badge number
    application.applicationIconBadgeNumber = 0;
    
    // check if the app launches through local notification
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Received On Launch" message:localNotification.alertBody preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
    return YES;
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    application.applicationIconBadgeNumber = 0;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Received While Running" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification completionHandler:(nonnull void (^)())completionHandler {
    application.applicationIconBadgeNumber = 0;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Received On Action" message:identifier preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
