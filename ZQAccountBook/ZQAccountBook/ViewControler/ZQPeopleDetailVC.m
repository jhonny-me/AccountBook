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
#import "CoreData+MagicalRecord.h"

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
    if (!_infoArray.count) {
        _allShouldGiveLb.text = @"￥0.00";
        _allShouldGetLb.text  = @"￥0.00";
        return;
    }
    
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
    float amount = info.amount.floatValue;
    if (amount < 0.0) {
        amount = 0 - amount;
    }
    cell.amountLb.text = [NSString stringWithFormat:@"%.2f",amount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LoanInfo *info = _infoArray[indexPath.row];
        
    ZQLoanVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZQLoanVC"];
    vc.paramsInfo = info;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LoanInfo *info = _infoArray[indexPath.row];
    // NSString *predicateStr = _dateTF.text;
    NSPredicate* searchTerm = [NSPredicate predicateWithFormat:@"self == %@",info];
    NSArray *findArray =[LoanInfo MR_findAllWithPredicate:(NSPredicate *)searchTerm];
    LoanInfo* foundInfo = [findArray firstObject];
    [foundInfo MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if(error)
        {
            [ZQUtils showAlert:[error localizedDescription]];
        }else{
            if (contextDidSave == YES) {
                
                [ZQUtils showAlert:@"删除成功"];
                [self viewWillAppear:NO];
            }else{
                
                [ZQUtils showAlert:@"删除失败，请重试"];
            }
        }
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}



#pragma mark - Button Events

- (IBAction)yearChangeBtn_Pressed:(UIButton*)sender {
    
    int year = [[_headerYearTF.text stringByReplacingOccurrencesOfString:@"年 " withString:@""] integerValue];
    
    if (sender.tag == 601) {
        year--;
    }else{
        year++;
    }
    _headerYearTF.text = [NSString stringWithFormat:@"%d年",year];
    [self viewWillAppear:NO];
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
