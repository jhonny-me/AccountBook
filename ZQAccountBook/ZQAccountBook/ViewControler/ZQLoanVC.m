//
//  ZQLoanVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQLoanVC.h"
#import "LoanInfo.h"
#import "CoreData+MagicalRecord.h"
#import "ZQUtils.h"


NSString *loanAccounts[] = {@"现金",@"银行卡",@"支付宝",@"信用卡",@"其他"};

@interface ZQLoanVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet UITextField *_nameTF;
    __weak IBOutlet UITextField *_numberTF;
    
    __weak IBOutlet UILabel *_moneycolorLb;
    __weak IBOutlet UITextField *_accountTF;
    __weak IBOutlet UITextField *_dateTF;
    __weak IBOutlet UITextView *_remarkTextView;
    __weak IBOutlet UILabel *_hintLb;
    UIDatePicker *_datePicker;
    __weak IBOutlet UIButton *_cameraBtn;

    // tag
    __weak IBOutlet UIButton *_borrowBtn;  //借入
    __weak IBOutlet UIButton *_loanoutBtn; //借出
    __weak IBOutlet UIButton *_repayBtn;   //还债
    __weak IBOutlet UIButton *_collectBtn; //收债
    
    // 顶部button的数组
    NSMutableArray *_statusBtnArray;
    
    __weak IBOutlet UIButton *_deleteBtn;
    // 应收账款，应付账款
    NSString *_getOrGive;
    // 标识借入、借出、还债、收债
    NSString *_category;
}

@end

@implementation ZQLoanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self loadZQLoanVCData];
//    [self loadZQLoanVCUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadZQLoanVCData];
    [self loadZQLoanVCUI];
}


- (void) loadZQLoanVCUI{
    
    if (self.paramsInfo) {
        
        [self setLbStatusWithCategory:self.paramsInfo.category];
        
        _deleteBtn.hidden = NO;
        float amount = self.paramsInfo.amount.floatValue;
        if (amount < 0.0) {
            amount = 0 - amount;
        }
        _numberTF.text = [NSString stringWithFormat:@"%.2f",amount];
        _nameTF.text = self.paramsInfo.name;
        _accountTF.text = self.paramsInfo.account;
        _dateTF.text = self.paramsInfo.date;
        _remarkTextView.text = self.paramsInfo.remark;
        if (!self.paramsInfo.photo) {
            [_cameraBtn setImage:[UIImage imageNamed:@"camera_btn"] forState:UIControlStateNormal];
        }else{
            [_cameraBtn setImage:self.paramsInfo.photo forState:UIControlStateNormal];
        }
    }else{
    
    _category = @"借入";
    _getOrGive = @"应付账款";
    _dateTF.text = [ZQUtils stringFromDate:[NSDate date]];
    [self customizeKeyboards];
    }
}

- (void) loadZQLoanVCData{
    
    _borrowBtn.tag  = 1;
    _loanoutBtn.tag = 2;
    _repayBtn.tag   = 3;
    _collectBtn.tag = 4;
    _statusBtnArray = [NSMutableArray arrayWithObjects:_borrowBtn,_loanoutBtn,_repayBtn,_collectBtn, nil];
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
    
    // For Name
    
    UIBarButtonItem *nextBtn1 = [[UIBarButtonItem alloc] initWithTitle: @"下一项" style: UIBarButtonItemStyleDone target: self action: @selector(returnKey_Pressed:)];
    nextBtn1.tag = 1001;
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
    UIToolbar *toolBar1 = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    toolBar1.barStyle = UIBarStyleDefault;
    toolBar1.items = [NSArray arrayWithObjects: spaceItem1, nextBtn1, nil];
    _nameTF.inputAccessoryView = toolBar1;
    
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
    return loanAccounts[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"PickerView - DidSelectRow at %ld, %ld", (long)component, (long)row);
    
        
        _accountTF.text = loanAccounts[row];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}

#pragma mark - Private methods

- (void) setLbStatusWithCategory:(NSString*)category{
    
    int selectNumber = 0;
    if ([category isEqualToString:@"借入"]) {
        
        selectNumber =1;
    }else if([category isEqualToString:@"借出"]){
        
        selectNumber =2;
    }else if ([category isEqualToString:@"还债"]){
        
        selectNumber =3;
    }else if([category isEqualToString:@"收债"]){
        
        selectNumber =4;
    }
    
    for (int i=0;i<4;i++) {
        if (i+1 == selectNumber) {
        
            [_statusBtnArray[i] setBackgroundColor:[UIColor darkGrayColor]];
        }else{
        
            [_statusBtnArray[i] setBackgroundColor:[UIColor lightGrayColor]];
        }
    }

    switch (selectNumber) {
        case 1:
            
            _category = @"借入";
            _getOrGive = @"应付账款";
            _moneycolorLb.textColor = [UIColor colorWithRed:33.0/255 green:146.0/255 blue:23.0/255 alpha:1];
            _numberTF.textColor = [UIColor colorWithRed:33.0/255 green:146.0/255 blue:23.0/255 alpha:1];
            
            break;
        case 2:
            
            _category = @"借出";
            _getOrGive = @"应收帐款";
            _moneycolorLb.textColor = [UIColor redColor];
            _numberTF.textColor = [UIColor redColor];
            
            
            break;
        case 3:
            _category = @"还债";
            _getOrGive = @"应付账款";
            _moneycolorLb.textColor = [UIColor colorWithRed:33.0/255 green:146.0/255 blue:23.0/255 alpha:1];
            _numberTF.textColor = [UIColor colorWithRed:33.0/255 green:146.0/255 blue:23.0/255 alpha:1];
            
            break;
        case 4:
            
            _category = @"收债";
            _getOrGive = @"应收帐款";
            _moneycolorLb.textColor = [UIColor redColor];
            _numberTF.textColor = [UIColor redColor];
            
            break;
            
        default:
            break;
    }

}

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


#pragma mark - TextField events

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

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self takePicture:YES];
    }else if (buttonIndex == 1){
        [self takePicture:NO];
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



#pragma mark - Button events

- (IBAction)statusBtn_Pressed:(UIButton*)sender {

    [self setLbStatusWithCategory:sender.titleLabel.text];
}

- (IBAction)returnKey_Pressed:(UIBarButtonItem*)sender{
    if (sender.tag == 1000) {
        [_nameTF becomeFirstResponder];
    }else if (sender.tag == 1001) {
        
        //      [_categoryTF resignFirstResponder];
        [_accountTF becomeFirstResponder];
    }else if (sender.tag == 1002){
        
        //     [_accountTF resignFirstResponder];
        [_dateTF becomeFirstResponder];
    }else if (sender.tag == 1003){
        
        [_dateTF resignFirstResponder];
        
        _dateTF.text = [ZQUtils stringFromDate:[_datePicker date]];
    }else{
        
        [_remarkTextView resignFirstResponder];
    }
}
- (IBAction)cameraBtn_Pressed:(id)sender {
    
    UIActionSheet *cameraSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取", nil];
    [cameraSheet showInView:self.view];
}
- (IBAction)deleteBtn_Pressed:(id)sender {
    
    NSPredicate* searchTerm = [NSPredicate predicateWithFormat:@"self == %@",self.paramsInfo];
    NSArray *findArray =[LoanInfo MR_findAllWithPredicate:(NSPredicate *)searchTerm];
    LoanInfo* foundInfo = [findArray firstObject];
    [foundInfo MR_deleteEntity];
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
    if ([_nameTF.text isEqualToString:@""]) {
        [ZQUtils showAlert:@"请输入借贷人姓名！"];
        return;
    }
    float amount = _numberTF.text.floatValue;
    if ([_category isEqualToString:@"还债"] || [_category isEqualToString:@"借出"]) {
        amount = 0.0 - amount;
    }
    LoanInfo *info = [LoanInfo MR_createEntity];
    info.amount    = [NSNumber numberWithFloat:amount];
    info.photo     = _cameraBtn.imageView.image;
    info.category  = _category;
    info.account   = _accountTF.text;
    info.date      = _dateTF.text;
    info.remark    = _remarkTextView.text;
    info.name      = _nameTF.text;
    info.type      = _getOrGive;
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


@end
