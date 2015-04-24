//
//  ZQPeopleDetailVC.h
//  ZQAccountBook
//
//  Created by Mac OS X  on 15/4/24.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQPeopleDetailVC : UITableViewController
{
    IBOutlet UIView *_headerView;

    __weak IBOutlet UITextField *_headerYearTF;
    __weak IBOutlet UILabel *_allShouldGetLb;
    __weak IBOutlet UILabel *_allShouldGiveLb;
}

@property (nonatomic, strong) NSString * selectedName;

@end
