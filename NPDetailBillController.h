//
//  NPDetailBillController.h
//  haoshihui
//
//  Created by apple on 15-3-23.
//  Copyright (c) 2015年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPDetailBillController : UITableViewController
///收件人姓名label
@property IBOutlet UILabel * nameText;
///收件人地址label
@property IBOutlet UILabel * addressText;
///收件人联系号码label
@property IBOutlet UILabel * phoneText;
///商品名称label
@property IBOutlet UILabel * goodsNameText;
/// 商品数量label
@property IBOutlet UILabel * goodsCountText;
///订单号label
@property IBOutlet UILabel * billNumberText;
///下单时间label
@property IBOutlet UILabel * billTimeText;
///总价label
@property IBOutlet UILabel * allPriceText;
///单价label
@property IBOutlet UILabel * onePriceText;

@property NSDictionary *tmpDic;
@end
