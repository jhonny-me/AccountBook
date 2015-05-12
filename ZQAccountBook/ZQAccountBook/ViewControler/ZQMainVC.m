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
// 界面第一次加载的时候会执行这个方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self loadZQMainVCData];
//    [self loadZQMainVCUI];

}

- (void) loadZQMainVCData{

    _zqInfo = [ZQInformation Info];
    [_zqInfo loadDataBaseInformationStatisticsWithYear:@"2015"];
}

- (void) loadZQMainVCUI{

    // 设置收入跟支出总额
    _allInLb.text = [NSString stringWithFormat:@"%@",[_zqInfo.sortByMonthInArray objectForKey:@"收入总额"]];
    _allOutLb.text = [NSString stringWithFormat:@"%@",[_zqInfo.sortByMonthInArray objectForKey:@"支出总额"]];

    // 设置年月
    NSString *date = [ZQUtils getCurrentYearAndMonth];
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [date stringByReplacingOccurrencesOfString:[year stringByAppendingString:@"年"] withString:@""];
    month = [month stringByReplacingOccurrencesOfString:@"月" withString:@""];
    year = [@" /" stringByAppendingString:year];
    _yearLb.text = year;
    _monthLb.text = month;
    
}

// 界面将要显示出来的时候执行的方法，包括第一次加载，和pop出来的时候
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadZQMainVCData];
    [self loadZQMainVCUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)chartBtn_Pressed:(id)sender {
    
    NSNumber* allIn = [_zqInfo.sortByMonthInArray objectForKey:@"收入总额"];
    NSNumber *allOut = [_zqInfo.sortByMonthInArray objectForKey:@"支出总额"];
    
    // 如果没有记账点击统计图会先提示
    if (allOut.floatValue == 0.0) {
        
        [ZQUtils showAlert:@"要统计，先记帐～～"];
        return;
    }
    [self performSegueWithIdentifier:@"SegueToStatisticsVC" sender:self];
}




#pragma mark - Private Methods


@end
