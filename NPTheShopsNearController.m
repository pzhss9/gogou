//
//  NPTheShopsNearController.m
//  new position
//
//  Created by apple on 14-11-10.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import "NPTheShopsNearController.h"
#import "NPDefaults.h"
#import "NPDetailsPageController.h"
#import "NPSearchViewController.h"
#import "AppDelegate.h"
@import CoreLocation;

@interface NPTheShopsNearController ()<CLLocationManagerDelegate>

@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@end

@implementation NPTheShopsNearController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.tableView.tableHeaderView = [[UIView alloc] initWithFrame :  CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8 ) {
        
        //由于IOS8中定位的授权机制改变
        
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        //获取授权认证
        [self.locationManager
         requestWhenInUseAuthorization];
    }
    self.beacons = [[NSMutableDictionary alloc] init];
   
    // 获取需要监听的UUID范围
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    
    for (NSUUID *uuid in [NPDefaults sharedDefaults].supportedProximityUUIDs)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        self.rangedRegions[region] = [NSArray array];
    }
    
    //初始化下拉刷新
    UIRefreshControl *refreshController=[[UIRefreshControl alloc]init];
    refreshController.attributedTitle=  [[NSAttributedString alloc ]initWithString: @"下拉刷新"];
    [refreshController addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=refreshController;
    
   
    //初始化afnetwork
    self.manager = [AFHTTPRequestOperationManager manager];
    
    self.manager.responseSerializer =[[AFCompoundResponseSerializer alloc]init];
    //开始监控
    
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        
        [self.locationManager startRangingBeaconsInRegion:region];
        //如果1.8秒没监督到，说明不在附近，停止监督。
        [self performSelector:@selector(stopRangingBeaconsInRegion:) withObject:region afterDelay:1.8];
    }
    
    self.theGoods = [[NSMutableArray alloc]init];
    self.theShopNames=[[NSMutableArray alloc]init];

   
}
//下拉刷新

-(void ) refreshData
{
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    [self.theGoods removeAllObjects];
    [self.theShopNames removeAllObjects];
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
    
    [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:3];

    
}
-(void)callBackMethod:(id)obj
{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle =[[NSAttributedString alloc]initWithString:@"下拉刷新"];
    //[self loadData];
    NSLog(@"刷新成功");
    [self.tableView reloadData];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    //self.theGoods =nil;
   // self.theShopNames=nil;
}
//每次视图出现的时候调用的函数
- (void)viewWillAppear:(BOOL)animated
{
    
    AppDelegate *tmpDelegate=[UIApplication sharedApplication].delegate;
    tmpDelegate.currentController =self;
    [super viewDidAppear:animated];
    
   //每次视图出现时，监听附近的ibeacon
    
}

//开始监听时每隔1秒时间就会调用这个函数
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
       self.rangedRegions[region] = beacons;
      [self.beacons removeAllObjects];

    
    NSLog(@"%lu",(unsigned long)[beacons count]);
    if([beacons count]!=0)
    {
        for(int i=0;i<[beacons count];i++)
        {
            CLBeacon *beaconItem=beacons[i];
            [self loadData:[beaconItem.proximityUUID UUIDString]];
            [self.locationManager stopRangingBeaconsInRegion:region];
            NSLog(@"接收数据：%@",[beaconItem.proximityUUID UUIDString]);
            
        }
    }
    NSLog(@"over");
    
 //
    
}
-(void)stopRangingBeaconsInRegion:(id)region
{
    [self.locationManager stopRangingBeaconsInRegion:region];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData:(NSString *)UUID
{
    
    
    
    //数据模拟
    //获取店铺名称
  
    //获取商品信息
//    NSMutableArray *goods=[[NSMutableArray alloc]init];
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setValue:@"雪媚娘！是惬意？还是心动？记录了甜蜜的美" forKey:@"detail"];
//    [dic setValue:@"38" forKey:@"price"];
//    [dic setValue:@"GG_1.png" forKey:@"imgName"];
//    [dic setValue:@"58" forKey:@"oldPrice"];
//    [goods addObject:dic];
//     NSMutableDictionary *dic3=[[NSMutableDictionary alloc]init];
//    [dic3 setValue:@"儿童套餐！精选用上好材料，完美品质！" forKey:@"detail"];
//    [dic3 setValue:@"38" forKey:@"price"];
//    [dic3 setValue:@"GG_2.png" forKey:@"imgName"];
//    [dic3 setValue:@"58" forKey:@"oldPrice"];
//     [goods addObject:dic3];
//    [self.theGoods addObject:goods];
//    
//    NSMutableArray *goods2=[[NSMutableArray alloc]init];
//    NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
//    [dic2 setValue:@"酒吧套餐！劲爽一刻，邂逅精彩!" forKey:@"detail"];
//    [dic2 setValue:@"128" forKey:@"price"];
//    [dic2 setValue:@"GG_3.png" forKey:@"imgName"];
//    [dic2 setValue:@"248" forKey:@"oldPrice"];
//    [goods2 addObject:dic2];
//   [self.theGoods addObject:goods2];
   NSDictionary  *params=@{@"UUID":UUID};
    
    [self.manager
     
     POST:@"http://1.newposition.sinaapp.com/test.php"
     
     parameters:params
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"接收成功！");
         
         NSError *error;
         NSData *data=[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         NSArray *tmp=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         for(int i=0;i<[tmp count];i++)
         {
             NSMutableArray *tmp_array=[[NSMutableArray alloc]init];
             NSArray *shop_tmp=tmp[i];
             for(int k=0;k<[shop_tmp count];k++)
             {
                 NSDictionary *dic=shop_tmp[k];
                 if(k==0)
                 {
                     [self.theShopNames addObject: [dic valueForKey:@"Shopname"]];
                     continue;
                     
                 }
                 [tmp_array addObject:shop_tmp[k]];
             }
             [self.theGoods addObject:tmp_array];
         }
 
         [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
         
     }
     
     failure:
     
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error!");
         
     }];
  
    
}

#pragma mark - Table view data source
-(void)updateUI
{
    [self.tableView reloadData];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.theShopNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger num=[self.theGoods[section] count]+1;
   // NSLog(@"%ld",(long)num);
    return   num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.row==0)
    {
    cell= [tableView dequeueReusableCellWithIdentifier:@"shopNameCell" forIndexPath:indexPath];
        
        UILabel *name=(UILabel *)[cell viewWithTag:1];
        name.text=self.theShopNames[indexPath.section];
    }
    else
    {
        cell= [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
        UILabel *detail=(UILabel *)[cell viewWithTag:1];
        UILabel *price=(UILabel *)[cell viewWithTag:2];
        UIImageView *img=(UIImageView *)[cell viewWithTag:3];
               UICustomLineLabel * oldPrice=(UICustomLineLabel *)[cell viewWithTag:5];
      
        NSArray *tmpArray=self.theGoods[indexPath.section];
       // NSLog(@"%@",tmpArray);
        NSDictionary *tmpDic=tmpArray[indexPath.row-1];
        oldPrice.lineType=LineTypeMiddle;
        oldPrice.lineColor=[UIColor grayColor];
        oldPrice.text=[tmpDic valueForKey:@"OldPrice"];
        detail.text=[tmpDic valueForKey:@"Detail"];
        price.text=[tmpDic valueForKey:@"Price"];
        
        NSMutableArray *arry=[[NSMutableArray alloc]init];
        //获得服务器的图片信息
        [arry addObject:[tmpDic valueForKey:@"Imgname"]];
        [arry addObject:img];
        [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:arry];

        //img.image=[UIImage imageNamed: [tmpDic valueForKey:@"imgName"]];
        img.contentMode=UIViewContentModeScaleToFill;
        
    }
    
    // Configure the cell...
    
    return cell;
}
//设置cell高度函数
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0)
    {
        return 100;
    }
    else return 50;
    
}


//设置页眉
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0)
    {
        return @"欢迎来到XXX商城！";
    }
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NPDetailsPageController *controller=[storyboard instantiateViewControllerWithIdentifier:@"detailPageController"];
    if(indexPath.section==0&&indexPath.row==1)
    {
    
    controller.shopName=self.theShopNames[indexPath.section];
        NSArray *goods=self.theGoods[indexPath.section];
        NSDictionary *tmp=goods[indexPath.row-1];
        
    controller.goodDescription= [tmp valueForKey:@"Detail"];
       // NSLog(@"%@",controller.goodDescription);
    controller.realPrice=[tmp valueForKey:@"Price"];
        //NSLog(@"%@",controller.realPrice);
    controller.oldPrice=[tmp valueForKey:@"OldPrice"];
        // NSLog(@"%@",controller.oldPrice);
    controller.imgURL=[tmp valueForKey:@"Imgname"];
     //    NSLog(@"%@",controller.imgURL);
     controller.title= controller.shopName;
        controller.shopId=[tmp valueForKey:@"Shopid"];
        controller.goodsId=[tmp valueForKey:@"Goodsid"];
       // NSLog(@"%@",controller.goodsId);
       // NSLog(@"%@",controller.shopId);
         [self.navigationController pushViewController:controller animated:YES];
    }
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
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
        [self performSelectorOnMainThread:@selector(updateIMG:) withObject:data2 waitUntilDone:YES];
    }
    
}
//更新UI
-(void)updateIMG:(NSArray *) data
{
    UIImageView *imgView=data[1];
    UIImage *img=data[0];
    imgView.image=img;
    [imgView setAutoresizesSubviews:YES];;
    
}


- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
//点击了搜索按钮
-(IBAction)tipSearchBarButton
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *mode= [storyboard instantiateViewControllerWithIdentifier:@"searchMode"];
    
    [self presentViewController:mode animated:YES completion:^{
        
        NSLog(@"进入模态视图！");
        
    }];
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
