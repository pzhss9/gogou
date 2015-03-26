//
//  AppDelegate.m
//  new position
//
//  Created by apple on 14-11-10.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import "AppDelegate.h"
#import "YRSideViewController.h"
#import "ViewController.h"

#import "Pingpp.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    YRSideViewController *rootViewController=[[YRSideViewController alloc]init];
    
    UIStoryboard * storyBoard=   [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *rootView=[storyBoard instantiateViewControllerWithIdentifier:@"rootView"];
    rootViewController.rootViewController=rootView;
    self.rootView=rootViewController;
    
    
    UITableViewController *leftViewController=[storyBoard instantiateViewControllerWithIdentifier:@"leftView"];
    rootViewController.leftViewController=leftViewController;
    
    
    
    self.window.rootViewController=rootViewController;
    
    [self readUserInformation];
    
    sleep(2);
    return YES;
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
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        // result : success, fail, cancel, invalid
        NSString *msg;
        if (error == nil) {
            NSLog(@"PingppError is nil");
            msg = @"您已支付成功！";
        } else {
            NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
            msg = [NSString stringWithFormat:@"result=%@ PingppError: code=%lu msg=%@", result, (unsigned long)error.code, [error getMsg]];
            
            
        }
        [self.payController showAlertMessage:msg];
    }];
    return  YES;
}
//读取用户信息函数
-(void)readUserInformation
{
    //测试用户数据
    self.userAccount=@"xsz88287703";
    self.password=@"88287703";
    
}
@end
