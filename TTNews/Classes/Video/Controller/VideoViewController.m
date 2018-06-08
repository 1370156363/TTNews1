//
//  VideoViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "VideoViewController.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import "TTVideo.h"
#import "VideoTableViewCell.h"
#import "VideoPlayView.h"
#import "FullViewController.h"
#import "VideoCommentViewController.h"
#import "TTConst.h"
#import <DKNightVersion.h>

#import "VideoInfoViewController.h"
#import "TTTopChannelContianerView.h"
#import "XLChannelControl.h"
//#import "ContentTableViewController.h"
////视屏内容
#import "VideoContentTableViewController.h"


@interface VideoViewController ()<TTTopChannelContianerViewDelegate,UIScrollViewDelegate>
{

    NSMutableArray *CategorySetArr;
}


///分类数据集
@property (nonatomic,strong)NSMutableArray *CategoryArr;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSString *maxtime;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) FullViewController *fullVc;
@property (nonatomic, weak) VideoPlayView *playView;
@property (nonatomic, weak) VideoTableViewCell *currentSelectedCell;
@property (nonatomic, copy) NSString *currentSkinModel;
@property (nonatomic, assign) BOOL isFullScreenPlaying;

@property (nonatomic, weak) TTTopChannelContianerView *topContianerView;

@property (nonatomic, weak) UIScrollView *contentScrollView;

@end

static NSString * const VideoCell = @"VideoCell";

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";


@implementation VideoViewController

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

#pragma mark -图片介绍

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.CategoryArr) {
        self.CategoryArr=[[NSMutableArray alloc] init];
    }
    if (!CategorySetArr) {
        CategorySetArr=[[NSMutableArray alloc] init];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;

    ///分类
    [self getFenlei];

    [self setupBasic];


}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.isFullScreenPlaying == NO) {//将要呈现的画面不是全屏播放页面
        [self.playView resetPlayView];
    }

//    self.navigationController.navigationBar.alpha = 1;

}



#pragma mark 基本设置
///创建上列表
-(void)setupTopContianerView{
    ///上面
//    [self.navigationController setNavigationBarHidden:YES];
    
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);

    TTTopChannelContianerView *topContianerView = [[TTTopChannelContianerView alloc] initWithFrame:CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, 30)];

    topContianerView.channelNameArray = self.CategoryArr;
    self.topContianerView  = topContianerView;
    topContianerView.delegate = self;

    [self.view addSubview:topContianerView];

    ///右边添加
    UIButton *addBtn=[[UIButton alloc] initWithFrame:CGRectMake(winsize.width-40,64, 40, 30)];

    [addBtn setImage:[UIImage imageNamed:@"tianjiaRZ"] forState:UIControlStateNormal];


    [self.view addSubview:addBtn];
    addBtn.backgroundColor=[UIColor whiteColor];
    [self.view bringSubviewToFront:addBtn];

    [addBtn addTarget:self action:@selector(AddChannelSelect) forControlEvents:UIControlEventTouchUpInside];

    ///创建子视图
    [self setupChildController];
     [self setupContentScrollView];
}

#pragma mark -接口
-(void)AddChannelSelect
{

    NSArray *arr1 = self.CategoryArr;
    
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:arr1 unUseTitles:nil finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        NSLog(@"inUseTitles = %@",inUseTitles);
        self.CategoryArr = [[NSMutableArray alloc] initWithArray:inUseTitles];
        self.topContianerView.channelNameArray = self.CategoryArr;
        for (NSInteger i = 0; i<self.CategoryArr.count; i++) {
            [CategorySetArr enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.CategoryArr[i] isEqualToString:[obj objectForKey:@"title_show"]]) {
                    ((VideoContentTableViewController*)self.childViewControllers[i]).channelId = CategorySetArr[i][@"id"];
                    *stop = YES;
                }
            }];
            
        }
        NSLog(@"unUseTitles = %@",unUseTitles);
    }];

}

-(void)setupBasic {
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    self.currentPage = 1;
    self.isFullScreenPlaying = NO;
}

#pragma mark --private Method--初始化子控制器
-(void)setupChildController {
    ///频道书两
    for (NSInteger i = 0; i<self.CategoryArr.count; i++) {

        VideoContentTableViewController *viewController = [[VideoContentTableViewController alloc] initWithNibName:@"VideoContentTableViewController" bundle:nil];
        
        [CategorySetArr enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self.CategoryArr[i] isEqualToString:[obj objectForKey:@"title_show"]]) {
                viewController.channelId=CategorySetArr[i][@"id"];
                *stop = YES;
            }
        }];

        [self addChildViewController:viewController];
    }
}



-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearMemory];
    
}

#pragma mark --private Method--初始化相信新闻内容的scrollView
- (void)setupContentScrollView {

    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView = contentScrollView;
    contentScrollView.frame = self.view.bounds;
//    [contentScrollView setBackgroundColor:[UIColor blueColor]];

    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width* self.CategoryArr.count, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    contentScrollView.showsHorizontalScrollIndicator=NO;
    [self.view insertSubview:contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:contentScrollView];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        VideoContentTableViewController *vc = self.childViewControllers[index];
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


@end
