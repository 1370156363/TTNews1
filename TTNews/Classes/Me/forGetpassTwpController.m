//
//  forGetpassTwpController.m
//  TTNews
//
//  Created by 王迪 on 2017/9/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "forGetpassTwpController.h"

@interface forGetpassTwpController ()
{
    IBOutlet UILabel            *phoneNum;
    IBOutlet UITextField        *yzmField;
    IBOutlet UITextField        *passField;
    IBOutlet UITextField        *passFieldConfirm;
    IBOutlet UIView             *backView1;
    IBOutlet UIView             *backView2;
}

@property (nonatomic,strong)NSString   *CodeStr;

@end

@implementation forGetpassTwpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"找回密码";
    backView1.layer.cornerRadius=10;
    backView1.layer.borderWidth=1;
    backView1.layer.borderColor=RGB(220, 220, 220).CGColor;
    
    backView2.layer.cornerRadius=10;
    backView2.layer.borderWidth=1;
    backView2.layer.borderColor=RGB(220, 220, 220).CGColor;
    
    phoneNum.text = _phoneStr;
}


-(IBAction)getYzm:(id)sender
{
    
    NSMutableDictionary *prms=[@{
                                 @"mobile":_phoneStr,
                                 }mutableCopy];
    
    //获取验证码
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetWorkYzmAction withUserInfo:prms success:^(NSDictionary* message) {
        
        self.CodeStr = ((NSNumber*)[message objectForKey:@"code"]).stringValue;
        [SVProgressHUD dismiss];
    } failure:^(NSError *error)
     {
     } visibleHUD:YES];
}

-(IBAction)passWordCansee:(id)sender
{
    passField.secureTextEntry = !passField.secureTextEntry;
}

-(IBAction)Subbmit:(id)sender
{
    if (yzmField.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
        return;
    }
    else if (![yzmField.text isEqualToString:self.CodeStr]){
        [SVProgressHUD showInfoWithStatus:@"验证码错误！"];
        return;
    }
    else if (passField.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入密码！"];
        return;
    }
    else if (passFieldConfirm.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入确认密码！"];
        return;
    }
    else if (![passField.text isEqualToString:passFieldConfirm.text]){
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致！"];
        return;
    }
    
    NSMutableDictionary *prms=[@{
                                 @"username":_phoneStr,
                                 @"password":passField.text,
                                 @"verify":self.CodeStr
                                 }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetWorkResetPassword withUserInfo:prms success:^(NSDictionary *message)
     {
         if ([message[@"status"] intValue]==1)
         {
             [SVProgressHUD showSuccessWithStatus:message[@"message"]];
             [ws popToRootViewController];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

@end
