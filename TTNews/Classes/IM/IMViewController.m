//
//  IMViewController.m
//  TTNews
//
//  Created by mac on 2017/11/4.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "IMViewController.h"
///
#import "ContactListViewController.h"

#import "ConversationListController.h"

@interface IMViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>
{
    UIPageViewController *_pageVC;

    NSMutableArray *_viewControllers;
}

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
    self.chatBtu.selected=YES;
    ///点击会话事件
    [self.chatBtu addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];


    self.contactsBtu=[[UIButton alloc] initWithFrame:CGRectMake( winsize.width/2, 64, winsize.width/2, 50)];
    [self.contactsBtu setTitle:@"通讯录" forState:UIControlStateNormal];
    [self.contactsBtu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contactsBtu setTitleColor:selectColor forState:UIControlStateSelected];
    self.contactsBtu.selected=NO;
    ///点击会话事件
    [self.contactsBtu addTarget:self action:@selector(contactsAction:) forControlEvents:UIControlEventTouchUpInside];
    //添加分页滚动视图控制器
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.view.frame = CGRectMake(0, 64+50, winsize.width, SCREEN_HEIGHT-64+50 );
        _pageVC.delegate = self;
        _pageVC.dataSource = self;

        _pageVC.view.backgroundColor=[UIColor yellowColor];
    }

    [self.view addSubview:self.chatBtu];
    [self.view addSubview:self.contactsBtu];
    [self.view addSubview:_pageVC.view];

//    if (!) {
//        <#statements#>
//    }

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
    if (sender.selected) {
        self.contactsBtu.selected=NO;
    }
    else
    {
        self.contactsBtu.selected=YES;
    }
}

///点击通讯录事件
- (void)contactsAction:(UIButton *)sender{
    NSLog(@"111223333");
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.chatBtu.selected=NO;
    }
    else{
        self.chatBtu.selected=YES;
    }
}


#pragma mark -
#pragma mark UIPageViewControllerDelegate&DataSource

//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
//
//    if (self.chatBtu.selected) {
//
//    }
//
//    UIViewController *vc;
//    if (_selectedIndex + 1 < _viewControllers.count) {
//        vc = _viewControllers[_selectedIndex + 1];
//        vc.view.bounds = pageViewController.view.bounds;
//    }
//    return vc;
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
//    UIViewController *vc;
//    if (_selectedIndex - 1 >= 0) {
//        vc = _viewControllers[_selectedIndex - 1];
//        vc.view.bounds = pageViewController.view.bounds;
//    }
//    return vc;
//}
//
//
//- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
//    _selectedIndex = [_viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
//    _segment.selectedIndex = _selectedIndex;
//    [self performSwitchDelegateMethod];
//}
//
//
//
//-(UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
//    return UIInterfaceOrientationPortrait;
//}



@end

