//
//  AppDelegate.m
//  MyRecordProj
//
//  Created by  qin on 2017/5/8.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "AppDelegate.h"
#import "DbHandler.h"

#import <InMobiSDK/IMSdk.h>
#import <InMobiSDK/IMCommonConstants.h>

#import "InterstitialAdViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong) InterstitialAdViewController *interstitialAdVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DbHandler initLocalDatabase];
    
    [IMSdk initWithAccountID:@"96efb6fea8fc47a884d8b8c190acb456"];
    [IMSdk setLogLevel:kIMSDKLogLevelDebug];
    
    self.interstitialAdVC=[[InterstitialAdViewController alloc] init];
    [self.interstitialAdVC.view setNeedsLayout];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self.interstitialAdVC showAdWithViewController:self.window.rootViewController];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
