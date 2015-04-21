//
//  ZQInformation.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/19.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQInformation.h"
#import "CoreData+MagicalRecord.h"

static ZQInformation* zqInfomation;

@implementation ZQInformation

@synthesize sortByMonthInArray;

+ (ZQInformation *)Info{

    if (zqInfomation == nil) {
        zqInfomation = [[ZQInformation alloc]init];
    }
    return zqInfomation;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{

    self.sortByMonthInArray = [[NSMutableDictionary alloc]init];
    
    // 获取当前年份
    NSString *currentYear = [[ZQUtils stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 4)];
    [self loadDataBaseInformationStatisticsWithYear:currentYear];
    NSLog(@"%@",self.sortByMonthInArray);
}

- (void) loadDataBaseInformationStatisticsWithYear:(NSString *)year{
    // 当年收入与支出总额
    float yearAllIn = 0;
    float yearAllOut = 0;
    
    for (int i=1; i<13; i++) {
        NSString *predicateStr;
        NSMutableArray *_infoMonthlyArray;
        NSString *preoperationStr;
        if (i<10) {
            
            preoperationStr = [NSString stringWithFormat:@"-0%d*",i];
        }else{
            
            preoperationStr = [NSString stringWithFormat:@"-%d*",i];
        }
        predicateStr = [year stringByAppendingString:preoperationStr];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date like[cd] %@",predicateStr];
        [_infoMonthlyArray removeAllObjects];
        _infoMonthlyArray =[NSMutableArray arrayWithArray:[Information MR_fetchAllGroupedBy:nil withPredicate:predicate sortedBy:@"date" ascending:YES].fetchedObjects];
        NSDictionary *dic =[[self getMonthlyDictionaryWithArray:_infoMonthlyArray]mutableCopy];
        NSString *key = [NSString stringWithFormat:@"%d月",i];
        [self.sortByMonthInArray setObject:dic forKey:key];
        
        yearAllIn += [[dic objectForKey:@"allIn"] floatValue];
        yearAllOut += [[dic objectForKey:@"allOut"] floatValue];
    }
    
    [self.sortByMonthInArray setObject:[NSNumber numberWithFloat:yearAllIn] forKey:@"收入总额"];
    [self.sortByMonthInArray setObject:[NSNumber numberWithFloat:yearAllOut] forKey:@"支出总额"];
    if (self.sortByMonthInArray) {
        
    }
}

// 将每月的数组计算总支出与总收入并打包为字典传回
- (NSDictionary *)getMonthlyDictionaryWithArray:(NSMutableArray*)array{
    // 总收入
    float allIn = 0;
    // 总支出
    float allOut = 0;
    // 结余
    float allSurplus;
    // 计算总收入支出
    for (Information *info in array) {
        if ([info.type isEqualToString:@"支出"]) {
            
            allOut += [info.amount floatValue];
        }else{
        
            allIn += [info.amount floatValue];
        }
    }
    // 计算结余
    allSurplus = allIn - allOut;
    // 打包数据
    NSDictionary *dic = @{
                          @"array":array,
                          @"allIn":[NSNumber numberWithFloat:allIn],
                          @"allOut":[NSNumber numberWithFloat:allOut],
                          @"allSurplus":[NSNumber numberWithFloat:allSurplus]
                          };
    return dic;
}
@end
