//
//  ZQUtils.h
//  ZQAccountBook
//
//  Created by Mac OS X  on 15/4/17.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQUtils : NSObject

#pragma mark - Alert

+ (void)showAlert: (NSString*)message;
+ (NSString *) stringFromDate:(NSDate*)fromDate;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *) getCurrentYearAndMonth;

@end
