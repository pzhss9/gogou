//
//  NPHomeIconButton.m
//  new position
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import "NPHomeIconButton.h"

@implementation NPHomeIconButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.initialized=NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.initialized) {
        return;
    }
    //取消IB中的title
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateHighlighted];
    //显示自己添加的的title
    UILabel * l=[[UILabel alloc]initWithFrame:CGRectMake(0, 65, self.bounds.size.width ,22)];
    self.titleBelowIcon=[self.dataSource setIconTitle];
    l.text=self.titleBelowIcon;
    l.textAlignment=NSTextAlignmentCenter;
    l.font = [UIFont fontWithName:@"Arial" size:15];
    l.textColor=[UIColor colorWithRed:150./255 green:150./255 blue:150./255 alpha:1];
    [self addSubview:l];
    //添加图片
    UIImage * img=[self.dataSource setIcon];
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:img forState:UIControlStateHighlighted];
    //设置背景图片
    UIImage * bgimg=[UIImage imageNamed:@"app_item_pressed_bg.png"];
    [self setBackgroundImage:bgimg forState:UIControlStateHighlighted];
    UIImage * bgimg2=[UIImage imageNamed:@"app_item_bg.png"];
    [self setBackgroundImage:bgimg2 forState:UIControlStateNormal];
    
    //设置insets
    self.contentEdgeInsets=UIEdgeInsetsMake(-11, 0, 0, 0);
    //响应事件
    //    [self addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    //    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpOutside];
    self.initialized=YES;
}
-(void)touchUp
{
    [self.dataSource pushController:self.titleBelowIcon];
}

@end
