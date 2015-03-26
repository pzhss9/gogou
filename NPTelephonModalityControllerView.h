//
//  NPTelephonModalityControllerView.h
//  new position
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPTelephonModalityControllerView : UIViewController
@property IBOutlet UILabel *phoneNumber;
//取消事件
-(IBAction)cancel:(id)sender;
//确定事件
-(IBAction)sure:(id)sender;
@end
