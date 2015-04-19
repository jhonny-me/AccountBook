//
//  ZQDetailSectionRowCell.h
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/19.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQDetailSectionRowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UILabel *categoryLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;

@end
