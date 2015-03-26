//
//  NPDetailsPageController.h
//  new position
//
//  Created by apple on 14-11-12.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"

@interface NPDetailsPageController : UITableViewController
@property NSString *uuid;
///商店ID号
@property NSString *shopId;
///货物名称
@property NSString *goodsId;
///商店名称
@property NSString *shopName;
@property NSMutableArray * data;
///商品名称
@property NSString *goodsName;
///商品描述
@property NSString *goodDescription;
///现价
@property NSString *realPrice;
///原价
@property NSString *oldPrice;
///图片资源地址
@property NSString *imgURL;
///右上角的收藏按钮
@property IBOutlet UIButton *button;
///afnetworking
@property AFHTTPRequestOperationManager *manager;
///电话号码
@property NSString *phoneNumber;
//收藏商品函数
-(IBAction)selectGoods:(id)sender;
@end
