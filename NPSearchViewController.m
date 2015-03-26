//
//  NPSearchViewController.m
//  new position
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 NP. All rights reserved.
//
#import "NPShopListController.h"
#import "NPSearchViewController.h"

@interface NPSearchViewController ()

@end

@implementation NPSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [AFHTTPRequestOperationManager manager];
    
    self.manager.responseSerializer =[[AFCompoundResponseSerializer alloc]init];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame :  CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];

   
    
   
    
    self.navigationItem.titleView =self.searchBar;
    
  
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
    return [self.data count];
}
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    [self.data removeAllObjects];
//    [self.tableView reloadData];
//    
//}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(![searchText isEqual:@""])
    {
    NSDictionary *params=@{@"Shopname":searchText};
   
    
    [self.manager
     
     POST:@"http://1.newposition.sinaapp.com/search.php"
     
     parameters:params
     
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         
         NSData *responseData=[operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
         NSError *error;
         
         self.data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
         [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        // NSLog(@"%@",operation.responseString);
         NSLog(@"搜索获取服务器数据成功!");
     }
     
     failure:
     
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"搜索获取服务器数据出错!");
         
     }];
    }

}
-(void)reloadData
{
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    UILabel *content=(UILabel *)[cell viewWithTag:1];
    NSDictionary *tmp=self.data[indexPath.row];
    
    content.text=[tmp valueForKey:@"Shopname"];
    
    // Configure the cell...
    
    return cell;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}
-(IBAction)disappearMode:(id)sender
{
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return 50;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NSDictionary *tmpDic=self.data[indexPath.row];
        NPShopListController *sec= [storyboard instantiateViewControllerWithIdentifier:@"shopListController"];
        //        sec.shopId=[tmpDic valueForKey:@"Shopid"];
        sec.shopId=[tmpDic valueForKey:@"Shopid"];
        [self.navigationController pushViewController:sec animated:YES];
   
    
    //消除cell选择痕迹
    [self performSelector:@selector(deselect) withObject:nil ];
}
- (void)deselect
{
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
