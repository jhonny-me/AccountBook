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

@end
