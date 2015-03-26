//
//  MainPageController.m
//  new position
//
//  Created by apple on 14-11-21.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import "MainPageController.h"
#import "NPShopsController.h"
#import "NPShopListController.h"
#import "AppDelegate.h"
@interface MainPageController ()<UIScrollViewDelegate>

@end

@implementation MainPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor colorWithRed:251.0/255 green:45.0/255 blue:101.0/255 alpha:1]];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame :  CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.data=[[NSMutableArray alloc]init];
    self.manager = [AFHTTPRequestOperationManager manager];
    
    self.manager.responseSerializer =[[AFCompoundResponseSerializer alloc]init];
    //修改nav返回键颜色
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255 green:0 blue:171.0/255 alpha:1];
    
    self.page=1;
    self.titleOfButtonicon =@[@"食品",@"玩具",@"化妆品",@"家具",@"电子产品",@"更多",@"女装",@"男装"];
    self.imgOfButtonicon=@[@"button_im5",@"button_im3.png",@"button_im4.png",@"button_im6.png",@"button_im7.png",@"button_im8.png",@"button_im2.png",@"button_im1.png"];
    
  
    //假设已经联网
    self.couldNetworking=true;
    
    if(self.couldNetworking==true)
    {
        [NSThread detachNewThreadSelector:@selector(loadNetData) toTarget:self withObject:nil];
    }
    //计时器初始化
    self.adTimer =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollAd) userInfo:nil repeats:YES];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    
    AppDelegate *tmpDelegate=[UIApplication sharedApplication].delegate;
    tmpDelegate.currentController =self;
    [self    performSelector:@selector(beginScrollAutomatic) withObject:nil afterDelay:5.0];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
     [self.adTimer setFireDate:[NSDate distantFuture]];
    self.flag=1;
}

-(void)loadNetData
{
    [self.manager
     
     POST:@"http://1.newposition.sinaapp.com/index/index.php"
     
     parameters:nil
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         
         NSData *responseData=[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         
         self.data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
        
         //如果原始数据超过5条就只加入5条
         if([self.data count]>=5)
         {
            self.currentData=[[NSMutableArray alloc]init];
         for(int i=0;i<5;i++)
         {
             [self.currentData addObject:self.data[i]];
         }
             //NSLog(@"%@",self.currentData);
         }
         //否则就拷贝原始数据
         else
         {
             self.currentData=[self.data copy];
         }
         [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
         
         NSLog(@"首页获取服务器数据成功!");
     }
     
     failure:
     
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"首页获取服务器数据出错!");
         
     }];
}

//重新加载视图
-(void)reloadData
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0)
        return 2;
    else if(section==1)
    {
        return 1;
    }
    else if([self.currentData count]<5)
    {
        return 1;
    }
       else
    {
        return [self.currentData count]+2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section==0&&indexPath.row==0)
    {
        
               cell = [tableView dequeueReusableCellWithIdentifier:@"ScrollAdCell" forIndexPath:indexPath];
        
        self.scrollView=(UIScrollView *)[cell viewWithTag:1];
        //NSLog(@"%@",self.scrollView);
        self.pageView= (UIPageControl *)[cell viewWithTag:2];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake( 375* 5,100);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * 1;
        frame.origin.y = 0;
        [self.scrollView scrollRectToVisible:frame animated:NO];
        
        //设置page
        self.pageView.backgroundColor = [UIColor clearColor];
        self.pageView.numberOfPages = 3;
        self.pageView.currentPage = 0;
        [self.pageView addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self createPages];
        
       
        
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell" forIndexPath:indexPath];
    }
    else if(indexPath.section==1)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"ButtonAdCell" forIndexPath:indexPath];
    }
    else if(indexPath.section==2&&indexPath.row==0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
        
    }
    else if(indexPath.section==2&&indexPath.row!=self.page*5+1)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        NSDictionary *tmpDic=self.data[indexPath.row-1];
       // NSDictionary *tmpDic=self.data[indexPath.row-1];
        UIImageView *imgView=(UIImageView *)[cell viewWithTag:1];
        NSMutableArray *arry=[[NSMutableArray alloc]init];
        
        if(![[tmpDic valueForKey:@"Img"] isEqualToString:@""])
        {
            //获得服务器的图片信息
            [arry addObject:[tmpDic valueForKey:@"Img"]];
            [arry addObject:imgView];
            [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:arry];
        }

               UILabel *shopName=(UILabel *)[cell viewWithTag:2];
        shopName.text=[tmpDic valueForKey:@"Shopname"];
        UILabel *detail=(UILabel *)[cell viewWithTag:3];
        detail.text=[tmpDic valueForKey:@"Shopinfo"];
    
    }
     else if(indexPath.section==2&&indexPath.row==self.page*5+1)
     {
           cell=[tableView dequeueReusableCellWithIdentifier:@"more" forIndexPath:indexPath];
     }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        return 120;
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        return 186;
        
        
    }
    else if(indexPath.section==1)
    {
        return 70;
        
    }
    else if(indexPath.section==2&&indexPath.row==0)
    {
        return 40;
        
    }
    else if(indexPath.section==2&&indexPath.row==self.page*5+1)
        return 40;
    
    else  return 90;
    
}
////当cell出现时，加载图片
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section==2&&indexPath.row!=0&&indexPath.row!=self.page*10+1)
//    {
////        NSLog(@"%@",self.data);
////       // NSLog(@"%@",self.data[indexPath.row-1]);
//    NSDictionary *tmpDic=self.data[indexPath.row-1];
//    UIImageView *imgView=(UIImageView *)[cell viewWithTag:1];
//    NSMutableArray *arry=[[NSMutableArray alloc]init];
//        
//        if(![[tmpDic valueForKey:@"Img"] isEqualToString:@""])
//        {
//    //获得服务器的图片信息
//    [arry addObject:[tmpDic valueForKey:@"Img"]];
//    [arry addObject:imgView];
//    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:arry];
//        }
//    }
//}
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








//当广告中页面变化会调用这个函数

- (void)changePage:(id)sender
{
    int page = (int)self.pageView.currentPage;
    //NSLog(@"xxxx");
    
    
    
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth);
    self.pageView.currentPage = page;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
     CGFloat pageWidth = sender.frame.size.width;
    if(sender.contentOffset.x>pageWidth*3.5)
            {
                CGRect frame = self.scrollView.frame;
                frame.origin.x = frame.size.width * 1;
               frame.origin.y = 0;
               [self.scrollView scrollRectToVisible:frame animated:NO];
                self.pageView.currentPage=0;
            }
    if(sender.contentOffset.x<0.5*pageWidth)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * 3;
        frame.origin.y = 0;
        [self.scrollView scrollRectToVisible:frame animated:NO];
        self.pageView.currentPage=2;
    }
    self.flag=1;
    [self performSelector:@selector(beginScrollAutomatic) withObject:nil afterDelay:5.0];

}
-(void)beginScrollAutomatic
{
    if(self.flag==1)
    {
    [self.adTimer setFireDate:[NSDate distantPast]];
        self.flag=0;
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.adTimer setFireDate:[NSDate distantFuture]];
}

- (void)createPages
{
    CGRect pageRect = self.scrollView.frame;
    
    //创建页面
    UIView *page0 = [[UIView alloc] initWithFrame:pageRect];
    page0.backgroundColor = [UIColor blackColor];
    [page0 setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"ad3.png"]]];

    
    UIView *page1 = [[UIView alloc] initWithFrame:pageRect];
    page1.backgroundColor = [UIColor blackColor];
    [page1 setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"ad.png"]]];
    UIView *page2 = [[UIView alloc] initWithFrame:pageRect];
    page2.backgroundColor = [UIColor blackColor];
    [page2 setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"ad2.png"]]];
    UIView *page3 = [[UIView alloc] initWithFrame:pageRect];
    page3.backgroundColor = [UIColor blackColor];
    [page3 setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"ad3.png"]]];
    UIView *page4 = [[UIView alloc] initWithFrame:pageRect];
    page4.backgroundColor = [UIColor blackColor];
    [page4 setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"ad.png"]]];

    
    
    //增加到ScrollView
    [self loadScrollViewWithPage:page0];
    [self loadScrollViewWithPage:page1];
    [self loadScrollViewWithPage:page2];
    [self loadScrollViewWithPage:page3];
    [self loadScrollViewWithPage:page4];
    
    
    
}

- (void)loadScrollViewWithPage:(UIView *)page
{
    int pageCount = (int)[[self.scrollView subviews] count];
    
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = bounds.size.width * pageCount;
    bounds.origin.y = 0;
    page.frame = bounds;
    [self.scrollView addSubview:page];
    
}



//广告计时器滚动函数
-(void)scrollAd
{
    int page = ((int)self.pageView.currentPage+1)%3;

    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * (page+1);
    frame.origin.y = 0;
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
    //self.pageView.currentPage=page;
}




#pragma mark HomeIconDataSource
-(UIImage *)setIcon{
    static int  i=0;
    
    
    UIImage * img= [UIImage imageNamed:self.imgOfButtonicon[i]];
    UIImage * scaledimg=[UIImage imageWithCGImage:img.CGImage scale:img.scale*1.2 orientation:img.imageOrientation];
    i++;
    return  scaledimg;
}
-(NSString *)setIconTitle{
    static int i=0;
    
    return self.titleOfButtonicon[i++];
    
}





//点击按钮函数

-(void)pushController:(NSString*)title
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NPShopsController *sec= [storyboard instantiateViewControllerWithIdentifier:@"shops"];
    sec.Name=title;
    [self.navigationController pushViewController:sec animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2&&indexPath.row!=0&&indexPath.row!=self.page*5+1)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         NSDictionary *tmpDic=self.data[indexPath.row-1];
        NPShopListController *sec= [storyboard instantiateViewControllerWithIdentifier:@"shopListController"];
       sec.shopId=[tmpDic valueForKey:@"Shopid"];
        //sec.shopId=@"1";
        [self.navigationController pushViewController:sec animated:YES];
    }
    if(indexPath.section==2&&indexPath.row==self.page*5+1)
    {
        if([self.data count]-[self.currentData count]>=5)
        {
            
            int i=0;
            for(i=0;i<5;i++)
            {
                [self.currentData addObject:self.data[self.page*5+i]];
            }
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            self.page++;
        }
        else if([self.data count]-[self.currentData count]>0)
        {
            int i=(int)[self.data count]-(int)[self.currentData count];
            for(i=0;i<5;i++)
            {
                [self.currentData addObject:self.data[self.page*5+i]];
            }
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            self.page++;
            
        }
        else
        {
            UIAlertView *newAlertView=[[UIAlertView alloc]initWithTitle:@"加载出错" message:@"没有更多了！" delegate:self cancelButtonTitle:@"OK!" otherButtonTitles: nil];
            [newAlertView show];
        }
            
    }
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil ];
}
- (void)deselect
{
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
//打开或者关闭抽屉视图

-(IBAction)tipHeadImgBtn:(id)sender
{
     AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    [appDelegate.rootView showLeftViewController:YES];
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
