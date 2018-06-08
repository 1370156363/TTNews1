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
        [SVProgressHUD showErrorWithStatus:@"请填写11位手机号"];
        return ;
    }
    if (![userPhone.text wh_isMobileNumber])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    NSMutableDictionary *prms=[@{
                                 @"mobile":userPhone.text
                                 }mutableCopy];
    //获取验证码
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetWorkYzmAction withUserInfo:prms success:^(NSDictionary* message) {
        
        self.CodeStr = ((NSNumber*)[message objectForKey:@"code"]).stringValue;
        NSLog(@"%d",(long)self.CodeStr.intValue);
        [SVProgressHUD dismiss];
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
                                     @"email":@"no_email@163.com",
                                     @"verify":userEmail.text
                                     }mutableCopy];
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:kNetWorkActionRegister withUserInfo:prms success:^(NSDictionary *message)
         {
             
             if ([message[@"status"] intValue]==1)
             {
                 [self registerUser:userPhone.text Pass:userPass.text];
                 //[SVProgressHUD showSuccessWithStatus:@"注册成功!"];
                 
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:message[@"message"]];
                 [SVProgressHUD dismissWithDelay:2];
             }
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
}

//注册环信账号
//Registered account
- (void)registerUser:(NSString*)userName Pass:(NSString*)pass
{
    weakSelf(ws)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] registerWithUsername:userName password:pass];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                
                //                [self showAlertColTitle:@"提示" Message:@"注册成功，请登录"];
                [ws popViewController];
            }else{
                switch (error.code) {
                    case EMErrorServerNotReachable:
                        [self showAlertColTitle:@"提示" Message:@"连接服务器失败"];
                        break;
                    case EMErrorUserAlreadyExist:
                        [self showAlertColTitle:@"提示" Message:@"用户已存在"];
                        break;
                    case EMErrorNetworkUnavailable:
                        [self showAlertColTitle:@"提示" Message:@"无可用网络"];
                        break;
                    case EMErrorServerTimeout:
                        [self showAlertColTitle:@"提示" Message:@"连接超时"];
                        break;
                    case EMErrorServerServingForbidden:
                        [self showAlertColTitle:@"提示" Message:@"服务器异常"];
                    case EMErrorExceedServiceLimit:
                        [self showAlertColTitle:@"提示" Message:@"超过使用极限"];
                        break;
                    default:
                        [self showAlertColTitle:@"提示" Message:@"注册失败"];
                        break;
                }
            }
        });
    });
}

#pragma mark 提示信息
/** 提示信息*/
-(void)showAlertColTitle:(NSString*)title Message:(NSString*)message{
    
    UIAlertController *alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:nil];
    
    [alertCol addAction:actionOK];
    [self presentViewController:alertCol animated:YES completion:nil];
}

-(BOOL)checkPhoneInfo
{
    if (userPhone.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请填写11位手机号！"];
       return false;
    }
    if (![userPhone.text wh_isMobileNumber])
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码！"];
        return false;
    }
    
    if(userCode.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
        return false;
    }
    if (![userCode.text isEqualToString:_CodeStr]) {
        [SVProgressHUD showInfoWithStatus:@"验证码错误！"];
        return false;
    }
    if (userPass.text.length==0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入密码！"];
        return false;
    }
    if (![userPass.text isEqualToString:userPassConfim.text])
    {
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致！"];
        return false;
    }
    
//    if (![userEmail.text wh_isEmailAddress]) {
//        [SVProgressHUD showInfoWithStatus:@"请输入正确的邮箱！"];
//        return false;
//    }
    
    return true;
}


@end
