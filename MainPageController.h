//
//  MainPageController.h
//  new position
//
//  Created by apple on 14-11-21.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPHomeIconButton.h"
#import "AFHTTPRequestOperationManager.h"
#import "UICustomLineLabel.h"
@interface MainPageController : UITableViewController<HomeIconButtonDataSource>
///先睹为快数据
@property NSMutableArray *data;
///scrollerView广告页
@property  UIScrollView *scrollView;
///广告页的page
@property  UIPageControl *pageView;
///存放主页Button的title
@property  NSArray *titleOfButtonicon;
///存放主页Button的图片地址
@property NSArray *imgOfButtonicon;
///有没有联网到标志
@property  BOOL couldNetworking;
///广告滚动计时器
@property NSTimer *adTimer;
///页码
@property NSInteger page;
///目前的cell的数据
@property NSMutableArray *currentData;
@property AFHTTPRequestOperationManager *manager;
@property BOOL flag;

//点击左上角头像按钮事件
-(IBAction)tipHeadImgBtn:(id)sender;



@end
