//
//  EditAddressController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "EditAddressController.h"
#import "YYLocationPickerView.h"


#define DETAILADDRESS @"详细地址"

@interface EditAddressController ()<UINavigationControllerDelegate,YYLocationPickerViewDelegate>
{
}
///@brief 收件人
@property (weak, nonatomic) IBOutlet UITextField *textFieldConsignee;
///@brief 电话
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
///@brief 地址
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress;
///@brief 详细地址
@property (weak, nonatomic) IBOutlet UITextView *textDetailAddress;
///@breif 地址视图
@property (weak, nonatomic) IBOutlet UIView *addressView;
@end

@implementation EditAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupview];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setupview{
    if (_addressName) {
        self.textFieldAddress.text = _addressName;
    }
    if (_phoneNum) {
        self.textFieldPhone.text = _phoneNum;
    }
    if (_ditailAddress) {
        self.textDetailAddress.text = _ditailAddress;
    }
    if (_receiveName) {
        self.textFieldConsignee.text = _receiveName;
    }
    else
        self.textDetailAddress.text = DETAILADDRESS;
    self.textDetailAddress.layer.cornerRadius = 10;
    self.textDetailAddress.layer.borderWidth = 0.5;
    self.textDetailAddress.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textDetailAddress.backgroundColor = [UIColor whiteColor];
    self.textDetailAddress.tag = 100;
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    
    //有内容时该设置才生效，需要切记
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 8;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor grayColor]};
    self.textDetailAddress.attributedText = [[NSAttributedString alloc]initWithString:self.textDetailAddress.text attributes:attributes];
    self.textDetailAddress.returnKeyType = UIReturnKeyDone;
    
    if(_ID == nil)
        self.title = @"添加新地址";
    else
        self.title = @"修改地址";
    [self setDoneBarButtonWithSelector:@selector(finishAction) andTitle:@"完成"];
    [self.view wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        DismissKeyboard;
    }];
    [self.addressView wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self addressClick];
    }];
    
}


-(void)finishAction{
    if ([self checkInput]) {
        NSArray *address = [self.textFieldAddress.text componentsSeparatedByString:@"-"];
        //省市区id
        NSInteger proID = [YYLocationPickerView GetAddressID:address[0]];
        NSInteger cityID = [YYLocationPickerView GetAddressID:address[1]];
        NSInteger disID = [YYLocationPickerView GetAddressID:address[2]];
        NSMutableDictionary *prms=[@{
                                     @"uid":[[OWTool Instance] getUid],
                                     @"consignee":self.textFieldConsignee.text,
                                     @"province":@(proID),
                                     @"city":@(cityID),
                                     @"district":@(disID),
                                     @"mobile":self.textFieldPhone.text,
                                     }mutableCopy];
        if (_ID) {
            [prms setObject:_ID forKey:@"id"];
        }
        if (![self.textDetailAddress.text isEqualToString:DETAILADDRESS]) {
            [prms setObject:self.textDetailAddress.text forKey:@"address"];
        }
        weakSelf(ws)
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetShopAddress withUserInfo:prms success:^(NSDictionary *message)
         {
             [SVProgressHUD showSuccessWithStatus:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
             ws.EditDoneReturnBlock();
             [ws popViewController];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }

}

-(bool)checkInput{
    
    if (self.textFieldConsignee.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写收件人"];
//        [SVProgressHUD dismissWithDelay:2.0f];
        return false;
    }
    else if (self.textFieldPhone.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写联系方式"];
        [SVProgressHUD dismissWithDelay:2.0f];
        return false;
    }
    else if (self.textFieldAddress.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择地址"];
        [SVProgressHUD dismissWithDelay:2.0f];
        return false;
    }
   
    return true;
}

-(void)addressClick{
    DismissKeyboard;
    YYLocationPickerView *location = [[YYLocationPickerView alloc] initWithLevel:YYLocationPickerViewLevelArea andDelegate:self];
    location.tag = 2;
    [location show];
}

#pragma mark TextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //编辑时删除代替placeholder效果的内容
    if ([textView.text isEqualToString:DETAILADDRESS] ) {
        textView.text = @"";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor whiteColor]};
        textView.attributedText = [[NSAttributedString alloc]initWithString:textView.text attributes:attributes];
    }
    
    return YES;
}

-(void)textViewEditChanged:(NSNotification *)obj{
    UITextView *textView = (UITextView *)obj.object;
    
    NSString *toBeString = textView.text;
    
    textView.text = toBeString;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //若编辑结束，内容为空，变最开始placeholder效果
    if ([textView.text isEqualToString:@""]) {
       self.textDetailAddress.text = DETAILADDRESS;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 8;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor grayColor]};
        self.textDetailAddress.attributedText = [[NSAttributedString alloc]initWithString:self.textDetailAddress.text attributes:attributes];
    }
}

- (BOOL) textView: (UITextView *) textView  shouldChangeTextInRange: (NSRange) range replacementText: (NSString *)text {
    if( [ @"\n" isEqualToString: text]){
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        return NO;
    }
    return YES;
}


#pragma mark - YYLocationPickViewDelegate
- (void)locationPickerView:(YYLocationPickerView *)locationPickerView didSelectedLocation:(NSString *)location locationID:(NSString *)locationID
{
    self.textFieldAddress.text = location;
}

@end
