//
//  AppDelegate.m
//  HITRenIOSClient
//
//  Created by wubincen on 14-1-1.
//  Copyright (c) 2014年 wubincen. All rights reserved.
//

#import "AppDelegate.h"
#import "XmppConnector.h"
#import "DBController.h"
#import "XMPPDataManager.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [[XmppConnector sharedInstance] connect];
    [DBController deleteFile];
    _xmppDataManager = [[XMPPDataManager alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[NSMutableArray alloc] init] forKey:@"noticeLine"];
    [userDefaults setObject:@"" forKey:@"pic"];
    [userDefaults synchronize];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray* array = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *docURL = [array objectAtIndex:0];
    NSURL *imageURL = [docURL URLByAppendingPathComponent:@"images"];
    [fm removeItemAtURL:imageURL error:nil];
    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    NSString* tmp = @" {\"asd\" : \"1\",\"aaa\":1} ";
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[tmp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"%@",[dic objectForKey:@"asd"]);
//    NSLog(@"%d",[[dic objectForKey:@"aaa"] intValue]);
//    NSLog(@"%@",[dic description]);
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    UIApplication *app = [UIApplication sharedApplication];
//    UIBackgroundTaskIdentifier taskID;
//    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
//        [app endBackgroundTask:taskID];
//    }];
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{ [self backgroundHandler]; }];
    if (backgroundAccepted)
    {
        NSLog(@"VOIP backgrounding accepted");
    }
    [self backgroundHandler];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)backgroundHandler {
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier taskID;
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:taskID];
        taskID = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            sleep(1);
        }
    
    });
    L(@"asd");
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

@end
