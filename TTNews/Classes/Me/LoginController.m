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
#import "TTTabBarController.h"
#import "TTConst.h"
#import <UMShare/UMShare.h>

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

@property (nonatomic,retain) NSString *CodeStr;


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
        pass.keyboardType = UIKeyboardTypeNumberPad;
        pass.secureTextEntry = NO;
        [btn1 setTitleColor:RGB(145, 207, 229) forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        phone.placeholder=@"请输入手机号码";
        pass.placeholder=@"请输入验证码";
        [btn3 setTitle:@"获取验证吗" forState:UIControlStateNormal];
    }
    else
    {
        isYzmLog=NO;
        pass.keyboardType = UIKeyboardTypeDefault;
        pass.secureTextEntry = YES;
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
        if (phone.text.length==0)
        {
            [SVProgressHUD showInfoWithStatus:@"请填写11位手机号！"];
            return ;
        }
        if (![phone.text wh_isMobileNumber])
        {
            [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码！"];
            return;
        }
        NSMutableDictionary *prms=[@{
                                     @"mobile":phone.text
                                     }mutableCopy];
        //获取验证码
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetWorkYzmAction withUserInfo:prms success:^(NSDictionary* message) {
            
            //NSDictionary *CodeDic = [message objectForKey:@"data"];
            self.CodeStr = ((NSNumber*)[message objectForKey:@"code"]).stringValue;
            [SVProgressHUD dismiss];
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
    if (![phone.text wh_isMobileNumber])
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号码！"];
        return;
    }
    if (isYzmLog)
    {if (pass.text.length==0||pass.text==nil)
        {
            [SVProgressHUD showInfoWithStatus:@"请输入验证码！"];
            return;
        }
        else if (![pass.text isEqualToString:self.CodeStr]){
            [SVProgressHUD showInfoWithStatus:@"验证码错误！"];
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
                 [ws loginWithUsername:phone.text password:pass.text];
                 NSDictionary *data = [message objectForKey:@"data"];
                 [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                 [[OWTool Instance] saveUid:data[@"uid"]];
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
    else
    {
        if (pass.text.length==0||pass.text==nil)
        {
            [SVProgressHUD showInfoWithStatus:@"请输入密码！"];
            return;
        }
        
        NSMutableDictionary *parms=[@{
                                      @"username":phone.text,
                                      @"password":pass.text
                                      }mutableCopy];
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:kNetWorkActionLogin withUserInfo:parms success:^(NSDictionary *message)
         {
             if ([message[@"message"] isEqualToString:@"登陆成功"])
             {
                 
                 [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                 [ws loginWithUsername:phone.text password:pass.text];
                 [[OWTool Instance] saveUid:message[@"uid"]];
                 [ws popToRootViewController];
             }
             else
             {
                 [SVProgressHUD showInfoWithStatus:message[@"message"]];
                 [SVProgressHUD dismissWithDelay:2];
             }
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
}

#pragma mark 环信登录
//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [SVProgressHUD showInfoWithStatus:@"登录中..."];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                //保存最近一次登录用户名
                [weakself saveLastLoginUsername];
                //发送自动登陆状态通知
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:[NSNumber numberWithBool:YES]];
                
            } else {
                
                switch (error.code)
                {
                    case EMErrorUserNotFound:
                        [self showAlertColTitle:@"提示" Message:@"用户不存在"];
                        break;
                    case EMErrorNetworkUnavailable:
                        [self showAlertColTitle:@"提示" Message:@"没有可用的网络"];
                        break;
                    case EMErrorServerNotReachable:
                        [self showAlertColTitle:@"提示" Message:@"服务器连接失败"];
                        break;
                    case EMErrorUserAuthenticationFailed:
                        [self showAlertColTitle:@"提示" Message:error.errorDescription];
                        break;
                    case EMErrorServerTimeout:
                        [self showAlertColTitle:@"提示" Message:@"连接超时"];
                        break;
                    case EMErrorServerServingForbidden:
                        [self showAlertColTitle:@"提示" Message:@"服务器异常"];
                        break;
                    case EMErrorUserLoginTooManyDevices:
                        [self showAlertColTitle:@"提示" Message:@"多设备登录"];
                        break;
                    default:
                        [self showAlertColTitle:@"提示" Message:@"登录失败"];
                        break;
                }
            }
        });
    });
}


#pragma  mark - private

- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}


#pragma mark 提示信息
/** 提示信息*/
-(void)showAlertColTitle:(NSString*)title Message:(NSString*)message{
    
    UIAlertController *alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * actionOK = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:nil];
    
    [alertCol addAction:actionOK];
    [self presentViewController:alertCol animated:YES completion:nil];
}

-(IBAction)OtherLogin:(UIButton *)sender
{
    NSInteger tag=sender.tag;
    if (tag==300)
    {
        //QQ
        //[self getUserInfoForPlatform:platformType];
    }
    else if (tag==400)
    {
        //微信
        [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
        
    }
    else if (tag==500)
    {
        //微博
        [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
        
        
    }
}

-(IBAction)ResignPass:(id)sender
{
    [self.navigationController pushViewController:[[ResignController alloc] init] animated:YES];
}



- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
}

@end
