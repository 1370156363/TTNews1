//
//  EditController.m
//  meiguan
//
//  Created by 西安云美 on 2017/9/5.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import "EditController.h"

@interface EditController ()

@end

@implementation EditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_titleStr;
    if ([_titleStr isEqualToString:@"昵称"])
    {
        self.descLab.text=@"请输入您的昵称";
    }
    else if ([_titleStr isEqualToString:@"签名"])
    {
        self.descLab.text=@"请输入您的签名";
    }
    [self setDoneBarButtonWithSelector:@selector(finishAction) andTitle:@"完成"];
}

-(void)finishAction
{
    if ([_titleStr isEqualToString:@"昵称"])
    {
        NSMutableDictionary *prms=[@{
                                     @"uid":[[OWTool Instance] getUid] ,
                                     @"nickname":self.descLab.text
                                     }mutableCopy];
        
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:NNetworkUpdateUserInfo withUserInfo:prms success:^(NSDictionary *message)
         {
             self.SendTextBlock(_field.text);
             [SVProgressHUD showSuccessWithStatus:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
             [self popViewController];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
    else if ([_titleStr isEqualToString:@"签名"]){
        NSMutableDictionary *prms=[@{
                                     @"uid":[[OWTool Instance] getUid] ,
                                     @"signstr":self.descLab.text
                                     }mutableCopy];
        
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkMySign withUserInfo:prms success:^(NSDictionary *message)
         {
             self.SendTextBlock(_field.text);
             [SVProgressHUD showSuccessWithStatus:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
             [self popViewController];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
    
    
}



@end
