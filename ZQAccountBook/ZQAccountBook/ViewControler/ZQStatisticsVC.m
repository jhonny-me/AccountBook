//
//  ZQStatisticsVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQStatisticsVC.h"
#import "PieChartView.h"
#import "ZQInformation.h"
#import "ZQUtils.h"
#import "CoreData+MagicalRecord.h"

#define PIE_HEIGHT 280

@interface ZQStatisticsVC ()<PieChartDelegate>
{
    ZQInformation *_zqInfo;
}
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *categoryArray;
@property (nonatomic,strong) NSMutableArray *valueArray2;
@property (nonatomic,strong) NSMutableArray *colorArray2;
@property (nonatomic,strong) NSMutableArray *categoryArray2;
@property (nonatomic,strong) PieChartView *pieChartView;
@property (nonatomic,strong) UIView *pieContainer;
@property (nonatomic)BOOL inOut;
@property (nonatomic,strong) UILabel *selLabel;
@end

@implementation ZQStatisticsVC

- (void)dealloc
{
    self.valueArray = nil;
    self.colorArray = nil;
    self.valueArray2 = nil;
    self.colorArray2 = nil;
    self.pieContainer = nil;
    self.selLabel = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadZQStatisticsVCData];
    
    self.inOut = YES;
    // 支出数组
    self.valueArray = [[NSMutableArray alloc] initWithObjects:
                       [NSNumber numberWithFloat:0],
                       [NSNumber numberWithFloat:0],
                       [NSNumber numberWithFloat:0],
                       [NSNumber numberWithFloat:0],
                       [NSNumber numberWithFloat:0],
                       [NSNumber numberWithFloat:0],
                       nil];
    // 收入数组
    self.valueArray2 = [[NSMutableArray alloc] initWithObjects:
                        [NSNumber numberWithFloat:0],
                        [NSNumber numberWithFloat:0],
                        [NSNumber numberWithFloat:0],
                        [NSNumber numberWithFloat:0],
                        nil];
    self.categoryArray2 = [[NSMutableArray alloc]initWithObjects:@"工资",@"兼职",@"理财收益",@"其他", nil];
    
    self.colorArray = [NSMutableArray arrayWithObjects:
                       [UIColor colorWithHue:((0/8)%20)/20.0+0.02 saturation:(0%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((1/8)%20)/20.0+0.02 saturation:(1%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((2/8)%20)/20.0+0.02 saturation:(2%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((3/8)%20)/20.0+0.02 saturation:(3%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((4/8)%20)/20.0+0.02 saturation:(4%8+3)/10.0 brightness:91/100.0 alpha:1],
                       [UIColor colorWithHue:((5/8)%20)/20.0+0.02 saturation:(5%8+3)/10.0 brightness:91/100.0 alpha:1],
                       nil];
    self.colorArray2 = [[NSMutableArray alloc] initWithObjects:
                        [UIColor purpleColor],
                        [UIColor orangeColor],
                        [UIColor magentaColor],
                        [UIColor redColor],
                        nil];
    self.categoryArray = [[NSMutableArray alloc]initWithObjects:@"服饰",@"餐饮",@"居家",@"交通",@"其他", nil];
    
    [self loadDBAndSortInArray];
    //add shadow img
    CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 100, PIE_HEIGHT, PIE_HEIGHT);
    
    UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + PIE_HEIGHT*0.92, shadowImg.size.width/2, shadowImg.size.height/2);
    [self.view addSubview:shadowImgView];
    
    self.pieContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.valueArray withColor:self.colorArray];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    float yearAllOut = [_zqInfo.sortByMonthInArray[@"支出总额"] floatValue];
    [self.pieChartView setTitleText:@"支出总计"];
    [self.pieChartView setAmountText:[NSString stringWithFormat:@"－%.2f",yearAllOut]];
    [self.view addSubview:self.pieContainer];
    
    //add selected view
    UIImageView *selView = [[UIImageView alloc]init];
    selView.image = [UIImage imageNamed:@"select.png"];
    selView.frame = CGRectMake((self.view.frame.size.width - selView.image.size.width/2)/2, self.pieContainer.frame.origin.y + self.pieContainer.frame.size.height, selView.image.size.width/2, selView.image.size.height/2);
    [self.view addSubview:selView];
    
    self.selLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, selView.image.size.width/2, 21)];
    self.selLabel.backgroundColor = [UIColor clearColor];
    self.selLabel.textAlignment = NSTextAlignmentCenter;
    self.selLabel.font = [UIFont systemFontOfSize:17];
    self.selLabel.textColor = [UIColor whiteColor];
    [selView addSubview:self.selLabel];
    [self.pieChartView setTitleText:@"支出总计"];
    self.title = @"对账单";
    self.view.backgroundColor = [self colorFromHexRGB:@"f3f3f3"];
    

}

- (void) loadZQStatisticsVCData{

    _zqInfo = [ZQInformation Info];
    [_zqInfo loadDataBaseInformationStatisticsWithYear:[[ZQUtils getCurrentYearAndMonth] substringWithRange:NSMakeRange(0, 4)]];
}

- (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    if (self.inOut) {
         self.selLabel.text = [NSString stringWithFormat:@"%@%2.2f%@",self.categoryArray[index],per*100,@"%"];
    }else{
        self.selLabel.text = [NSString stringWithFormat:@"%@%2.2f%@",self.categoryArray2[index],per*100,@"%"];
    }
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.pieContainer.bounds withValue:self.inOut?self.valueArray:self.valueArray2 withColor:self.inOut?self.colorArray:self.colorArray2];
    self.pieChartView.delegate = self;
    [self.pieContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    if (self.inOut) {
        float yearAllOut = [_zqInfo.sortByMonthInArray[@"支出总额"] floatValue];
        [self.pieChartView setTitleText:@"支出总计"];
        [self.pieChartView setAmountText:[NSString stringWithFormat:@"－%.2f",yearAllOut]];
        
    }else{
        float yearAllIn = [_zqInfo.sortByMonthInArray[@"收入总额"] floatValue];
        [self.pieChartView setTitleText:@"收入总计"];
        [self.pieChartView setAmountText:[NSString stringWithFormat:@"+%.2f",yearAllIn]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load statistics And sort in array

- (void) loadDBAndSortInArray{
    
    NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"type == '收入'"];
    NSArray *_allInfoArray2 = [Information MR_findAllSortedBy:@"date" ascending:YES withPredicate:predicate2];
    
    for (Information *info in _allInfoArray2) {
        int i = 0;
        if ([info.category isEqualToString:@"工资"]) {
            
            i = 0;
        }else if ([info.category isEqualToString:@"兼职"]){
        
            i = 1;
        }else if ([info.category isEqualToString:@"理财收益"]){
        
            i = 2;
        }else{// 其他
            
            i = 3;
        }
        float oldValue = [[self.valueArray2 objectAtIndex:i] floatValue];
        oldValue += [info.amount floatValue];
        self.valueArray2[i] = [NSNumber numberWithFloat:oldValue];
    }
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type == '支出'"];
    NSArray *_allInfoArray = [Information MR_findAllSortedBy:@"date" ascending:YES withPredicate:predicate];
   
    for (Information *info in _allInfoArray) {
        int i = 0;
        if ([info.category isEqualToString:@"服饰"]) {
            
            i = 0;
        }else if ([info.category isEqualToString:@"餐饮"]){
            
            i = 1;
        }else if ([info.category isEqualToString:@"居家"]){
            
            i = 2;
        }else if ([info.category isEqualToString:@"交通"]){
            
            i = 3;
        }else{// 其他
        
            i = 4;
        }
        float oldValue = [[self.valueArray objectAtIndex:i] floatValue];
        oldValue += [info.amount floatValue];
        self.valueArray[i] = [NSNumber numberWithFloat:oldValue];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableView data




@end
