//
//  ViewController.m
//  PeerReview203
//
//  Created by Ahmed Fathi on 6/30/16.
//  Copyright © 2016 company.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)requestPermissionToNotify {
    // Prepare the types
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge;
    
    // Prepare the categories (define actions then put them into categories set)
    // prepare the actions
    UIMutableUserNotificationAction *confirmAction = [[UIMutableUserNotificationAction alloc] init];
    confirmAction.identifier = @"CONFIRM_ACTION";
    confirmAction.title = @"confirm";
    confirmAction.activationMode = UIUserNotificationActivationModeForeground;
    confirmAction.destructive = NO;
    confirmAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *ignoreAction = [[UIMutableUserNotificationAction alloc] init];
    ignoreAction.identifier = @"IGNORE_ACTION";
    ignoreAction.title = @"ignore";
    ignoreAction.activationMode = UIUserNotificationActivationModeBackground;
    ignoreAction.destructive = YES;
    ignoreAction.authenticationRequired = NO;
    
    // Prepare the categories
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"MAIN_CATEGORY";
    [category setActions:@[confirmAction, ignoreAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObject:category];
    
    // Prepare the notification settings for TYPES & CATEGORIES
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    // Register notification with settings
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)createANotification:(int)secondsIntoFuture {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:secondsIntoFuture];
    localNotification.timeZone = nil;
    
    localNotification.alertTitle =  @"Notification Title";
    localNotification.alertBody = @"Notification Body";
    localNotification.alertAction = @"take action";
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    
    localNotification.category = @"MAIN_CATEGORY";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (IBAction)notify:(UIButton *)sender {
    [self requestPermissionToNotify];
    [self createANotification:7];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
