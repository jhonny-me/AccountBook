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
@synthesize sortByNameInArray;

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
    [self loadDataBaseLoanInfoStatisticsWithYear:currentYear];
    NSLog(@"%@",self.sortByMonthInArray);
}

// 按年读取收入支出数据库并按月存

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

// 按年读取借贷数据库并按人名保存

- (void) loadDataBaseLoanInfoStatisticsWithYear:(NSString *)year{

    // 当年应收与应付总额
    float yearAllShouldGive = 0;
    float yearAllShouldGet = 0;
    
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    NSString *pre = [year stringByAppendingString:@"*"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date like[cd] %@",pre];
    NSMutableArray *needSortArray = [[NSMutableArray alloc]init];
    
    needSortArray =[NSMutableArray arrayWithArray:[LoanInfo MR_fetchAllGroupedBy:@"name" withPredicate:predicate sortedBy:@"date" ascending:YES].fetchedObjects];
    
    NSMutableArray *currentArray = [[NSMutableArray alloc]init];
    // 如果数据库中没有借贷信息。
    if (!needSortArray.count) {
        
        [self.sortByNameInArray setObject:nameArray forKey:@"nameArray"];
        self.sortByNameInArray[@"yearAllShouldGive"] = [NSNumber numberWithFloat:0];
        self.sortByNameInArray[@"yearAllShouldGet"] = [NSNumber numberWithFloat:0];
        
        return;
    }
    NSString *currentName = [(LoanInfo *)[needSortArray firstObject] name];
    [nameArray addObject:currentName];
    
    for (LoanInfo *info in needSortArray) {
        if (![info.name isEqualToString:currentName]) {
            
            NSDictionary *dic = [[self getLoanMonthlyDictionaryWithArray:currentArray] mutableCopy];
            
            [self.sortByNameInArray setObject:dic forKey:currentName];
            
            yearAllShouldGet += [[dic objectForKey:@"allShouldGet"] floatValue];
            yearAllShouldGive += [[dic objectForKey:@"allShouldGive"] floatValue];

            [currentArray removeAllObjects];
            [nameArray addObject:info.name];
            
            currentName = [info.name mutableCopy];
        }
        
        [currentArray addObject:info];
    }
    // 存入最后一个借贷人数据数组
    NSDictionary *dic = [[self getLoanMonthlyDictionaryWithArray:currentArray] mutableCopy];
    [self.sortByNameInArray setObject:dic forKey:currentName];
    
    yearAllShouldGet += [[dic objectForKey:@"allShouldGet"] floatValue];
    yearAllShouldGive += [[dic objectForKey:@"allShouldGive"] floatValue];
    // 存入总应收应付数据
    [self.sortByNameInArray setValue:[NSNumber numberWithFloat:yearAllShouldGive] forKey:@"应付总额"];
    [self.sortByNameInArray setValue:[NSNumber numberWithFloat:yearAllShouldGet] forKey:@"应收总额"];
    // 存入人名数组
    self.sortByNameInArray[@"nameArray"] = [nameArray mutableCopy];

    if (self.sortByNameInArray) {
        
    }

}

// 将每月的数组计算总支出与总收入并打包为字典传回
- (NSDictionary *)getLoanMonthlyDictionaryWithArray:(NSMutableArray*)array{
    // 总应收
    float allShouldGet = 0;
    // 总应付
    float allShouldGive = 0;
    // 结余
    float allSurplus;
    // 计算总应付应收
    for (LoanInfo *info in array) {
        if ([info.type isEqualToString:@"应付账款"]) {
            
            allShouldGive += [info.amount floatValue];
        }else{
        
            allShouldGet += [info.amount floatValue];
        }
    }
    // 计算结余
    allSurplus = allShouldGet - allShouldGive;
    // 打包数据
    NSDictionary *dic = @{
                          @"array":array,
                          @"allShouldGet":[NSNumber numberWithFloat:allShouldGet],
                          @"allShouldGive":[NSNumber numberWithFloat:allShouldGive],
                          @"allSurplus":[NSNumber numberWithFloat:allSurplus]
                          };
    return dic;
}

// 将每人的数组计算总支出与总收入并打包为字典传回
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
