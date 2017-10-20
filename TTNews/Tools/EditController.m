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
    self.SendTextBlock(_field.text);
    [self.navigationController popViewControllerAnimated:YES];
}



@end
