//
//  ZQMainVC.h
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQMainVC : UITableViewController
{

    __weak IBOutlet UILabel *_monthLb;
    __weak IBOutlet UILabel *_yearLb;
    __weak IBOutlet UILabel *_allInLb;
    __weak IBOutlet UILabel *_allOutLb;
}

@end
