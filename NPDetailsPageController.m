//
//  NPDetailsPageController.m
//  new position
//
//  Created by apple on 14-11-12.
//  Copyright (c) 2014年 NP. All rights reserved.
//
#import "NPTelephonModalityControllerView.h"
#import "NPDetailsPageController.h"
#import "UICustomLineLabel.h"
#import "NPPayBillController.h"
@interface NPDetailsPageController ()
///支付按钮
@property  UIButton *payButton;
@end

@implementation NPDetailsPageController

- (void)viewDidLoad {
    [super viewDidLoad];
      self.tableView.tableHeaderView = [[UIView alloc] initWithFrame :  CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.navigationItem.title=self.shopName;
   
    //初始化afnetwork
    self.manager = [AFHTTPRequestOperationManager manager];
    
    self.manager.responseSerializer =[[AFCompoundResponseSerializer alloc]init];
    NSLog(@"%@   %@",self.shopId,self.goodsId);
 [self getDataWithShopId:self.shopId goodsId:self.goodsId];
}
//获取信息函数
-(void)getDataWithShopId:(NSString *)shopId goodsId:(NSString *)goodsId
{
//    //模拟数据
//    self.data =[[NSMutableArray alloc]init];
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setValue:@"headImg.png" forKey:@"headImg"];
//    [dic setValue:@"188" forKey:@"price"];
//    [dic setValue:@"238" forKey:@"oldPrice"];
//    [self.data addObject:dic];
//     NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
//    [dic2 setValue:@"贝儿兔烘焙" forKey:@"shopName"];
//    [dic2 setValue:@"彩虹蛋糕！简约大方，润滑细腻口感" forKey:@"detail"];
//    [self.data addObject:dic2];
//     NSMutableDictionary *dic3=[[NSMutableDictionary alloc]init];
//    [dic3 setValue:@"商家信息" forKey:@"title"];
//    [dic3 setValue:@"贝儿兔烘焙" forKey:@"shopName"];
//    [dic3 setValue:@"杭州市临安市锦城镇浙江林学院大西门商业街" forKey:@"address"];
//    [self.data addObject:dic3];
//    NSMutableDictionary *dic4=[[NSMutableDictionary alloc]init];
//    [dic4 setValue:@"消费提示" forKey:@"title"];
//    [dic4 setValue:@"注意事项1：XXXXXXX\n注意事项2：XXXXXXXX\n注意事项3：XXXXXX\n" forKey:@"attention"];
//    [self.data addObject:dic4];
    NSDictionary *params=@{@"Shopid":shopId,@"Goodsid":goodsId};
    
    [self.manager
     
     POST:@"http://1.newposition.sinaapp.com/spe_info.php"
     
     parameters:params
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         self.data =[[NSMutableArray alloc]init];
         NSError *error;
         NSData *data=[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        
          NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         
         NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
         [dic setValue:[responseData valueForKey:@"Imagename"] forKey:@"headImg"];
         [dic setValue:[responseData valueForKey:@"Newprice"] forKey:@"price"];
         [dic setValue:[responseData valueForKey:@"Oldprice"] forKey:@"oldPrice"];
         [self.data addObject:dic];
          NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
         [dic2 setValue:[responseData valueForKey:@"Shopname"] forKey:@"shopName"];
         [dic2 setValue:[responseData valueForKey:@"Content"]forKey:@"detail"];
         [self.data addObject:dic2];
         NSMutableDictionary *dic3=[[NSMutableDictionary alloc]init];
         [dic3 setValue:@"商家信息" forKey:@"title"];
         [dic3 setValue:[responseData valueForKey:@"Shopname"] forKey:@"shopName"];
         [dic3 setValue:[responseData valueForKey:@"Shopaddress"] forKey:@"address"];
         [dic3 setValue:[responseData valueForKey:@"Shopphone"] forKey:@"Shopphone"];
         [self.data addObject:dic3];
         NSMutableDictionary *dic4=[[NSMutableDictionary alloc]init];
         [dic4 setValue:@"套餐内容" forKey:@"title"];
         [dic4 setValue:[responseData valueForKey:@"Forsale"]forKey:@"attention"];
         self.phoneNumber=[responseData valueForKey:@"Shopphone"];
         [self.data addObject:dic4];
 [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
     }
     
     failure:
     
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"error!");
         
     }];
    
}
//重新更新UI
-(void)updateUI
{
    [self.tableView reloadData];
    
}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//收藏商品
-(IBAction)selectGoods:(id)sender
{
    
    
   NSArray *tmp= [[NSUserDefaults standardUserDefaults] objectForKey:@"MySelectedGoods"];
    if(tmp==nil)//如果以前没有收藏则创建一个
    {
        tmp = [[NSArray alloc]init];
        //[[NSUserDefaults standardUserDefaults] setObject:tmp forKey:@"MySelectedGoods"];
    }
    NSMutableArray *data= [tmp mutableCopy];
    
    NSMutableDictionary *goods=[[NSMutableDictionary alloc]init];
  //  NSString *title=@"test";
    [goods setValue:self.goodsId forKey:@"goodsId"];
     [goods setValue:self.shopId forKey:@"shopId"];
     [goods setValue:self.goodsName forKey:@"goodsName"];
       [goods setValue:self.goodDescription forKey:@"description"];
    [goods setValue:self.realPrice forKey:@"realPrice"];
    [goods setValue:self.oldPrice forKey:@"oldPrice"];
     [goods setValue:self.imgURL forKey:@"imgURL"];

    if([data indexOfObject:goods]!=NSNotFound)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"收藏失败" message:@"您已经添加过该物品" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
     [data addObject:goods];
    
     // NSLog(@"%@",self.data);
     [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MySelectedGoods"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"收藏成功" message:@"您已成功添加该物品" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];

    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   if(section ==0)
   {
       return 2;
   }
    else if(section==1)
    {
        return 1;
    }
    else if(section==2)
        return 3;
    else if(section==3)
        return 2;
 
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSDictionary *dataDic=self.data[indexPath.section];
    
    if(indexPath.section==0&&indexPath.row==0)
    {
    cell= [tableView dequeueReusableCellWithIdentifier:@"headImgCell" forIndexPath:indexPath];
        UIImageView *img=(UIImageView *)[cell viewWithTag:1];
        NSString *imagePath=[dataDic valueForKey:@"headImg"];
        //如果图片路径不存在，则报错
        if([imagePath isEqualToString:@""]||imagePath==NULL)
        {
            NSLog(@"加载图片出错，图片路径：%@",imagePath);
            
        }
        else
        {
        
            NSMutableArray *arry=[[NSMutableArray alloc]init];
            //获得服务器的图片信息
            [arry addObject:imagePath];
            [arry addObject:img];
            [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:arry];
        }
        //NSLog(@"XXXXXXXX%@",imagePath);
        //img.image=[UIImage imageNamed:imagePath];
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        cell= [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
        UILabel *price=(UILabel *)[cell viewWithTag:1];
        price.text=[dataDic valueForKey:@"price"];
        self.realPrice=price.text;
        UICustomLineLabel *oldPrice=(UICustomLineLabel *)[cell viewWithTag:2];
        oldPrice.text=[dataDic valueForKey:@"oldPrice"];
        oldPrice.lineType=LineTypeMiddle;
        
       // self.goodsName=[dataDic valueForKey:@"goodsName"];
       // NSLog(@"%@",self.goodsName);
      // self.navigationItem.title=self.goodsName;
        
        
        self.payButton =(UIButton *)[cell viewWithTag:3];
        
        [self.payButton addTarget:self action:@selector(payThings) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    else if(indexPath.section==1&&indexPath.row==0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"advertisingCell" forIndexPath:indexPath];
        UILabel *shopName=(UILabel *)[cell viewWithTag:1];
        shopName.text=[dataDic valueForKey:@"shopName"];
        UILabel *detail=(UILabel*)[cell viewWithTag:2];
        detail.text=[dataDic valueForKey:@"detail"];
        self.goodsName=detail.text;
      //  NSLog(@"%@",self.goodsName);
        self.navigationItem.title=self.goodsName;

    }
    else if(indexPath.section==2&&indexPath.row==0)
    {
         cell=[tableView dequeueReusableCellWithIdentifier:@"headName" forIndexPath:indexPath];
        UILabel *title=(UILabel *)[cell viewWithTag:1];
        title.text=@"商家信息";
    }
    else if(indexPath.section==2&&indexPath.row==1)
    {
         cell=[tableView dequeueReusableCellWithIdentifier:@"advertisingCell" forIndexPath:indexPath];
        UILabel *shopName=(UILabel *)[cell viewWithTag:1];
        shopName.text=[dataDic valueForKey:@"shopName"];
        UILabel *address=(UILabel *)[cell viewWithTag:2];
        address.text=[dataDic valueForKey:@"address"];
    }
    else if(indexPath.section==2&&indexPath.row==2)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"telCell" forIndexPath:indexPath];
        UIButton *telephone=(UIButton *)[cell viewWithTag:1];
        [telephone addTarget:self action:@selector(callTelephone) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(indexPath.section==3&&indexPath.row==0)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"headName" forIndexPath:indexPath];
        UILabel *title=(UILabel *)[cell viewWithTag:1];
        title.text=@"订单内容";
    }
    else if(indexPath.section==3&&indexPath.row==1)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"attention" forIndexPath:indexPath];
        UITextView *text=(UITextView *)[cell viewWithTag:1];
        text.text=[dataDic valueForKey:@"attention"];
    }


 
    
    return cell;
}
//打电话
-(void)callTelephone
{
    
   
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"确认拨打%@?",self.phoneNumber] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
            break; 
            
         
            
    } 
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        return 185;
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        return 60;
    }
    else if(indexPath.section==1&&indexPath.row==0)
    {
        return 70;
    }
    else if(indexPath.section==2&&indexPath.row==0)
    {
        return 40;
    }
    else if(indexPath.section==2&&indexPath.row==1)
    {
        return 70;
    }
    else if(indexPath.section==2&&indexPath.row==2)
    {
        return 50;
    }
    else if(indexPath.section==3&&indexPath.row==0)
    {
        return 40;
        
    }
    else if(indexPath.section==3&&indexPath.row==1)
    {
        return 80;
    }
    else return 80;
    
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
    [imgView setAutoresizesSubviews:YES];
    
}
//购买物品
-(void)payThings
{
    BOOL canBuy=YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NPPayBillController *sec= [storyboard instantiateViewControllerWithIdentifier:@"payThings"];
    UIAlertView * alert;
    if(self.goodsName==NULL)
    {
        alert=[[UIAlertView alloc]initWithTitle:@"error" message:@"商品名称为空" delegate:self cancelButtonTitle:@"OK!" otherButtonTitles: nil];
        [alert show];
        canBuy=NO;
    }
    else if(self.realPrice==NULL)
    {
        alert=[[UIAlertView alloc]initWithTitle:@"error" message:@"商品价格为空" delegate:self cancelButtonTitle:@"OK!" otherButtonTitles: nil];
        [alert show];
        canBuy=NO;
    }
    
        
    sec.nameOfCommodity=self.goodsName;
    sec.priceOfCommodity=[self.realPrice doubleValue];
    sec.shopId=self.shopId;
    sec.goodsId=self.goodsId;
    if(canBuy)
    {
    [self.navigationController pushViewController:sec animated:YES];
    }
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
