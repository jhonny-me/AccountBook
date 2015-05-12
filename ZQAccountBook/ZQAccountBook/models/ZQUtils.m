//
//  ZQUtils.m
//  ZQAccountBook
//
//  Created by Mac OS X  on 15/4/17.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQUtils.h"
#import <UIKit/UIKit.h>

@implementation ZQUtils

#pragma mark - Alert

// 显示一个提示框
+ (void)showAlert: (NSString*)message
{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle: @"ZQAccountBook" message: message delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
    [alertV show];
}

// 将string 类型的日期转换为nsdate
+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

// 将nsdate型的日期转换为string
+ (NSString *) stringFromDate:(NSDate*)fromDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *destString = [NSString stringWithString:[formatter stringFromDate:fromDate]];
    return destString;
}

// 获取当前年月，格式为 yyyy年MM月
+ (NSString *) getCurrentYearAndMonth{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM月"];
    NSString *monthString = [NSString stringWithString:[monthFormatter stringFromDate:date]];
    monthString = [monthString stringByReplacingOccurrencesOfString:@"0" withString:@""];
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc]init];
    [yearFormatter setDateFormat:@"yyyy年"];
    NSString *yearString = [NSString stringWithString:[yearFormatter stringFromDate:date]];
    NSString *destString = [yearString stringByAppendingString:monthString];
    return destString;
}
@end
