//
//  NPShopListController.h
//  new position
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
@interface NPShopListController : UITableViewController
///店家商品列表
@property NSArray *data;

@property NSString* shopId;

@property AFHTTPRequestOperationManager *manager;

@end
