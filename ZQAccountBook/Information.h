//
//  Information.h
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/6.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Information : NSManagedObject

@property (nonatomic, retain) id photo;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * remark;

@end
