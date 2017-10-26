//
//  ResignController.m
//  TTNews
//
//  Created by 王迪 on 2017/9/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ResignController.h"

@interface ResignController (){
    
    __weak IBOutlet UITextField *userCode;
    __weak IBOutlet UIButton *BtnRegister;
    __weak IBOutlet UITextField *userEmail;
    __weak IBOutlet UITextField *userPassConfim;
    __weak IBOutlet UITextField *userPass;
    __weak IBOutlet UITextField *userPhone;
}

@property (nonatomic,retain) NSString *CodeStr;

@end

@implementation ResignController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubViews];
    
    
}

-(void)initSubViews{
    self.title=@"注册";
    [self.view wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        DismissKeyboard;
    }];
    BtnRegister.layer.cornerRadius = 10;
}
- (IBAction)BtnCodeClick:(id)sender {
    
    if (userPhone.text.length==0)
    {
        [SVProgressHUD showImage:nil status:@"请填写11位手机号"];
        return ;
    }
    if (![userPhone.text wh_isMobileNumber])
    {
        [SVProgressHUD showImage:nil status:@"请输入正确的手机号码"];
        return;
    }
    NSMutableDictionary *prms=[@{
                                 @"mobile":userPhone.text
                                 }mutableCopy];
    //获取验证码
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetWorkYzmAction withUserInfo:prms success:^(NSDictionary* message) {
        
        NSDictionary *CodeDic = [message objectForKey:@"data"];
        self.CodeStr = [CodeDic objectForKey:@"verify"];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error)
     {
     } visibleHUD:YES];
}
- (IBAction)BtnRegisterClick:(id)sender {
    weakSelf(ws);
    if ([self checkPhoneInfo]){
        NSMutableDictionary *prms=[@{
                                     @"username":userPhone.text,
                                     @"password":userPass.text,
                                     @"repassword":userPassConfim.text,
                                     @"email":userEmail.text,
                                     @"verify":userEmail.text
                                     }mutableCopy];
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:kNetWorkActionRegister withUserInfo:prms success:^(NSDictionary *message)
         {
             if ([message[@"status"] intValue]==1)
             {
                 [SVProgressHUD showSuccessWithStatus:@"注册成功!"];
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
    if (userPhone.text.length==0)
    {
        [SVProgressHUD showImage:nil status:@"请填写11位手机号！"];
       return false;
    }
    if (![userPhone.text wh_isMobileNumber])
    {
        [SVProgressHUD showImage:nil status:@"请输入正确的手机号码！"];
        return false;
    }
    
    if(userCode.text.length == 0){
        [SVProgressHUD showImage:nil status:@"请输入验证码！"];
        return false;
    }
    if (![userCode.text isEqualToString:_CodeStr]) {
        [SVProgressHUD showImage:nil status:@"验证码错误！"];
        return false;
    }
    if (userPass.text.length==0)
    {
        [SVProgressHUD showImage:nil status:@"请输入密码！"];
        return false;
    }
    if (![userPass.text isEqualToString:userPassConfim.text])
    {
        [SVProgressHUD showImage:nil status:@"两次密码不一致！"];
        return false;
    }
    
    if (![userEmail.text wh_isEmailAddress]) {
        [SVProgressHUD showImage:nil status:@"请输入正确的邮箱！"];
        return false;
    }
    
    return true;
}


@end
