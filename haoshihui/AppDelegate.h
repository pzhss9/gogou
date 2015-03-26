//
//  AppDelegate.h
//  new position
//
//  Created by apple on 14-11-10.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"
#import "NPPayBillController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
///抽屉式图控制器
@property YRSideViewController * rootView;
@property NPPayBillController *payController;
///用户账号
@property NSString * userAccount;
///用户密码
@property NSString * password;

//当前控制器
@property UITableViewController * currentController;
@end

