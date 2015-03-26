//
//  YaoYiYaoController.h
//  haoshihui
//
//  Created by apple on 15-3-7.
//  Copyright (c) 2015年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import <CoreBluetooth/CoreBluetooth.h>
@interface YaoYiYaoController : UIViewController <UIAccelerometerDelegate,CBCentralManagerDelegate>

{
    UIAccelerationValue    myAccelerometer[3];
    
    //是否响应摇一摇的标志
    BOOL  _canShake;
    
}
@end
