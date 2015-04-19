//
//  LoanInfo.h
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/18.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LoanInfo : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) id photo;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * date;

@end
