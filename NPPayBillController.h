//
//  NPPayBillController.h
//  haoshihui
//
//  Created by apple on 15-3-8.
//  Copyright (c) 2015年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPPayBillController : UITableViewController
///商品价格
@property double  priceOfCommodity;
///商品名称
@property NSString * nameOfCommodity;
///购买数量
@property int  buyCountOfCommodity;
///收件人姓名
@property NSString *recipientName;

///收件人地址
@property NSString *recipientAddress;

///收件人电话
@property NSString *recipientPhoneNum;

///下单人账号
@property NSString *userAccount;
///店铺id
@property NSString *shopId;
///商品id
@property NSString * goodsId;
///商品单价
@property NSString * singlePrice;




///确认支付按钮
@property IBOutlet  UIButton * submitButton;
-(IBAction)resignFirstResponder:(id)sender;
//发起支付
-(IBAction)payBill:(id)sender;

- (void)showAlertMessage:(NSString*)msg;

@end
