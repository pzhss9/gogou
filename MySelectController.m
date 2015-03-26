//
//  MySelectController.m
//  new position
//
//  Created by apple on 14-11-18.
//  Copyright (c) 2014年 NP. All rights reserved.
//
#import "NPDetailsPageController.h"
#import "MySelectController.h"
#import "UICustomLineLabel.h"
#import "AppDelegate.h"
@interface MySelectController ()

@end

@implementation MySelectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame :  CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    [self.editButtonItem setTitle:@"编辑"];
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    //修改nav返回键颜色
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255 green:0 blue:171.0/255 alpha:1];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    AppDelegate *tmpDelegate=[UIApplication sharedApplication].delegate;
    tmpDelegate.currentController =self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    NSArray *data=  [[NSUserDefaults standardUserDefaults] objectForKey:@"MySelectedGoods"];
  
    self.data=[data mutableCopy];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.data=nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectedCell" forIndexPath:indexPath];
    UIImageView *imgView=(UIImageView *)[cell viewWithTag:3];
    NSMutableArray *arry=[[NSMutableArray alloc]init];
       NSDictionary *tmp=self.data[indexPath.row];
    //NSLog(@"%@",self.data);

      //NSLog(@"12345   %@",tmp);
    [arry addObject:[tmp valueForKey:@"imgURL"] ];
    [arry addObject:imgView];
     if([tmp valueForKey:@"imgURL"] == NULL)
     {
         UIAlertView *alview=[[UIAlertView alloc]initWithTitle:@"error" message:@"图片地址为空" delegate:self cancelButtonTitle:@"OK!" otherButtonTitles: nil];
         [alview show];
     }
    
    else
    {
   [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:arry];
    }
  
    
    UILabel *title= (UILabel *)[cell viewWithTag:4];
    title.text=[tmp valueForKey:@"goodsName"];
    UILabel *detail=(UILabel *)[cell viewWithTag:1];
    detail.text=[tmp valueForKey:@"description"];
    UILabel *price=(UILabel *)[cell viewWithTag:2];
    price.text=[tmp valueForKey:@"realPrice"];
    UICustomLineLabel *oldPrice=(UICustomLineLabel *)[cell viewWithTag:5];
    oldPrice.text=[tmp valueForKey:@"oldPrice"];
    oldPrice.lineType=LineTypeMiddle;
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NPDetailsPageController *controller=[storyboard instantiateViewControllerWithIdentifier:@"detailPageController"];
    NSDictionary *tmp=self.data[indexPath.row];

        controller.shopId=[tmp valueForKey:@"shopId"];
        controller.goodsId=[tmp valueForKey:@"goodsId"];
//        controller.shopName=[tmp valueForKey:@"goodsName"];
//        
//        controller.goodDescription= [tmp valueForKey:@"detail"];
//               controller.realPrice=[tmp valueForKey:@"price"];
//       
//        controller.oldPrice=[tmp valueForKey:@"oldPrice"];
//                controller.imgURL=[tmp valueForKey:@"imgName"];
//       
//        controller.title=@"test";
    
       controller.button.hidden=YES;
        [self.navigationController pushViewController:controller animated:YES];
   

    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // Don't show the Back button while editing.
    [self.navigationItem setHidesBackButton:editing animated:YES];
    if (editing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        
    }else {//点击完成按钮
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        
    }
}
/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
       
        
        [self.data removeObjectAtIndex:[indexPath row]];  //删除数组里的数据
        
        
        [[NSUserDefaults standardUserDefaults]setObject:self.data forKey:@"MySelectedGoods"];
        
    
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
         return 100;
    
}
- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}/*
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
