//
//  ZQInformation.h
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/19.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Information.h"
#import "LoanInfo.h"
#import "ZQUtils.h"


@interface ZQInformation :Information
    
@property (nonatomic, strong) NSMutableDictionary *sortByMonthInArray;

@property (nonatomic, strong) NSMutableDictionary *sortByNameInArray;

+ (ZQInformation *)Info;

- (void) loadDataBaseInformationStatisticsWithYear:(NSString *)year;
- (void) loadDataBaseLoanInfoStatisticsWithYear:(NSString *)year;

@end
