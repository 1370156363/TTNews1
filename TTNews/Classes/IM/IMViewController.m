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

///专家团
#import "ZhuanjiaController.h"

static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kMessageType = @"MessageType";


@interface IMViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>
{
    UIPageViewController *_pageVC;

    NSMutableArray *_viewControllers;
}

///会话按钮
@property(nonatomic,strong)UIButton *chatBtu;
///通讯录
@property(nonatomic,strong)UIButton *contactsBtu;
/**
 * 选中位置
 */
@property (nonatomic, assign) NSInteger selectedIndex;



@end

@implementation IMViewController

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    ///基本设置
    [self setupBasic];
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
    [self initNavigationWithImgAndTitle:@"添加好友" leftBtton:@"" rightButImg:[UIImage imageNamed:@"jiahaoyou"] rightBut:nil navBackColor:navColor];
    [self.navigationItem.rightBarButtonItems[1] setAction:@selector(okAction)];

//    self.MainTabView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
}


#pragma mark 设置界面
///设置子界面
-(void)setSubLayout{
    self.chatBtu=[[UIButton alloc] initWithFrame:CGRectMake(0, 64, winsize.width/2, 50)];
    [self.chatBtu setBackgroundColor:[UIColor whiteColor]];

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
    [self.contactsBtu setBackgroundColor:[UIColor whiteColor]];

    self.contactsBtu.selected=NO;
    ///点击会话事件
    [self.contactsBtu addTarget:self action:@selector(contactsAction:) forControlEvents:UIControlEventTouchUpInside];
    if (!_viewControllers) {
        _viewControllers=[[NSMutableArray alloc] init];
        ContactListViewController *contact=[[ContactListViewController alloc] init];
        
        ConversationListController *conver =[[ConversationListController alloc] init];
        [_viewControllers addObject:conver];
        [_viewControllers addObject:contact];
    }

    //添加分页滚动视图控制器
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.view.frame = CGRectMake(0, 64+50, winsize.width, SCREEN_HEIGHT-64+50 );
        _pageVC.delegate = self;
        _pageVC.dataSource = self;
        _pageVC.view.backgroundColor=HexRGB(0x666666);
        
        //设置ScrollView代理
        for (UIScrollView *scrollView in _pageVC.view.subviews) {
            if ([scrollView isKindOfClass:[UIScrollView class]]) {
                scrollView.delegate = self;
                scrollView.scrollEnabled=NO;
            }
        }
        ///第一个视图
        _selectedIndex=0;
        [self setSelectedIndex:0];
    }

    [self.view addSubview:self.chatBtu];
    [self.view addSubview:self.contactsBtu];
    [self.view addSubview:_pageVC.view];
    [self addChildViewController:_pageVC];

}


- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self switchToIndex:_selectedIndex];
}

#pragma mark 点击事件

///确定按钮
-(void)okAction{
    NSLog(@"111");
    ZhuanjiaController *zhuanjia=[[ZhuanjiaController alloc] init];
    [self.navigationController pushViewController:zhuanjia animated:YES];
    
}

///点击会话事件
- (void)chatAction:(UIButton *)sender{
    NSLog(@"11122");
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.contactsBtu.selected=NO;
        _selectedIndex=0;
        [self setSelectedIndex:0];
    }
    else
    {
        self.contactsBtu.selected=YES;
        _selectedIndex=1;
        [self setSelectedIndex:1];
    }
}

///点击通讯录事件
- (void)contactsAction:(UIButton *)sender{
//    NSLog(@"111223333");
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.chatBtu.selected=NO;
        _selectedIndex=1;
        [self setSelectedIndex:1];
    }
    else{
        self.chatBtu.selected=YES;
        _selectedIndex=0;
        [self setSelectedIndex:0];
    }
}

#pragma mark -
#pragma mark UIPageViewControllerDelegate&DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    UIViewController *vc;
    if (_selectedIndex + 1 < _viewControllers.count) {
        vc = _viewControllers[_selectedIndex + 1];
//        vc.navigationController=self.navigationController;
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    UIViewController *vc;
    if (_selectedIndex - 1 >= 0) {
        vc = _viewControllers[_selectedIndex - 1];
//        vc.navigationController=self.navigationController;
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    _selectedIndex = [_viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
//    _segment.selectedIndex = _selectedIndex;
    [self performSwitchDelegateMethod];

}

-(UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
    return UIInterfaceOrientationPortrait;
}

#pragma mark -
#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!scrollView.isDragging) {return;}
    if (scrollView.contentOffset.x == scrollView.bounds.size.width) {return;}
//    CGFloat progress = scrollView.contentOffset.x/scrollView.bounds.size.width;
//    _segment.progress = progress;

}

#pragma mark 其他方法

- (void)switchToIndex:(NSInteger)index {
    __weak __typeof(self)weekSelf = self;
    [_pageVC setViewControllers:@[_viewControllers[index]] direction:index<_selectedIndex animated:YES completion:^(BOOL finished) {
        _selectedIndex = index;
        [weekSelf performSwitchDelegateMethod];
    }];
}

//执行切换代理方法
- (void)performSwitchDelegateMethod {
    NSLog(@"切换到了第 -- %zd -- 个视图",_selectedIndex);
    if (_selectedIndex==0) {
        self.chatBtu.selected=YES;
        self.contactsBtu.selected=NO;
    }
    else{
        self.chatBtu.selected=NO;
        self.contactsBtu.selected=YES;
    }
}

@end

