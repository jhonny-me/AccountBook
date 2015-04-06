//
//  ZQLoanVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQLoanVC.h"

@interface ZQLoanVC ()
{
    // tag
    __weak IBOutlet UIButton *_borrowBtn;  //借入
    __weak IBOutlet UIButton *_loanoutBtn; //借出
    __weak IBOutlet UIButton *_repayBtn;   //还债
    __weak IBOutlet UIButton *_collectBtn; //收债
    
    //
}

@end

@implementation ZQLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadZQLoanVCUI];
    [self loadZQLoanVCData];
}


- (void) loadZQLoanVCUI{
    _borrowBtn.tag  = 1;
    _loanoutBtn.tag = 2;
    _repayBtn.tag   = 3;
    _collectBtn.tag = 4;
}

- (void) loadZQLoanVCData{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
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
#pragma mark - TextField events

- (IBAction)returnKey_Pressed:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)beginEdit:(UITextField*)sender {
//    sender.text = @"";
    sender.textAlignment = UITextAlignmentLeft ;
}


#pragma mark - Button events
- (IBAction)statusBtn_Pressed:(UIButton*)sender {
    for (int i=1; i<5; i++) {
        UIButton *button = [self.view viewWithTag:i];
        if (i == sender.tag) {
            button.backgroundColor = [UIColor darkGrayColor];
        }
        else{
            button.backgroundColor = [UIColor lightGrayColor];
        }
    }
}

@end
