//
//  ZQMainVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQMainVC.h"
#import "ZQInformation.h"
#import "ZQUtils.h"

@interface ZQMainVC ()
{
    ZQInformation *_zqInfo;
}

@end

@implementation ZQMainVC

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self loadZQMainVCData];
//    [self loadZQMainVCUI];

}

- (void) loadZQMainVCData{

    _zqInfo = [ZQInformation Info];
}

- (void) loadZQMainVCUI{

    _allInLb.text = [NSString stringWithFormat:@"%@",[_zqInfo.sortByMonthInArray objectForKey:@"收入总额"]];
    _allOutLb.text = [NSString stringWithFormat:@"%@",[_zqInfo.sortByMonthInArray objectForKey:@"支出总额"]];
    
    NSString *date = [ZQUtils getCurrentYearAndMonth];
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [date stringByReplacingOccurrencesOfString:[year stringByAppendingString:@"年"] withString:@""];
    month = [month stringByReplacingOccurrencesOfString:@"月" withString:@""];
    year = [@" /" stringByAppendingString:year];
    _yearLb.text = year;
    _monthLb.text = month;
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadZQMainVCData];
    [self loadZQMainVCUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods


@end
