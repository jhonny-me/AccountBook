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

@interface ZQDetialVC ()
{
   
    NSMutableDictionary *_sortByMonthInArray;
}

@end

@implementation ZQDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadZQDetialVCData];
    [self loadZQDetialVCUI];
}

- (void) loadZQDetialVCUI
{
    [self.tableView setTableHeaderView:_detailHeaderCell];
//    self.tableView.sectionHeaderHeight = 124.f ;
}

- (void) loadZQDetialVCData{
    
    _sortByMonthInArray = [[NSMutableDictionary alloc]init];
    for (int i=1; i<13; i++) {
        NSString *predicateStr;
        NSMutableArray *_infoMonthlyArray;
        if (i<10) {
            
            predicateStr = [NSString stringWithFormat:@"2015-0%d*",i];
        }else{
        
            predicateStr = [NSString stringWithFormat:@"2015-%d*",i];
        }
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date like[cd] %@",predicateStr];
        [_infoMonthlyArray removeAllObjects];
        _infoMonthlyArray =[NSMutableArray arrayWithArray:[Information MR_fetchAllGroupedBy:nil withPredicate:predicate sortedBy:@"date" ascending:YES].fetchedObjects];
        
        NSString *key = [NSString stringWithFormat:@"%d月",i];
        [_sortByMonthInArray setObject:[_infoMonthlyArray mutableCopy] forKey:key];
    }
    if (_sortByMonthInArray) {
        
    }
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView operation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *monthArray = [NSArray arrayWithArray:[_sortByMonthInArray objectForKey:@"4月"]];
    return monthArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    

    ZQDetailSectionRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQDetailSectionRowCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZQDetailSectionRowCell" owner:nil options:nil] lastObject];
    }
    NSArray *monthArray = [NSArray arrayWithArray:[_sortByMonthInArray objectForKey:@"4月"]];
    Information *tmpInfo = monthArray[indexPath.row];
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

#pragma mark - Private methods



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
