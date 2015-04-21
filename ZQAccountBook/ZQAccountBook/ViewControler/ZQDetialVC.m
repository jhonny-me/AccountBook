//
//  ZQDetialVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQDetialVC.h"
#import "CoreData+MagicalRecord.h"
#import "Information.h"
#import "ZQUtils.h"
#import "ZQDetailSectionRowCell.h"
#import "ZQInformation.h"
#import "ZQIncomeVC.h"
#import "ZQOutlayVC.h"

@interface ZQDetialVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    ZQInformation *_zqInfo;
    // 当月数组与统计字典
    NSDictionary *_currentMonthDic;
    // 当月数组
    NSArray *_currentMonthArray;
}

@end

@implementation ZQDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self loadZQDetialVCData];
//    [self loadZQDetialVCUI];
    _headYearLb.text = [ZQUtils getCurrentYearAndMonth];
}

- (void) loadZQDetialVCUI
{
    [self.tableView setTableHeaderView:_headerView];
    
    
    _headIncomeLb.text = [NSString stringWithFormat:@"%@",[_currentMonthDic objectForKey:@"allIn"]];
    _headOutlayLb.text = [NSString stringWithFormat:@"%@",[_currentMonthDic objectForKey:@"allOut"]];
    _headSurplusLb.text = [NSString stringWithFormat:@"%@",[_currentMonthDic objectForKey:@"allSurplus"]];
    
}

- (void) loadZQDetialVCData{
    
    _zqInfo = [ZQInformation Info];
    [_zqInfo loadDataBaseInformationStatisticsWithYear:[_headYearLb.text substringWithRange:NSMakeRange(0, 4)]];
    _currentMonthDic = [NSDictionary dictionaryWithDictionary:[_zqInfo.sortByMonthInArray objectForKey:[self getMonthKey]]];
    _currentMonthArray = [NSArray arrayWithArray:[_currentMonthDic objectForKey:@"array"]];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadZQDetialVCData];
    [self loadZQDetialVCUI];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView operation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _currentMonthArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ZQDetailSectionRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQDetailSectionRowCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZQDetailSectionRowCell" owner:nil options:nil] lastObject];
    }
   
    
    Information *tmpInfo = _currentMonthArray[indexPath.row];
    
    cell.dateLb.text = [[tmpInfo.date substringWithRange:NSMakeRange(8, 2)] stringByAppendingString:@"号"];
    cell.categoryLb.text = tmpInfo.category;
    
    if ([tmpInfo.type isEqualToString:@"支出"]) {
    
        cell.amountLb.textColor = [UIColor colorWithRed:33.0/255 green:146.0/255 blue:23.0/255 alpha:1];
        
        cell.amountLb.text = [NSString stringWithFormat:@"-%@",tmpInfo.amount];
    }else{
    
        cell.amountLb.textColor = [UIColor redColor];
        
        cell.amountLb.text = [NSString stringWithFormat:@"%@",tmpInfo.amount];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Information *info = _currentMonthArray[indexPath.row];
    
    if ([info.type isEqualToString:@"支出"]) {
        
        ZQOutlayVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZQOutlayVC"];
        vc.paramsInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        ZQIncomeVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZQIncomeVC"];
        vc.paramsInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    Information *info = _currentMonthArray[indexPath.row];
   // NSString *predicateStr = _dateTF.text;
    NSPredicate* searchTerm = [NSPredicate predicateWithFormat:@"self == %@",info];
    NSArray *findArray =[Information MR_findAllWithPredicate:(NSPredicate *)searchTerm];
    Information* foundInfo = [findArray firstObject];
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

#pragma mark - pickerView operation

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 10;
    }else{
        return 12;
    }
}

#pragma mark - Private methods

- (NSString *)getMonthKey{
    
    NSString *year = [_headYearLb.text substringWithRange:NSMakeRange(0, 5)];
//    NSString *monthKey = [[ZQUtils getCurrentYearAndMonth] stringByReplacingOccurrencesOfString:year withString:@""];
    NSString *monthKey = [_headYearLb.text stringByReplacingOccurrencesOfString:year withString:@""];
    return monthKey;
}

#pragma mark - Button Events

- (IBAction)monthChangeBtn_Pressed:(UIButton*)sender {
    
    NSString *oldMonth = [self getMonthKey];
    oldMonth = [oldMonth stringByReplacingOccurrencesOfString:@"月" withString:@""];
    NSString *year = [_headYearLb.text substringWithRange:NSMakeRange(0, 4)];
    int i = oldMonth.intValue;
    if (sender.tag == 881) {
        i--;
    }else{
        i++;
    }
    if (i==0) {
        i=12;
        year = [NSString stringWithFormat:@"%d年",([year integerValue]-1)];
    }else if (i==13){
        i=1;
        year = [NSString stringWithFormat:@"%d年",([year integerValue]+1)];
    }else{
        year = [year stringByAppendingString:@"年"];
    }
    NSString *newMonth = [NSString stringWithFormat:@"%d月",i];
    NSString *newYearAndMonth = [year stringByAppendingString:newMonth];
    _headYearLb.text = newYearAndMonth;
    [self viewWillAppear:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
