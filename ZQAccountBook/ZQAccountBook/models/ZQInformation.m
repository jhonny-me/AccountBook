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
    self.sortByNameInArray  = [[NSMutableDictionary alloc]init];
    
    // 获取当前年份
    NSString *currentYear = [[ZQUtils stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 4)];
    [self loadDataBaseInformationStatisticsWithYear:currentYear];
    [self loadDataBaseLoanInfoStatisticsWithYear:currentYear];
    NSLog(@"%@",self.sortByMonthInArray);
}

// 按年读取收入支出数据库并按月存

- (void) loadDataBaseInformationStatisticsWithYear:(NSString *)year{
    [self.sortByMonthInArray removeAllObjects];
    // 当年收入与支出总额
    float yearAllIn = 0;
    float yearAllOut = 0;
    
    for (int i=1; i<13; i++) {
        NSString *predicateStr;
        NSMutableArray *_infoMonthlyArray;
        NSString *preoperationStr;
        
        // 当月份为1-9月的时候在月份前要加上0来与数据库中的日期选项进行匹配，2015-05
        if (i<10) {
            
            preoperationStr = [NSString stringWithFormat:@"-0%d*",i];
        }else{
            
            preoperationStr = [NSString stringWithFormat:@"-%d*",i];
        }
        // 将年加上月
        predicateStr = [year stringByAppendingString:preoperationStr];
        
        // 设置筛选条件
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date like[cd] %@",predicateStr];
        // 清楚数组中的所有元素来接受新取到的数据
        [_infoMonthlyArray removeAllObjects];
        // 设置新的数据数组
        _infoMonthlyArray =[NSMutableArray arrayWithArray:[Information MR_fetchAllGroupedBy:nil withPredicate:predicate sortedBy:@"date" ascending:YES].fetchedObjects];
        // 调用自定义的封装方法，将当月的总支出总收入与总结余还有当月数组一起打包为一个字典返回,key值为月份
        NSDictionary *dic =[[self getMonthlyDictionaryWithArray:_infoMonthlyArray]mutableCopy];
        NSString *key = [NSString stringWithFormat:@"%d月",i];
        // 将月份数据字典添加到年份数组中
        [self.sortByMonthInArray setObject:dic forKey:key];
        
        // 设置当年总收入支出
        yearAllIn += [[dic objectForKey:@"allIn"] floatValue];
        yearAllOut += [[dic objectForKey:@"allOut"] floatValue];
    }
    
    // 将年总收入支出打包进当年字典
    [self.sortByMonthInArray setObject:[NSNumber numberWithFloat:yearAllIn] forKey:@"收入总额"];
    [self.sortByMonthInArray setObject:[NSNumber numberWithFloat:yearAllOut] forKey:@"支出总额"];
    // 调试用。
    if (self.sortByMonthInArray) {
        
    }
}

// 按年读取借贷数据库并按人名保存

- (void) loadDataBaseLoanInfoStatisticsWithYear:(NSString *)year{

    [self.sortByNameInArray removeAllObjects];
    // 当年应收与应付总额
    float yearAllShouldGive = 0;
    float yearAllShouldGet = 0;
    
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    // 借贷不需要按月份来保存，所以直接匹配年份
    NSString *pre = [year stringByAppendingString:@"*"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date like[cd] %@",pre];
    
    // 新建一个数组用来接收未按名字排序的数组
    NSMutableArray *needSortArray = [[NSMutableArray alloc]init];
    
    needSortArray = [NSMutableArray arrayWithArray:[LoanInfo MR_findAllSortedBy:@"name,date" ascending:YES withPredicate:predicate]];

    NSMutableArray *currentArray = [[NSMutableArray alloc]init];
    // 如果数据库中没有借贷信息。
    if (!needSortArray.count) {
        
        [self.sortByNameInArray setObject:nameArray forKey:@"nameArray"];
        self.sortByNameInArray[@"yearAllShouldGive"] = [NSNumber numberWithFloat:0];
        self.sortByNameInArray[@"yearAllShouldGet"] = [NSNumber numberWithFloat:0];
        
        return;
    }
    
#pragma mark - 根据名字来排序并且保存到字典
    // 获取第一个名字
    NSString *currentName = [(LoanInfo *)[needSortArray firstObject] name];
    // 将名字保存到名字数组，等读取完成后用来作为key值
    [nameArray addObject:currentName];
    
    // 遍历从数据库中取到的未按人名排序的数据
    for (LoanInfo *info in needSortArray) {
        // 如果现在读到的数据的名字与当前名字不相等，那么就保存并封装之前读到的数据
        if (![info.name isEqualToString:currentName]) {
            
            NSDictionary *dic = [[self getLoanMonthlyDictionaryWithArray:currentArray] mutableCopy];
            
            // 保存当前人的数据
            [self.sortByNameInArray setObject:dic forKey:currentName];
            
            // 年总应收与总应付
            yearAllShouldGet += [[dic objectForKey:@"allShouldGet"] floatValue];
            yearAllShouldGive += [[dic objectForKey:@"allShouldGive"] floatValue];

            // 清空当前保存当前人数据的数组，将现在读到的名字保存到姓名数组中
            [currentArray removeAllObjects];
            [nameArray addObject:info.name];
            
            currentName = [info.name mutableCopy];
        }
        // 如果名字与当前名字相等，那么就直接添加到此人的数据数组中
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

// 将每人的数组计算总应付与总应收并打包为字典传回
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
                          @"array":[array mutableCopy],
                          @"allShouldGet":[NSNumber numberWithFloat:allShouldGet],
                          @"allShouldGive":[NSNumber numberWithFloat:allShouldGive],
                          @"allSurplus":[NSNumber numberWithFloat:allSurplus]
                          };
    return dic;
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
                          @"array":[array mutableCopy],
                          @"allIn":[NSNumber numberWithFloat:allIn],
                          @"allOut":[NSNumber numberWithFloat:allOut],
                          @"allSurplus":[NSNumber numberWithFloat:allSurplus]
                          };
    return dic;
}
@end
