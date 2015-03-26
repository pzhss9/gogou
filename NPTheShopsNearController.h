//
//  NPTheShopsNearController.h
//  new position
//
//  Created by apple on 14-11-10.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomLineLabel.h"
#import "AFHTTPRequestOperationManager.h"
@interface NPTheShopsNearController : UITableViewController
///店铺名称
@property NSMutableArray * theShopNames;
///AFNetworking 控制器
@property AFHTTPRequestOperationManager *manager;





///下拉刷新完成标志
@property BOOL refreshing;
///店铺商品
@property NSMutableArray * theGoods;


//点击搜索按钮
-(IBAction)tipSearchBarButton;
@end
