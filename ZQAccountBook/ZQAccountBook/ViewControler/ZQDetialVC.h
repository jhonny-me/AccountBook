//
//  ZQDetialVC.h
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQDetialVC : UITableViewController
{
    // tableview head
    __weak IBOutlet UILabel *_headYearLb;
    __weak IBOutlet UILabel *_headSurplusLb;
    __weak IBOutlet UILabel *_headIncomeLb;
    __weak IBOutlet UILabel *_headOutlayLb;
    IBOutlet UITableViewCell *_detailHeaderCell;
}

@end
