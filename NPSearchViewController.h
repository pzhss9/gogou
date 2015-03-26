//
//  NPSearchViewController.h
//  new position
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
@interface NPSearchViewController : UITableViewController<UISearchBarDelegate>
@property IBOutlet UISearchBar *searchBar;
//获取的搜索结果资料
@property NSMutableArray *data;

@property AFHTTPRequestOperationManager *manager;

//取消模态窗口
-(IBAction)disappearMode:(id)sender;
@end
