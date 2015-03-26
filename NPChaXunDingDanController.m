//
//  NPChaXunDingDanController.m
//  haoshihui
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 NP. All rights reserved.
//

#import "NPChaXunDingDanController.h"
#import "AFHTTPRequestOperationManager.h"
#import "NPDetailBillController.h"
@interface NPChaXunDingDanController ()
//从服务器获取的订单数据
@property NSMutableArray *billData;

@property AFHTTPRequestOperationManager *manager;
@end

@implementation NPChaXunDingDanController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.billData =[[ NSMutableArray alloc]init];
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    self.manager.responseSerializer =[[AFCompoundResponseSerializer alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //每当页面出现申请查询订单
    [self requestForBillData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.billData count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCell" forIndexPath:indexPath];
    NSDictionary *tmpDic=self.billData[indexPath.row];
    
    
    UILabel * orderTest=(UILabel *)[cell viewWithTag:2];
    orderTest.text=[NSString stringWithFormat:@"订单号： %@", [tmpDic valueForKey:@"Dealnum"] ];
    
    UILabel *goodsNameTest=(UILabel *)[cell viewWithTag:3];
    goodsNameTest.text=[tmpDic valueForKey:@"Goodsname"];
    
    UILabel *timeTest=(UILabel *)[cell viewWithTag:4];
    timeTest.text=[tmpDic valueForKey:@"DealTime"];
    
    UILabel *allPriceText=(UILabel *)[cell viewWithTag:5];
    allPriceText.text=[NSString stringWithFormat:@"%@ 元",[tmpDic valueForKey:@"Amount"] ];
    
    
    UILabel *stateText=(UILabel *)[cell viewWithTag:6];
    stateText.text=[tmpDic valueForKey:@"Status"];
    
    UIImageView *imgView =(UIImageView *)[cell viewWithTag:1];
    NSMutableArray *arry=[[NSMutableArray alloc]init];
    
    if(![[tmpDic valueForKey:@"Image"] isEqualToString:@""])
    {
        //获得服务器的图片信息
        [arry addObject:[tmpDic valueForKey:@"Image"]];
        [arry addObject:imgView];
        [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:arry];
    }

    
 
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

-(void)requestForBillData
{
    //测试数据
    //NSDictionary *tmp=[[NSDictionary alloc]initWithObjectsAndKeys:@"xxxxxxxx",@"orderNum",@"小酥饼",
   // @"goodsName",@"2014-12-23",@"time",@"32",@"price",@"已付款",@"state",nil];
   // [self.billData addObject:tmp];
    
   // NSLog(@"%@",self.billData);

     NSDictionary *params=@{@"userAccount":@"xsz88287703"
                            };
    //从服务器获取订单
    [self.manager
     
     POST:@"http://1.newposition.sinaapp.com/APP_DealSearch.php"
     
     parameters:params
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSError *error;
         
        self.billData= [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:&error];
         [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
         
         
         
     }
     
     failure:
     
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"获取订单失败！");
         
     }];
    

    
}
-(void)reloadData
{
    [self.tableView reloadData];
}
//加载图片
-(void)downloadImage:(NSArray *) imgData
{
    NSString *url=imgData[0];
    UIImageView *imgView=imgData[1];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc]initWithData:data];
    if(image == nil){
        
    }else
    {
        NSMutableArray *data2=[[NSMutableArray alloc]init];
        [data2 addObject:image];
        [data2 addObject:imgView];
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:data2 waitUntilDone:YES];
    }
    
}
//更新UI
-(void)updateUI:(NSArray *) data
{
    UIImageView *imgView=data[1];
    UIImage *img=data[0];
    imgView.image=img;
    [imgView setAutoresizesSubviews:YES];;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    UIStoryboard *mainStornboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NPDetailBillController * sec=[mainStornboard instantiateViewControllerWithIdentifier:@"detailBill"];
    sec.tmpDic=self.billData[indexPath.row];
    
    [self.navigationController pushViewController:sec animated:YES];
    
    
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
