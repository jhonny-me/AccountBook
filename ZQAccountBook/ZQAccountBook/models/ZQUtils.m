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

+ (void)showAlert: (NSString*)message
{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle: @"ZQAccountBook" message: message delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
    [alertV show];
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+ (NSString *) stringFromDate:(NSDate*)fromDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *destString = [NSString stringWithString:[formatter stringFromDate:fromDate]];
    return destString;
}

@end
