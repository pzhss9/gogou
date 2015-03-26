//
//  NPDetailBillController.m
//  haoshihui
//
//  Created by apple on 15-3-23.
//  Copyright (c) 2015年 NP. All rights reserved.
//

#import "NPDetailBillController.h"

@interface NPDetailBillController ()





@end

@implementation NPDetailBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.goodsNameText.text=[self.tmpDic valueForKey:@"Goodsname"];
    self.allPriceText.text=[NSString stringWithFormat:@"￥%@",[self.tmpDic valueForKey:@"Amount"] ];
    self.billNumberText.text=[self.tmpDic valueForKey:@"Dealnum"];
    self.billTimeText.text=[self.tmpDic valueForKey:@"DealTime"];
    self.nameText.text=[self.tmpDic valueForKey:@"Realname"];
    self.addressText.text=[self.tmpDic valueForKey:@"Address"];
    self.phoneText.text=[self.tmpDic valueForKey:@"Phonenum"];
    self.goodsCountText.text=[NSString stringWithFormat:@"x%@",[self.tmpDic valueForKey:@"Num"]];
    self.onePriceText.text=[NSString stringWithFormat:@"￥%.2f",[[self.tmpDic valueForKey:@"Unitprice"] doubleValue]/100];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
