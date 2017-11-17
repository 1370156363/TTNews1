//
//  PhoneVerifyController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/15.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "PhoneVerifyController.h"

@interface PhoneVerifyController ()
{
    NSString * CodeStr;
}

@end

@implementation PhoneVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)cheakUserInfo{
    if(_textPhone.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入手机号!"];
        [SVProgressHUD dismissWithDelay:2.0];
        return false;
    }
    else if(_textVerity.text.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请输入验证码!"];
        [SVProgressHUD dismissWithDelay:2.0];
        return false;
    }
    else if(![_textVerity.text isEqualToString:CodeStr]){
        [SVProgressHUD showInfoWithStatus:@"验证码错误!"];
        [SVProgressHUD dismissWithDelay:2.0];
        return false;
    }
    return true;
}
    
- (IBAction)btnVerityClick:(id)sender {
    NSMutableDictionary *prms=[@{
                                 @"mobile":_textPhone.text
                                 }mutableCopy];
    //获取验证码
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetWorkYzmAction withUserInfo:prms success:^(NSDictionary* message) {
        
        NSDictionary *CodeDic = [message objectForKey:@"data"];
        CodeStr = [CodeDic objectForKey:@"verify"];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error)
     {
     } visibleHUD:YES];
}
    
- (IBAction)btnApplyClick:(id)sender {
    if([self cheakUserInfo]){
        weakSelf(ws)
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KnetworkApplyApprove withUserInfo:self.prms success:^(NSDictionary *message)
         {
             [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
             
             [SVProgressHUD dismissWithDelay:2];
             [ws popToRootViewController];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
}
    

@end
