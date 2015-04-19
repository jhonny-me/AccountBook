//
//  ZQMainVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQMainVC.h"
#import "ZQInformation.h"

@interface ZQMainVC ()

@end

@implementation ZQMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZQInformation *info = [ZQInformation Info];
    // 用count ＝＝0 来判断
//    if ([info.sortByMonthInArray objectForKey:@"2"] == nil) {
//        NSLog(@"ugghgdhsdsgdhsd");
//    }
//    if ([(NSArray*)[info.sortByMonthInArray objectForKey:@"2"] count] == 0) {
//        NSLog(@"yyyyyyy");
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
