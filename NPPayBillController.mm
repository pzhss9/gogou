//
//  NPPayBillController.m
//  haoshihui
//
//  Created by apple on 15-3-8.
//  Copyright (c) 2015年 NP. All rights reserved.
//

#import "NPPayBillController.h"
#import "Pingpp.h"
#import "AppDelegate.h"

#define kWaiting          @"正在获取支付凭据,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kUrlScheme      @"PZHIOSPAY"
#define kUrl            @"http://1.newposition.sinaapp.com/PingPP/index.php"


@interface NPPayBillController ()

///提示框
@property UIAlertView* mAlert;

///减按钮
@property UIButton * reduceButton;
///加按钮
@property UIButton *addButton;
///数量
@property UITextView * countText;
///总价
@property UILabel * allPrice;
///收件人姓名text
@property UITextView * recipientNameText;
///收件人地址
@property UITextView *recipientAddressText;
///收件人电话
@property UITextView *recipientPhoneText;

@end

@implementation NPPayBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    //测试数据
    self.buyCountOfCommodity=1;
//    self.priceOfCommodity=10;
//    self.nameOfCommodity=@"五马美食";
      AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    appDelegate.payController=self;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
   
    if(section==0)
    {
        return 3;
    }
    else
    {
    return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell ;
    if(indexPath.section==0&&indexPath.row==0)//订单商品名称和价格
    {
    cell= [tableView dequeueReusableCellWithIdentifier:@"goodsName" forIndexPath:indexPath];
        //填写商品信息
        UILabel *nameLabel= (UILabel *)[cell viewWithTag:1];
        nameLabel.text=self.nameOfCommodity;
        
        UILabel *priceLabel=(UILabel *)[cell viewWithTag:2];
        priceLabel.text=[NSString stringWithFormat:@"%.2f 元",self.priceOfCommodity];
        
        
    }
    else if(indexPath.section==0&&indexPath.row==1)//购买数量
    {
        cell= [tableView dequeueReusableCellWithIdentifier:@"countCell" forIndexPath:indexPath];
        
        UIButton * reduceButton=(UIButton *)[cell viewWithTag:1];
        self.reduceButton=reduceButton;
        UIButton * addButton=(UIButton *) [cell viewWithTag: 2];
        self.addButton=addButton;
        UITextView *countText=(UITextView *)[cell viewWithTag:3];
        self.countText=countText;
        
        self.buyCountOfCommodity=1;
        reduceButton.hidden=YES;
        [self.reduceButton addTarget:self action:@selector(tipReduceButton) forControlEvents:UIControlEventTouchUpInside];
        [self.addButton addTarget:self action:@selector(tipAddButton) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    else if(indexPath.section==0&&indexPath.row==2)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"allPrice" forIndexPath:indexPath];
        UILabel * allPrice=(UILabel *)[cell viewWithTag:1];
        self.allPrice=allPrice;
        self.allPrice.text=[NSString stringWithFormat:@"%.2f 元",self.buyCountOfCommodity*self.priceOfCommodity];
        
        
        
    }
    else if(indexPath.section==1&&indexPath.row==0)
    {
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"recipientNameCell" forIndexPath:indexPath];
        UITextView *recipientNametext=(UITextView *)[cell viewWithTag:1];
        self.recipientNameText=recipientNametext;
        
        
        
    }
    else if(indexPath.section==1&&indexPath.row==1)
        {
            
            cell=[tableView dequeueReusableCellWithIdentifier:@"recipientAddressCell" forIndexPath:indexPath];
            UITextView *recipientAddressText=(UITextView *)[cell viewWithTag:1];
            self.recipientAddressText=recipientAddressText;
            
            
        }
    else if(indexPath.section ==1&&indexPath.row==2)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"recipientPhoneCell" forIndexPath:indexPath];
         UITextView *recipientPhoneText=(UITextView *)[cell viewWithTag:1];
        self.recipientPhoneText = recipientPhoneText;
    }
    
   
    
    

    
    return cell;
}
//点击加按钮
-(void)tipAddButton
{
    self.buyCountOfCommodity++;
    self.countText.text=[NSString stringWithFormat:@"%d",self.buyCountOfCommodity];
      self.allPrice.text=[NSString stringWithFormat:@"%.2f 元",self.buyCountOfCommodity*self.priceOfCommodity];
    self.reduceButton.hidden=NO;

}
//点击减按钮
-(void)tipReduceButton
{
    if (self.buyCountOfCommodity==2)
    {
        self.reduceButton.hidden=YES;
        self.buyCountOfCommodity--;
        self.countText.text=@"1";
          self.allPrice.text=[NSString stringWithFormat:@"%.2f 元",self.buyCountOfCommodity*self.priceOfCommodity];
        
    }
    else
    {
        self.buyCountOfCommodity--;
        self.countText.text=[NSString stringWithFormat:@"%d",self.buyCountOfCommodity];
        self.allPrice.text=[NSString stringWithFormat:@"%.2f 元",self.buyCountOfCommodity*self.priceOfCommodity];
        
    }
}

-(IBAction)resignFirstResponder:(id)sender;
{
    [sender resignFirstResponder];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       return 50;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil ];
}
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *result = nil;
    if(section==1)
    {
        result=@"收件人信息:";
    }
        
       return result;
}


//发起支付
-(IBAction)payBill:(id)sender
{
    self.recipientAddress=self.recipientAddressText.text;
    self.recipientPhoneNum=self.recipientPhoneText.text;
    self.recipientName=self.recipientNameText.text;
    AppDelegate * tmpApp=  [UIApplication sharedApplication].delegate;
    
    self.userAccount=tmpApp.userAccount;
    
    
    //支付渠道,测试用银联
    NSString * channel;
    channel =[NSString stringWithFormat:@"upmp"];
    NSURL* url = [NSURL URLWithString:kUrl];
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    
    NSLog(@"recipientName:%@",self.recipientName);
    NSLog(@"recipientAddress:%@",self.recipientAddress);
    NSLog(@"recipientPhoneNum:%@",self.recipientPhoneNum);
    
    
    NSDictionary* dict = @{
                           @"channel" : @"upmp",
                           @"amount"  : [NSString stringWithFormat:@"%f",self.buyCountOfCommodity*self.priceOfCommodity],
                           @"recipientName":self.recipientName,
                           @"recipientAddress":self.recipientAddress,
                           @"recipientPhoneNum":self.recipientPhoneNum,
                           @"userCount":self.userAccount,
                           @"shopID":self.shopId,
                           @"goodsID": self.goodsId,
                           @"goodsName": self.nameOfCommodity,
                           @"buyCount":[NSString stringWithFormat:@"%d",self.buyCountOfCommodity],
                           @"singlePrice":[NSString stringWithFormat:@"%f",self.priceOfCommodity]
                           };
   // NSLog(@"%@  %@",self.shopId,self.goodsId);
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSLog(@"***************%@",bodyData);
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [self showAlertWait];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [self hideAlert];
        
        if (httpResponse.statusCode != 200) {
            [self showAlertMessage:kErrorNet];
            return;
        }
        if (connectionError != nil) {
            NSLog(@"error = %@", connectionError);
            [self showAlertMessage:kErrorNet];
            return;
        }
        NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
       // NSLog(@"charge = %@", charge);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Pingpp createPayment:charge viewController:self appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                NSLog(@"completion block: %@", result);
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                } else {
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                }
                [self showAlertMessage:result];
            }];
         
        });
        
    }];

    
}


- (void)showAlertWait
{
    self.mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [self.mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(self.mAlert.frame.size.width / 2.0f - 15, self.mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [self.mAlert addSubview:aiv];
}

- (void)showAlertMessage:(NSString*)msg
{
    self.mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [self.mAlert show];
}
- (void)hideAlert
{
    if (self.mAlert != nil)
    {
        [self.mAlert dismissWithClickedButtonIndex:0 animated:YES];
        self.mAlert = nil;
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
