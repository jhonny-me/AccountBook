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

@interface ZQDetialVC ()
{
    NSMutableArray *_infoMonthlyArray;
    NSDictionary *_sortByMonthInArray;
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
    
    _infoMonthlyArray =[NSMutableArray arrayWithArray:[Information MR_findAllSortedBy:@"date" ascending:YES]];
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
    return _infoMonthlyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    Information *tmpInfo = _infoMonthlyArray[indexPath.row];
    cell.textLabel.text = [ZQUtils stringFromDate:tmpInfo.date];
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
