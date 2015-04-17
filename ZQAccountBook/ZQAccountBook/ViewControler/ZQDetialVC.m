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

@interface ZQDetialVC ()
{
    NSMutableArray *_infoArray;
    
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
    
 
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_infoArray.count) {
        
        [_infoArray removeAllObjects];
    }
    
    _infoArray =[NSMutableArray arrayWithArray:[Information MR_findAll]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView operation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _infoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    Information *tmpInfo = _infoArray[indexPath.row];
    cell.textLabel.text = tmpInfo.category;
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
