//
//  ZQPeopleNameVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/23.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQPeopleNameVC.h"
#import "ZQUtils.h"
#import "LoanInfo.h"
#import "ZQInformation.h"
#import "CoreData+MagicalRecord.h"
#import "ZQPeopleDetailVC.h"

@interface ZQPeopleNameVC ()
{

    ZQInformation *_zqInfo;
    NSArray *_nameArray;
}

@end

@implementation ZQPeopleNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headerYearTF.enabled = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) loadZQPeopleNameVCUI
{
    [self.tableView setTableHeaderView:_headView];
    
    
    _shouldGetLb.text = [NSString stringWithFormat:@"%@",[_zqInfo.sortByNameInArray objectForKey:@"应收总额"]];
    _shouldGiveLb.text = [NSString stringWithFormat:@"%@",[_zqInfo.sortByNameInArray objectForKey:@"应付总额"]];
    

}

- (void) loadZQPeopleNameVCData{
    
    _zqInfo = [ZQInformation Info];
    [_zqInfo loadDataBaseLoanInfoStatisticsWithYear:[_headerYearTF.text substringWithRange:NSMakeRange(0, 4)]];
    
    _nameArray = [[_zqInfo.sortByNameInArray objectForKey:@"nameArray"] mutableCopy];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadZQPeopleNameVCData];
    [self loadZQPeopleNameVCUI];
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
    return _nameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"nameCell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"profile_icon"];
    NSString *name= _nameArray[indexPath.row];
    cell.textLabel.text = name;
    NSDictionary *dic = [[_zqInfo.sortByNameInArray objectForKey:name] mutableCopy];
    
    if (dic[@"allSurplus"] < [NSNumber numberWithFloat:0]) {
        
        cell.detailTextLabel.textColor = [UIColor colorWithRed:33.0/255 green:146.0/255 blue:23.0/255 alpha:1];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"应付%@",dic[@"allSurplus"]];
    }else{
    
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"应收%@",dic[@"allSurplus"]];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZQPeopleDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZQPeopleDetailVC"];
    vc.selectedName = _nameArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *name = _nameArray[indexPath.row];
    // NSString *predicateStr = _dateTF.text;
    NSPredicate* searchTerm = [NSPredicate predicateWithFormat:@"name == %@",name];
    NSArray *findArray =[LoanInfo MR_findAllWithPredicate:(NSPredicate *)searchTerm];
    
    for (LoanInfo* info in findArray) {
        [info MR_deleteEntity];
    }
    
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
