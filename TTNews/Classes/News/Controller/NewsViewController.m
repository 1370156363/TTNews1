//
//  NewsViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "NewsViewController.h"
#import <POP.h>
#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import "ContentTableViewController.h"
#import "ChannelCollectionViewCell.h"
#import "TTConst.h"
#import "TTTopChannelContianerView.h"
#import "ChannelsSectionHeaderView.h"
#import "TTNormalNews.h"
#import <DKNightVersion.h>
#import "XLChannelControl.h"
#import "SearchResultControl.h"

@interface NewsViewController()<UIScrollViewDelegate,TTTopChannelContianerViewDelegate>
{

    NSMutableArray *CategorySetArr;
}

///分类数据集
@property (nonatomic,strong)NSMutableArray *CategoryArr;

@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, weak) TTTopChannelContianerView *topContianerView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *arrayLists;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";


@implementation NewsViewController


#pragma mark -获取分类
-(void)getFenlei
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"display", nil];

    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetCategory withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        CategorySetArr=message[@"data"];
        if (CategorySetArr.count!=0) {
            for (NSDictionary *dict in CategorySetArr) {
                [self.CategoryArr addObject:[dict objectForKey:@"title_show"]];
            }
            if (self.CategoryArr.count!=0) {
                [self setupTopContianerView];
            }
        }
    } failure:^(NSError *error) {

    } visibleHUD:YES];

}


- (NSArray *)arrayLists
{
    if (_arrayLists == nil) {
        _arrayLists = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"NewsURLs.plist" ofType:nil]];
    }
    return _arrayLists;
}

-(void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.isCellShouldShake = NO;

    if (!self.CategoryArr) {
        self.CategoryArr=[[NSMutableArray alloc] init];
    }
    if (!CategorySetArr) {
        CategorySetArr=[[NSMutableArray alloc] init];
    }
    [self getFenlei];
    
    [self addRightItemViews];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);



}

-(void)addRightItemViews
{
    
    //搜索
    UIButton *rightSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSearch.frame = CGRectMake(10, 50, SCREEN_WIDTH-100, 25);
    [rightSearch setImage:[UIImage imageNamed:@"ico-search"] forState:UIControlStateNormal];
    [rightSearch setTitle:@"搜索" forState:UIControlStateNormal];
    rightSearch.backgroundColor = [UIColor whiteColor];
    rightSearch.layer.cornerRadius = 5;
    
    [rightSearch.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightSearch setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [rightSearch setTintColor:[UIColor whiteColor]];
    [rightSearch addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithCustomView:rightSearch];
    [self.navigationItem setTitleView:rightSearch];
}

-(void)searchBtnClick{
    //搜索
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入搜索内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        if ( searchText== nil || searchText.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入内容"];
            [SVProgressHUD dismissWithDelay:1];
        }else{
            SearchResultControl *col = [[SearchResultControl alloc] init];
            col.searchStr = searchText;
            [searchViewController.navigationController pushViewController:col animated:YES];
        }
        
        
    }];
    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    nav.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    [nav.view setBackgroundColor:[UIColor lightGrayColor]];
    [self presentViewController:nav  animated:NO completion:nil];
}

-(void)AddChannelSelect
{
    ///搜索页面
    
    NSArray *arr1 = self.CategoryArr;//@[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"];

//    NSArray *arr2 = @[@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击",@"健康",@"摄影",@"生活",@"旅游",@"韩流",@"探索",@"综艺",@"美食",@"育儿"];

    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:arr1 unUseTitles:nil finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        NSLog(@"inUseTitles = %@",inUseTitles);
        self.CategoryArr = [[NSMutableArray alloc] initWithArray:inUseTitles];
        self.topContianerView.channelNameArray = self.CategoryArr;
        for (NSInteger i = 0; i<self.CategoryArr.count; i++) {
            [CategorySetArr enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.CategoryArr[i] isEqualToString:[obj objectForKey:@"title_show"]]) {
                    ((ContentTableViewController*)self.childViewControllers[i]).channelId = CategorySetArr[i][@"id"];
                    *stop = YES;
                }
            }];
            
        }
        NSLog(@"unUseTitles = %@",unUseTitles);
    }];

}

#pragma mark --private Method--初始化子控制器
-(void)setupChildController {

    for (NSInteger i = 0; i<self.CategoryArr.count; i++) {
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        [CategorySetArr enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.CategoryArr[i] isEqualToString:[obj objectForKey:@"title_show"]]) {
                viewController.channelId=CategorySetArr[i][@"id"];
                *stop = YES;
            }
        }];
        [self addChildViewController:viewController];
    }
}

#pragma mark --private Method--初始化上方的新闻频道选择的View
- (void)setupTopContianerView{

    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    TTTopChannelContianerView *topContianerView = [[TTTopChannelContianerView alloc] initWithFrame:CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, 30)];
    topContianerView.channelNameArray = self.CategoryArr;
    self.topContianerView  = topContianerView;

    topContianerView.delegate = self;
    [self.view addSubview:topContianerView];

    [self setupChildController];
    [self setupContentScrollView];
    //    [self setupCollectionView];

    ///右边添加
    UIButton *addBtn=[[UIButton alloc] initWithFrame:CGRectMake(winsize.width-40, 64, 40, 30)];

    [addBtn setImage:[UIImage imageNamed:@"tianjiaRZ"] forState:UIControlStateNormal];


    [self.view addSubview:addBtn];
    addBtn.backgroundColor=[UIColor whiteColor];
    [self.view bringSubviewToFront:addBtn];

    [addBtn addTarget:self action:@selector(AddChannelSelect) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark --private Method--初始化相信新闻内容的scrollView
- (void)setupContentScrollView {

    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView = contentScrollView;
    contentScrollView.frame = self.view.bounds;
    
    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    [self.view insertSubview:contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:contentScrollView];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        ContentTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        vc.tableView.contentInset = UIEdgeInsetsMake(self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:vc.view];
        for (int i = 0; i<self.contentScrollView.subviews.count; i++) {
            NSInteger currentIndex = vc.tableView.frame.origin.x/self.contentScrollView.frame.size.width;
            if ([self.contentScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                UITableView *theTableView = self.contentScrollView.subviews[i];
                NSInteger theIndex = theTableView.frame.origin.x/self.contentScrollView.frame.size.width;
                NSInteger gap = theIndex - currentIndex;
                if (gap<=2&&gap>=-2) {
                    continue;
                } else {
                    [theTableView removeFromSuperview];
                }
            }
            
        }
        
    }
}

#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [self.topContianerView selectChannelButtonWithIndex:index];
    }
}

#pragma mark --UICollectionViewDataSource-- 返回每个UICollectionViewCell发Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kMargin = 10;
    return CGSizeMake((kDeviceWidth - 5*kMargin)/4, 40);
}

#pragma mark --TTTopChannelContianerViewDelegate--选择了某个新闻频道，更新scrollView的contenOffset
- (void)chooseChannelWithIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
    
}

#pragma mark --private Method--存储更新后的currentChannelsArray到偏好设置中
-(NSMutableArray *)currentChannelsArray {

    if (!_currentChannelsArray) {
        if (!_currentChannelsArray) {
            _currentChannelsArray = [NSMutableArray arrayWithObjects:@"推荐",@"问答",@"要闻",@"直播",@"趣图",@"新闻",@"电影",@"科技", nil];
        }
    }
    return _currentChannelsArray;
}


@end

