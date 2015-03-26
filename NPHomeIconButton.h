//
//  NPHomeIconButton.h
//  new position
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeIconButtonDataSource <NSObject>
-(NSString *)setIconTitle;
-(UIImage * )setIcon;
-(void)pushController:(NSString*)title;
@end

@interface NPHomeIconButton : UIButton
@property (nonatomic,strong) NSString * titleBelowIcon;
@property (nonatomic, assign) IBOutlet id <HomeIconButtonDataSource> dataSource;
@property (nonatomic,assign) BOOL initialized;
@end