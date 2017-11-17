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
@property (nonatomic, assign) BOOL isShakeCanChangeSkin;


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
//    [self setupBasic];
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
    
    if (isYzmLog)
    {
        NSMutableDictionary *prms=[@{
                                     @"mobile":phone.text
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
                 //
                 [self loginWithUsername:phone.text password:@"123456"];
                 [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                 [[OWTool Instance] saveUid:message[@"uid"]];

                 if (self.type==1) {
                     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                     self.window.rootViewController=[[TTTabBarController alloc] init];
                     [self.window makeKeyAndVisible];
                 }
                 else{
                     self.LoginSuccessBlock();
                     [ws popToRootViewController];
                 }
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
                 [self loginWithUsername:phone.text password:@"123456"];
                 [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                 [[OWTool Instance] saveUid:message[@"uid"]];

                 if (self.type==1) {
                     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                     self.window.rootViewController=[[TTTabBarController alloc] init];
                     [self.window makeKeyAndVisible];
                 }
                 else{
                     self.LoginSuccessBlock();
                     [ws popToRootViewController];
                 }
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


#pragma  mark - private
//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    //    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:@"123456"];

        dispatch_async(dispatch_get_main_queue(), ^{
            //            [weakself hideHud];
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                //保存最近一次登录用户名
                [weakself saveLastLoginUsername];
                //发送自动登陆状态通知
            } else {
                switch (error.code)
                {
                    case EMErrorUserNotFound:
                    {
                        [self registUser:username password:password];
                    }
                        break;
                    case EMErrorNetworkUnavailable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerNotReachable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorUserAuthenticationFailed:
                        TTAlertNoTitle(error.errorDescription);
                        break;
                    case EMErrorServerTimeout:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    case EMErrorServerServingForbidden:
                        TTAlertNoTitle(NSLocalizedString(@"servingIsBanned", @"Serving is banned"));
                        break;
                    case EMErrorUserLoginTooManyDevices:
                        TTAlertNoTitle(NSLocalizedString(@"alert.multi.tooManyDevices", @"Login too many devices"));
                        break;
                    default:
                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                        break;
                }
            }
        });
    });
}


- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

///注册
-(void)registUser:(NSString *)username password:(NSString *)password{
    [[EMClient sharedClient] registerWithUsername:username password:@"123456" completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"注册成功");
            [self loginWithUsername:username password:password];
        }
    }];
}

-(void)setupBasic {

    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    self.isShakeCanChangeSkin = [[NSUserDefaults standardUserDefaults] boolForKey:IsShakeCanChangeSkinKey];
    [self.navigationController setTitle:@"登录"];
}

@end
