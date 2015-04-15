//
//  ZQIncomeVC.m
//  ZQAccountBook
//
//  Created by jhonny.copper on 15/4/4.
//  Copyright (c) 2015年 jhonny. All rights reserved.
//

#import "ZQIncomeVC.h"

NSString *categorys[] = {@"工资",@"兼职",@"理财收益",@"其他"};

NSString *accounts[] = {@"现金",@"银行卡",@"支付宝",@"信用卡",@"其他"};

@interface ZQIncomeVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    __weak IBOutlet UITextField *_categoryTF;
    __weak IBOutlet UITextField *_numberTF;
    
    __weak IBOutlet UITextField *_accountTF;
    __weak IBOutlet UITextField *_dateTF;
    __weak IBOutlet UITextView *_remarkTextView;
    __weak IBOutlet UILabel *_hintLb;
    UIDatePicker *_datePicker;
    __weak IBOutlet UIButton *_cameraBtn;
}

@end

@implementation ZQIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadZQIncomeVCUI];
}

- (void) loadZQIncomeVCUI
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString * currentTime=[dateformatter stringFromDate:senddate];
    
    _dateTF.text = currentTime;
    
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
    return pickerView.tag == 991 ? 4 : 5;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerView.tag == 991 ? categorys[row] : accounts[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"PickerView - DidSelectRow at %ld, %ld", (long)component, (long)row);
    
    if (pickerView.tag == 991) {
        
        _categoryTF.text = categorys[row];
    }
    else if (pickerView.tag == 992) {
        
        _accountTF.text = accounts[row];
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
        
   //     [_accountTF resignFirstResponder];
        [_dateTF becomeFirstResponder];
    }else if (sender.tag == 1003){
        
        [_dateTF resignFirstResponder];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *selectTime = [NSString stringWithString:[formatter stringFromDate:[_datePicker date]]];
        
        _dateTF.text = selectTime;
    }else{
    
        [_remarkTextView resignFirstResponder];
    }
}
- (IBAction)cameraBtn_Pressed:(id)sender {
    [self takePicture:YES];
}

- (IBAction)saveBtn_Pressed:(id)sender {
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
