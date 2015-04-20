//
//  ZQOutlayVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQOutlayVC.h"

#import "CoreData+MagicalRecord.h"
#import "ZQUtils.h"

NSString *outlayCategorys[] = {@"服饰",@"餐饮",@"居家",@"交通",@"其他"};

NSString *outlayAccounts[] = {@"现金",@"银行卡",@"支付宝",@"信用卡",@"其他"};

@interface ZQOutlayVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate>
{
    __weak IBOutlet UITextField *_categoryTF;
    __weak IBOutlet UITextField *_numberTF;
    
    __weak IBOutlet UITextField *_accountTF;
    __weak IBOutlet UITextField *_dateTF;
    __weak IBOutlet UITextView *_remarkTextView;
    __weak IBOutlet UILabel *_hintLb;
    UIDatePicker *_datePicker;
    __weak IBOutlet UIButton *_cameraBtn;
    __weak IBOutlet UIButton *_deleteBtn;
}


@end

@implementation ZQOutlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadZQOutlayVCUI];
}

- (void) loadZQOutlayVCUI
{
    if (self.paramsInfo) {
        
        if (!self.paramsInfo.photo) {
            [_cameraBtn setImage:[UIImage imageNamed:@"camera_btn"] forState:UIControlStateNormal];
        }else{
            [_cameraBtn setImage:self.paramsInfo.photo forState:UIControlStateNormal];
        }
        
        _numberTF.text = [NSString stringWithFormat:@"%@",self.paramsInfo.amount];
        _categoryTF.text = self.paramsInfo.category;
        _accountTF.text  = self.paramsInfo.account;
        _dateTF.text     = self.paramsInfo.date;
        _remarkTextView.text = self.paramsInfo.remark;
        
        _dateTF.enabled = NO;
        _dateTF.textColor = [UIColor lightGrayColor];
        
        _deleteBtn.hidden = NO;
    }else{

        _dateTF.text = [ZQUtils stringFromDate:[NSDate date]];
    }
    [self customizeKeyboards];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - customizeKeyboards

- (void) customizeKeyboards{
    // for number
    _numberTF.keyboardType = UIKeyboardTypeDecimalPad;
    _numberTF.delegate = self;
    
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle: @"下一项" style: UIBarButtonItemStyleDone target: self action: @selector(returnKey_Pressed:)];
    nextBtn.tag = 1000;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.items = [NSArray arrayWithObjects: spaceItem, nextBtn, nil];
    _numberTF.inputAccessoryView = toolBar;
    
    // For Category
    UIPickerView *categoryPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, 320, 216)];
    [categoryPicker setDelegate: self];
    [categoryPicker setDataSource: self];
    categoryPicker.tag = 991;
    _categoryTF.inputView = categoryPicker;
    
    UIBarButtonItem *nextBtn1 = [[UIBarButtonItem alloc] initWithTitle: @"下一项" style: UIBarButtonItemStyleDone target: self action: @selector(returnKey_Pressed:)];
    nextBtn1.tag = 1001;
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIToolbar *toolBar1 = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    toolBar1.barStyle = UIBarStyleDefault;
    toolBar1.items = [NSArray arrayWithObjects: spaceItem1, nextBtn1, nil];
    _categoryTF.inputAccessoryView = toolBar1;
    
    // For Account
    UIPickerView *accountPicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, 320, 216)];
    [accountPicker setDelegate: self];
    [accountPicker setDataSource: self];
    accountPicker.tag = 992;
    _accountTF.inputView = accountPicker;
    
    UIBarButtonItem *nextBtn2 = [[UIBarButtonItem alloc] initWithTitle: @"下一项" style: UIBarButtonItemStyleDone target: self action: @selector(returnKey_Pressed:)];
    nextBtn2.tag = 1002;
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIToolbar *toolBar2 = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    toolBar2.barStyle = UIBarStyleDefault;
    toolBar2.items = [NSArray arrayWithObjects: spaceItem2, nextBtn2, nil];
    _accountTF.inputAccessoryView = toolBar2;
    
    //for date
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    _datePicker.tag = 993;
    _dateTF.inputView = _datePicker;
    
    UIBarButtonItem *nextBtn3 = [[UIBarButtonItem alloc] initWithTitle: @"完成" style: UIBarButtonItemStyleDone target: self action: @selector(returnKey_Pressed:)];
    nextBtn3.tag = 1003;
    UIBarButtonItem *spaceItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIToolbar *toolBar3 = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    toolBar3.barStyle = UIBarStyleDefault;
    toolBar3.items = [NSArray arrayWithObjects: spaceItem3, nextBtn3, nil];
    _dateTF.inputAccessoryView = toolBar3;
    
    // for remark
    _remarkTextView.delegate = self;
    
    UIBarButtonItem *nextBtn4 = [[UIBarButtonItem alloc] initWithTitle: @"完成" style: UIBarButtonItemStyleDone target: self action: @selector(returnKey_Pressed:)];
    nextBtn4.tag = 1004;
    UIBarButtonItem *spaceItem4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIToolbar *toolBar4 = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    toolBar4.barStyle = UIBarStyleDefault;
    toolBar4.items = [NSArray arrayWithObjects: spaceItem4, nextBtn4, nil];
    _remarkTextView.inputAccessoryView = toolBar4;
    
}


#pragma mark - PickerView Delegate & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerView.tag == 991 ? outlayCategorys[row] : outlayAccounts[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"PickerView - DidSelectRow at %ld, %ld", (long)component, (long)row);
    
    if (pickerView.tag == 991) {
        
        _categoryTF.text = outlayCategorys[row];
    }
    else if (pickerView.tag == 992) {
        
        _accountTF.text = outlayAccounts[row];
    }else{
        
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
            
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private methods

- (void)takePicture: (BOOL)isCamera
{
    //    _selectedAvatarType = TIPRITEPHOTO;
    
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    
    if (isCamera) {
        
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            
            //            [MPUtils showAlert: @"Camera isn't available."];
            return;
        }
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController: picker animated: YES completion: nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [_cameraBtn setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - button events

- (IBAction)returnKey_Pressed:(UIBarButtonItem*)sender{
    if (sender.tag == 1000) {
        [_categoryTF becomeFirstResponder];
    }else if (sender.tag == 1001) {
        
        //      [_categoryTF resignFirstResponder];
        [_accountTF becomeFirstResponder];
    }else if (sender.tag == 1002){
        
        //如果是修改则到账户选择过后直接隐藏键盘
        if(self.paramsInfo){
            
            [_accountTF resignFirstResponder];
        }else{
            [_dateTF becomeFirstResponder];
        }
    }else if (sender.tag == 1003){
        
        [_dateTF resignFirstResponder];
        
        _dateTF.text = [ZQUtils stringFromDate:[_datePicker date]];
    }else{
        
        [_remarkTextView resignFirstResponder];
    }
}
- (IBAction)cameraBtn_Pressed:(id)sender {
    [self takePicture:YES];
}
- (IBAction)deleteBtn_Pressed:(id)sender {
    
    NSString *predicateStr = _dateTF.text;
    NSPredicate* searchTerm = [NSPredicate predicateWithFormat:@"date == %@",predicateStr];
    NSArray *findArray =[Information MR_findAllWithPredicate:(NSPredicate *)searchTerm];
    Information* info = [findArray firstObject];
    [info MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if(error)
        {
            [ZQUtils showAlert:[error localizedDescription]];
        }else{
            if (contextDidSave == YES) {
                
                [ZQUtils showAlert:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                
                [ZQUtils showAlert:@"删除失败，请重试"];
            }
        }
    }];

}

- (IBAction)saveBtn_Pressed:(id)sender {
    
    if (_numberTF.text.floatValue == 0.0) {
        // alart view
        [ZQUtils showAlert:@"请输入金额！！"];
        return;
    }
    
    // 判断是新增数据还是修改数据
    Information *info;
    if (self.paramsInfo) {
        NSString *predicateStr = _dateTF.text;
        NSPredicate* searchTerm = [NSPredicate predicateWithFormat:@"date == %@",predicateStr];
        NSArray *findArray =[Information MR_findAllWithPredicate:(NSPredicate *)searchTerm];
        info = [findArray firstObject];
        
    }else{
        
        info = [Information MR_createEntity];
    }
    info.amount    = [NSNumber numberWithFloat:_numberTF.text.floatValue];
    info.photo     = _cameraBtn.imageView.image;
    info.category  = _categoryTF.text;
    info.account   = _accountTF.text;
    info.date      = _dateTF.text;
    info.remark    = _remarkTextView.text;
//    info.name      = @"";
    info.type      = @"支出";
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if(error)
        {
            [ZQUtils showAlert:[error localizedDescription]];
        }else{
            if (contextDidSave == YES) {
                
                [ZQUtils showAlert:@"保存成功"];
            }else{
                
                [ZQUtils showAlert:@"保存失败，请重试"];
            }
        }
    }];
}

#pragma mark - textfield Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:_numberTF]) {
        _numberTF.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:_numberTF]) {
        if ([_numberTF.text isEqualToString:@""]) {
            _numberTF.text = @"0.00";
        }
    }
}

#pragma mark - textView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    _hintLb.hidden = YES;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    if ([textView.text isEqualToString:@""]) {
        _hintLb.hidden = NO;
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
