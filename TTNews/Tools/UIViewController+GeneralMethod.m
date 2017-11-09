//
//  UIViewController+ViewControllerGeneralMethod.m
//  Golf
//
//  Created by Blankwonder on 6/4/13.
//  Copyright (c) 2013 Suixing Tech. All rights reserved.
//

#import "UIViewController+GeneralMethod.h"

@implementation UIViewController (GeneralMethod)

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)setBackBarButtonWithSelector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 13, 20, 20);
    [button setImage:[UIImage imageNamed:@"btn-fanhui-left"] forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setBackBarButtonWithTitleAndSelector:(SEL)selector andTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 45, 20);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setDoneBarButtonWithSelector:(SEL)selector andTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 24);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//导航栏右边按钮
- (void)setRightItemBarButtonWithSelector:(SEL)selector andImgName:(NSString *)img
{
    UIImage *searchimage=[UIImage imageNamed:img];
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:selector];
    [barbtn setImage:[searchimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.navigationItem.rightBarButtonItem=barbtn;
}


@end
