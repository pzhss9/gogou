//
//  NPShopsController.h
//  new position
//
//  Created by apple on 14-12-3.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
@interface NPShopsController : UITableViewController
@property  NSString *Name;
///商店数据
@property NSArray *data;

@property AFHTTPRequestOperationManager *manager;

@end
