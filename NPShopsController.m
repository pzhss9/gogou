//
//  NPShopsController.m
//  new position
//
//  Created by apple on 14-12-3.
//  Copyright (c) 2014年 NP. All rights reserved.
//
#import "NPDetailsPageController.h"
#import "NPShopsController.h"
#import "UICustomLineLabel.h"
@interface NPShopsController ()

@end

@implementation NPShopsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame :  CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer =[[AFCompoundResponseSerializer alloc]init];
    self.title=self.Name;
    self.data =  [[NSArray alloc]init];

    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

//加载服务端商店数据
-(void)loadData
{
    NSDictionary *params=@{@"Shoptype":self.Name};
    [self.manager
     
     POST:@"http://1.newposition.sinaapp.com/index/type.php"
     
     parameters:params
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSLog(@"接收成功！");
         NSError *error;
         NSData *response=[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         self.data=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
         [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
     }
     
     failure:
     
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error!");
         
     }];
    
    
}
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    NSArray *tmpdata=self.data[section];
    return [tmpdata count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSArray *tmpArr=self.data[indexPath.section];
    NSDictionary *tmpDic=tmpArr[indexPath.row];
    
    if(indexPath.row==0)
    {
    cell= [tableView dequeueReusableCellWithIdentifier:@"shopsNameCell" forIndexPath:indexPath];
        UILabel *shopName=(UILabel*)[cell viewWithTag:1];
        
        shopName.text=[tmpDic valueForKey:@"Shopname"];
    }
    else
    {
        cell= [tableView dequeueReusableCellWithIdentifier:@"shopsDetailCell" forIndexPath:indexPath];
        UILabel *detail=(UILabel *)[cell viewWithTag:1];
        detail.text= [tmpDic valueForKey:@"Detail"];
        UILabel *newPrice=(UILabel *)[cell viewWithTag:2];
        newPrice.text=[tmpDic valueForKey:@"Price"];
        UICustomLineLabel *oldPrice=(UICustomLineLabel *)[cell viewWithTag:5];
        oldPrice.lineType=LineTypeMiddle;
        oldPrice.text=[tmpDic valueForKey:@"OldPrice"];
        UIImageView *imgView=(UIImageView *)[cell viewWithTag:3];
        
        NSMutableArray *arry=[[NSMutableArray alloc]init];
        //获得服务器的图片信息
        [arry addObject:[tmpDic valueForKey:@"Imgname"]];
        [arry addObject:imgView];
        [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:arry];
        
       
        imgView.contentMode=UIViewContentModeScaleToFill;

        
        
    }
    // Configure the cell...
    
    return cell;
}
//按下条目后的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row!=0)
    {
        NSArray *arr=self.data[indexPath.section];
        NSDictionary*tmpDic=arr[indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        NPDetailsPageController *sec= [storyboard instantiateViewControllerWithIdentifier:@"detailPageController"];
        sec.goodsId=[tmpDic valueForKey:@"Goodsid"];
        sec.shopId=[tmpDic valueForKey:@"Shopid"];
        
        sec.goodDescription= [tmpDic valueForKey:@"Detail"];
        // NSLog(@"%@",sec.goodDescription);
        sec.realPrice=[tmpDic valueForKey:@"Price"];
       // NSLog(@"%@",sec.realPrice);
        sec.oldPrice=[tmpDic valueForKey:@"OldPrice"];
        // NSLog(@"%@",sec.oldPrice);
        sec.imgURL=[tmpDic valueForKey:@"Imgname"];
         //   NSLog(@"%@",sec.imgURL);
  
        
        
        [self.navigationController pushViewController:sec animated:YES];
    }
    
    
    //擦除痕迹
     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
//加载图片
-(void)downloadImage:(NSArray *) imgData{
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
//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 50;
    }
    else return 100;
    
}
//更新UI
-(void)updateUI:(NSArray *) data
{
    UIImageView *imgView=data[1];
    UIImage *img=data[0];
    imgView.image=img;
    [imgView setAutoresizesSubviews:YES];;
    
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
