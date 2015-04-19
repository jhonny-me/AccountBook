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
    NSDictionary *dic = [[NSDictionary alloc]init];
    // 保证每个月份的value值不为nil
//    self.sortByMonthInArray =[NSMutableDictionary dictionaryWithDictionary: @{
//                            @"1月":dic,
//                            @"2月":dic,
//                            @"3月":dic,
//                            @"4月":dic,
//                            @"5月":dic,
//                            @"6月":dic,
//                            @"7月":dic,
//                            @"8月":dic,
//                            @"9月":dic,
//                            @"10月":dic,
//                            @"11月":dic,
//                            @"12月":dic
//                            }];
    [self loadDataBaseInformationStatistics];
    NSLog(@"%@",self.sortByMonthInArray);
}

- (void) loadDataBaseInformationStatistics{
    
    for (int i=1; i<13; i++) {
        NSString *predicateStr;
        NSMutableArray *_infoMonthlyArray;
        if (i<10) {
            
            predicateStr = [NSString stringWithFormat:@"2015-0%d*",i];
        }else{
            
            predicateStr = [NSString stringWithFormat:@"2015-%d*",i];
        }
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date like[cd] %@",predicateStr];
        [_infoMonthlyArray removeAllObjects];
        _infoMonthlyArray =[NSMutableArray arrayWithArray:[Information MR_fetchAllGroupedBy:nil withPredicate:predicate sortedBy:@"date" ascending:YES].fetchedObjects];
        NSDictionary *dic =[self getMonthlyDictionaryWithArray:_infoMonthlyArray];
        NSString *key = [NSString stringWithFormat:@"%d月",i];
        [self.sortByMonthInArray setObject:dic forKey:key];
    }
    if (self.sortByMonthInArray) {
        
    }
}

// 将每月的数组计算总支出与总收入并打包为字典传回
- (NSDictionary *)getMonthlyDictionaryWithArray:(NSMutableArray*)array{
    // 总收入
    float allIn = 0;
    // 总支出
    float allOut = 0;
    // 计算总收入支出
    for (Information *info in array) {
        if ([info.type isEqualToString:@"支出"]) {
            
            allOut += [info.amount floatValue];
        }else{
        
            allIn += [info.amount floatValue];
        }
    }
    // 打包数据
    NSDictionary *dic = @{
                          @"array":array,
                          @"allIn":[NSNumber numberWithFloat:allIn],
                          @"allOut":[NSNumber numberWithFloat:allOut]
                          };
    return dic;
}
@end
