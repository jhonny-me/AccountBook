//
//  ZQInformation.h
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/19.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Information.h"


@interface ZQInformation :Information
    
@property (nonatomic,strong) NSMutableDictionary *sortByMonthInArray;

+ (ZQInformation *)Info;

@end
