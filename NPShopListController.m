//
//  NPShopListController.m
//  new position
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 NP. All rights reserved.
//

#import "NPShopListController.h"
#import "UICustomLineLabel.h"
#import "NPDetailsPageController.h"
@interface NPShopListController ()

@end

@implementation NPShopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame :  CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];

    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer =[[AFCompoundResponseSerializer alloc]init];
    self.data = [[NSArray alloc]init];
    [NSThread detachNewThreadSelector:@selector(getGoodsData) toTarget:self withObject:nil];
}
-(void)getGoodsData
{
    NSDictionary *params=@{@"Shopid":self.shopId};
    
    [self.manager
     
     POST:@"http://1.newposition.sinaapp.com/index/goods.php"
     
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopListCell" forIndexPath:indexPath];
    NSDictionary *tmpDic=self.data[indexPath.row];
    UILabel *goodsName=(UILabel *)[cell viewWithTag:4];
    NSLog(@"%@",tmpDic);
    goodsName.text=[tmpDic valueForKey:@"Goodsname"];
    UILabel *detail=(UILabel *)[cell viewWithTag:1];
    detail.text=[tmpDic valueForKey:@"Detail"];
    UICustomLineLabel *oldPrice=(UICustomLineLabel *)[cell viewWithTag:5];
    oldPrice.lineType=LineTypeMiddle;
    oldPrice.text=[tmpDic valueForKey:@"Oldprice"];
    UIImageView *imgView=(UIImageView *)[cell viewWithTag:3];
    NSMutableArray *arry=[[NSMutableArray alloc]init];
    //获得服务器的图片信息
    [arry addObject:[tmpDic valueForKey:@"Imgname"]];
    [arry addObject:imgView];
    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:arry];
    imgView.contentMode=UIViewContentModeScaleToFill;
    UILabel *newPrice=(UILabel*)[cell viewWithTag:2];
    newPrice.text=[tmpDic valueForKey:@"Newprice"];
    return cell;
}

//按下条目后的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
   
        NSDictionary *tmpDic=self.data[indexPath.row];
       
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        NPDetailsPageController *sec= [storyboard instantiateViewControllerWithIdentifier:@"detailPageController"];
        sec.goodsId=[tmpDic valueForKey:@"Goodsid"];
        sec.shopId=self.shopId;
    sec.goodDescription= [tmpDic valueForKey:@"Detail"];
    // NSLog(@"%@",sec.goodDescription);
    sec.realPrice=[tmpDic valueForKey:@"Price"];
    // NSLog(@"%@",sec.realPrice);
    sec.oldPrice=[tmpDic valueForKey:@"OldPrice"];
    // NSLog(@"%@",sec.oldPrice);
    sec.imgURL=[tmpDic valueForKey:@"Imgname"];
    NSLog(@"shopid= %@  goodsid= %@",self.shopId,sec.goodsId);
        [self.navigationController pushViewController:sec animated:YES];
    
    
    
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
//更新UI
-(void)updateUI:(NSArray *) data
{
    UIImageView *imgView=data[1];
    UIImage *img=data[0];
    imgView.image=img;
    [imgView setAutoresizesSubviews:YES];;
    
}
//设置cell高度
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
