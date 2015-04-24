//
//  ZQPeopleDetailVC.m
//  ZQAccountBook
//
//  Created by Mac OS X  on 15/4/24.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQPeopleDetailVC.h"
#import "ZQInformation.h"
#import "ZQDetailSectionRowCell.h"
#import "ZQLoanVC.h"

@interface ZQPeopleDetailVC ()
{
    ZQInformation *_zqInfo;
    NSArray *_infoArray;
    NSDictionary *_selectedDic;
}

@end

@implementation ZQPeopleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerYearTF.enabled = NO;
    [self.tableView setTableHeaderView:_headerView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) loadZQPeopleDetailVCUI
{
    
    _allShouldGetLb.text = [NSString stringWithFormat:@"%@",[_selectedDic objectForKey:@"allShouldGet"]];
    _allShouldGiveLb.text = [NSString stringWithFormat:@"%@",[_selectedDic objectForKey:@"allShouldGive"]];
    
    
}

- (void) loadZQPeopleNameVCData{
    _infoArray = [[NSArray alloc]init];
    _selectedDic = [[NSDictionary alloc]init];
    _zqInfo = [ZQInformation Info];
    
    [_zqInfo loadDataBaseLoanInfoStatisticsWithYear:[_headerYearTF.text substringWithRange:NSMakeRange(0, 4)]];
    
    _selectedDic = [_zqInfo.sortByNameInArray objectForKey:self.selectedName];
    _infoArray  = [_selectedDic objectForKey:@"array"];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadZQPeopleNameVCData];
    [self loadZQPeopleDetailVCUI];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQDetailSectionRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQDetailSectionRowCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZQDetailSectionRowCell" owner:nil options:nil] lastObject];
    }
    LoanInfo *info = _infoArray[indexPath.row];
    cell.dateLb.text = info.name;
    cell.categoryLb.text = info.category;
    // 设置字体颜色
    if ([info.type isEqualToString:@"应付账款"]) {
        
        cell.amountLb.textColor = [UIColor colorWithRed:33.0/255 green:146.0/255 blue:23.0/255 alpha:1];
        
    }else{
        
        cell.amountLb.textColor = [UIColor redColor];
    }
    cell.amountLb.text = [NSString stringWithFormat:@"%@",info.amount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LoanInfo *info = _infoArray[indexPath.row];
        
    ZQLoanVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZQLoanVC"];
    vc.paramsInfo = info;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - Button Events
- (IBAction)backYearBtn_Pressed:(id)sender {
}
- (IBAction)forwardYearBtn_Pressed:(id)sender {
}


/*

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
