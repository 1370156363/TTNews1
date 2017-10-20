//
//  LoginController.m
//  TTNews
//
//  Created by 王迪 on 2017/9/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "LoginController.h"
#import "ResignController.h"
#import "forGetpassoneController.h"

@interface LoginController ()
{
    IBOutlet UIButton   *btn1;
    IBOutlet UIButton   *btn2;
    IBOutlet UIView     *view1;
    IBOutlet UIView     *view2;
    IBOutlet UITextField *phone;
    IBOutlet UITextField *pass;
    IBOutlet UIButton   *btn3;
    BOOL     isYzmLog;
}
@end

@implementation LoginController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"登录";
    view1.layer.borderColor=RGB(220, 220, 220).CGColor;
    view2.layer.borderColor=RGB(220, 220, 220).CGColor;
    isYzmLog=YES;
    [self.view wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        DismissKeyboard;
    }];
}

-(IBAction)LoginStateChange:(UIButton *)sender
{
    if (sender.tag==100)
    {
        isYzmLog=YES;
        [btn1 setTitleColor:RGB(145, 207, 229) forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        phone.placeholder=@"请输入手机号码";
        pass.placeholder=@"请输入验证码";
        [btn3 setTitle:@"获取验证吗" forState:UIControlStateNormal];
    }
    else
    {
        isYzmLog=NO;
        [btn1 setTitleColor:[UIColor darkGrayColor] forState:
         UIControlStateNormal];
        [btn2 setTitleColor:RGB(145, 207, 229) forState:UIControlStateNormal];
        phone.placeholder=@"请输入手机号码";
        pass.placeholder=@"请输入密码";
        [btn3 setTitle:@"忘记密码" forState:UIControlStateNormal];
    }
}

-(IBAction)Btn3Select:(id)sender
{
    if (isYzmLog)
    {
        
        //获取验证码
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetWorkYzmAction withUserInfo:nil success:^(id message) {
            
        } failure:^(NSError *error)
        {
            
        } visibleHUD:YES];
    }
    else
    {
        //forget Pass
        [self.navigationController pushViewController:[[forGetpassoneController alloc] init] animated:YES];
    }
}

-(IBAction)LogAction:(id)sender
{
    weakSelf(ws);
    [SVProgressHUD showWithStatus:@"发送中..."];
    if (isYzmLog)
    {
        if (![phone.text wh_isMobileNumber])
        {
            [SVProgressHUD showImage:nil status:@"请输入正确的手机号码"];
            return;
        }
        else if (pass.text.length==0||pass.text==nil)
        {
            [SVProgressHUD showImage:nil status:@"请输入验证码！"];
            return;
        }
        NSMutableDictionary *prms=[@{
                                     @"username":phone.text,
                                     @"verify":pass.text
                                     }mutableCopy];
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetWorkYzmLogin withUserInfo:prms success:^(NSDictionary *message)
         {
             if ([message[@"status"] intValue]==1)
             {
                 [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                 [ws popToRootViewController];
             }
             else
             {
                 [SVProgressHUD showImage:nil status:message[@"message"]];
                 [SVProgressHUD dismissWithDelay:2];
             }
         } failure:^(NSError *error) {
            
        } visibleHUD:NO];
    }
    else
    {
        if (![phone.text wh_isMobileNumber])
        {
            [SVProgressHUD showImage:nil status:@"请输入正确的手机号码"];
            return;
        }
        else if (pass.text.length==0||pass.text==nil)
        {
            [SVProgressHUD showImage:nil status:@"请输入密码！"];
            return;
        }
        
        NSMutableDictionary *parms=[@{
                                      @"username":@"1",
                                      @"password":@"1  "
                                      }mutableCopy];
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:kNetWorkActionLogin withUserInfo:parms success:^(NSDictionary *message)
         {
             if ([message[@"status"] intValue]==1)
             {
                 [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                 [ws popToRootViewController];
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

-(IBAction)OtherLogin:(UIButton *)sender
{
    NSInteger tag=sender.tag;
    if (tag==100)
    {
        
    }
    else if (tag==200)
    {
    
    }
    else if (tag==300)
    {
    
    }
}

-(IBAction)ResignPass:(id)sender
{
    [self.navigationController pushViewController:[[ResignController alloc] init] animated:YES];
}
@end
