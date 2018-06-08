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
        if(self.field.text.length == 0){
            [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
            return ;
        }
        NSMutableDictionary *prms=[@{
                                     @"uid":[[OWTool Instance] getUid] ,
                                     @"nickname":self.field.text
                                     }mutableCopy];
        
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:NNetworkUpdateUserInfo withUserInfo:prms success:^(NSDictionary *message)
         {
             self.SendTextBlock(_field.text);
             [SVProgressHUD showSuccessWithStatus:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
             [self popViewController];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
    else if ([_titleStr isEqualToString:@"签名"]){
        if(self.field.text.length == 0){
            [SVProgressHUD showInfoWithStatus:@"请输入签名"];
            return ;
        }
        NSMutableDictionary *prms=[@{
                                     @"uid":[[OWTool Instance] getUid] ,
                                     @"signstr":self.field.text
                                     }mutableCopy];
        
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkMySign withUserInfo:prms success:^(NSDictionary *message)
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
