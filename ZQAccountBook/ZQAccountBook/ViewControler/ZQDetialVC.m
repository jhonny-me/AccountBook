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

@interface ZQDetialVC ()
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
}

- (void) loadZQDetialVCUI
{
    [self.tableView setTableHeaderView:_detailHeaderCell];
    
    _headYearLb.text = [ZQUtils getCurrentYearAndMonth];
    _headIncomeLb.text = [NSString stringWithFormat:@"%@",[_currentMonthDic objectForKey:@"allIn"]];
    _headOutlayLb.text = [NSString stringWithFormat:@"%@",[_currentMonthDic objectForKey:@"allOut"]];
    _headSurplusLb.text = [NSString stringWithFormat:@"%@",[_currentMonthDic objectForKey:@"allSurplus"]];
}

- (void) loadZQDetialVCData{
    
    _zqInfo = [ZQInformation Info];
    [_zqInfo loadDataBaseInformationStatistics];
    _currentMonthDic = [NSDictionary dictionaryWithDictionary:[_zqInfo.sortByMonthInArray objectForKey:[self getCurrentMonthKey]]];
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

#pragma mark - Private methods

- (NSString *)getCurrentMonthKey{
    
    NSString *year = [_headYearLb.text substringWithRange:NSMakeRange(0, 5)];
    NSString *monthKey = [[ZQUtils getCurrentYearAndMonth] stringByReplacingOccurrencesOfString:year withString:@""];
    return monthKey;
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
