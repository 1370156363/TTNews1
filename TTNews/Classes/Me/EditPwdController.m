//
//  EditPwdController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/5.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "EditPwdController.h"

@interface EditPwdController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldOldPwd;
@property (weak, nonatomic) IBOutlet UITextField *textfieldNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *textfieldConfirmPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation EditPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnSubmit.layer.cornerRadius = 5;
    _btnSubmit.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnSubmitClick:(id)sender {
    weakSelf(ws);
    if ([self checkPhoneInfo]){
        NSMutableDictionary *prms=[@{
                                     @"oldpassword":_textFieldOldPwd.text,
                                     @"password":_textfieldNewPwd.text,
                                     @"repassword":_textfieldConfirmPwd.text,
                                   }mutableCopy];
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:kNetWorkActionChangePassword withUserInfo:prms success:^(NSDictionary *message)
         {
             if ([message[@"status"] intValue]==1)
             {
                 [SVProgressHUD showSuccessWithStatus:message[@"message"]];
                 [ws popViewController];
             }
             else
             {
                 [SVProgressHUD showImage:nil status:message[@"message"]];
                 [SVProgressHUD dismissWithDelay:2];
             }
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
}
-(BOOL)checkPhoneInfo
{
    if (_textFieldOldPwd.text.length==0)
    {
        [SVProgressHUD showImage:nil status:@"请输入旧密码！"];
        return false;
    }
    if (_textfieldNewPwd.text.length==0)
    {
        [SVProgressHUD showImage:nil status:@"请输入新密码！"];
        return false;
    }
    if (![_textfieldNewPwd.text isEqualToString:_textfieldConfirmPwd.text])
    {
        [SVProgressHUD showImage:nil status:@"两次密码不一致！"];
        return false;
    }
    
    return true;
}


@end
