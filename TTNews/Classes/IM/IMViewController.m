//
//  IMViewController.m
//  TTNews
//
//  Created by mac on 2017/11/4.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "IMViewController.h"
///
//#import "ContactListViewController.h"


@interface IMViewController ()
///会话按钮
@property(nonatomic,strong)UIButton *chatBtu;
///通讯录
@property(nonatomic,strong)UIButton *contactsBtu;



@end

@implementation IMViewController

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    ///设置界面
    [self setSubLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{

}


#pragma mark 基本设置
- (void)setupBasic
{

    [self initNavigationWithImgAndTitle:@"添加好友" leftBtton:@"" rightButImg:[UIImage imageNamed:@"tianjia"] rightBut:nil navBackColor:navColor];
    [self.navigationItem.rightBarButtonItems[1] setAction:@selector(okAction)];

//    self.MainTabView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
}


#pragma mark 设置界面
///设置子界面
-(void)setSubLayout{
    self.chatBtu=[[UIButton alloc] initWithFrame:CGRectMake(0, 64, winsize.width/2, 50)];
    [self.chatBtu setTitle:@"会话" forState:UIControlStateNormal];
    [self.chatBtu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.chatBtu setTitleColor:selectColor forState:UIControlStateSelected];
    self.chatBtu.selected=NO;
    ///点击会话事件
    [self.chatBtu addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];


    self.contactsBtu=[[UIButton alloc] initWithFrame:CGRectMake( winsize.width/2, 64, winsize.width/2, 50)];
    [self.contactsBtu setTitle:@"通讯录" forState:UIControlStateNormal];
    [self.contactsBtu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contactsBtu setTitleColor:selectColor forState:UIControlStateSelected];
    self.contactsBtu.selected=NO;
    ///点击会话事件
    [self.contactsBtu addTarget:self action:@selector(contactsAction:) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:self.chatBtu];
    [self.view addSubview:self.contactsBtu];
}

#pragma mark 点击事件

///确定按钮
-(void)okAction{
    NSLog(@"111");
}

///点击会话事件
- (void)chatAction:(UIButton *)sender{
    NSLog(@"11122");
    sender.selected=!sender.selected;
}

///点击通讯录事件
- (void)contactsAction:(UIButton *)sender{
    NSLog(@"111223333");
    sender.selected=!sender.selected;
}


@end

