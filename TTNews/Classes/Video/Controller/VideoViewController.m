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
#import "TTVideoFetchDataParameter.h"
#import "VideoTableViewCell.h"
#import "VideoPlayView.h"
#import "FullViewController.h"
#import "VideoCommentViewController.h"
#import "TTDataTool.h"
#import "TTConst.h"
#import "TTJudgeNetworking.h"
#import <DKNightVersion.h>

#import "VideoInfoViewController.h"


@interface VideoViewController ()<VideoTableViewCellDelegate, VideoPlayViewDelegate>


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


@end

static NSString * const VideoCell = @"VideoCell";

@implementation VideoViewController

#pragma mark -获取分类
-(void)getFenlei
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"1",@"display", nil];

    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetCategory withUserInfo:dict success:^(id message) {
        NSMutableArray *arr=message[@"data"];

        if (arr.count!=0) {

        }

        
    } failure:^(NSError *error) {

    } visibleHUD:YES];

}

#pragma mark -图片介绍

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///分类
    [self getFenlei];

    [self setupBasic];
    [self setupTableView];
    [self setupMJRefreshHeader];

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
-(void)setupBasic {
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    

    self.currentPage = 1;
    self.isFullScreenPlaying = NO;
}

#pragma mark 初始化TableView
- (void)setupTableView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:VideoCell];

}

#pragma mark 初始化刷新控件
- (void)setupMJRefreshHeader {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
}

-(void)loadData
{
    AFHTTPSessionManager *manager = [[KGNetworkManager sharedInstance] baseHtppRequest];
    
    NSString *urlStr = [[NSString stringWithFormat:@"%@/api/content/shipinlists/id/%@/page/%d",kNewWordBaseURLString,[[OWTool Instance] getUid],self.currentPage] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray  *_Nullable message)
     {
         NSMutableArray *newArr=[TTVideo mj_objectArrayWithKeyValuesArray:message];
         if (self.currentPage==1)
         {
            [self.videoArray removeAllObjects];
         }
         [self.videoArray addObjectsFromArray:newArr];
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}
#pragma mark 加载最新数据
- (void)LoadNewData
{
    self.currentPage=1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];
    });
}

#pragma mark 加载更多数据
- (void)LoadMoreData
{
    self.currentPage+=1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];
    });
}

#pragma mark - Table view data source
#pragma mark -UITableViewDataSource 返回tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -UITableViewDataSource 返回tableView每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}


#pragma mark -UITableViewDataSource 返回indexPath对应的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCell];
    cell.video = self.videoArray[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark -UITableViewDataSource 返回indexPath对应的cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTVideo *video = self.videoArray[indexPath.row];
//    return video.cellHeight;
    return 322;
}

#pragma mark -UITableViewDelegate 点击了某个cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self pushToVideoCommentViewControllerWithIndexPath:indexPath];
    VideoInfoViewController *info=[[VideoInfoViewController alloc] init];
    [self.navigationController pushViewController:info animated:YES];
    
}

#pragma mark 点击某个Cell或点击评论按钮跳转到评论页面
-(void)pushToVideoCommentViewControllerWithIndexPath:(NSIndexPath *)indexPath {
    VideoCommentViewController *vc = [[VideoCommentViewController alloc] init];
    vc.video = self.videoArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark VideoPlayViewDelegate 视频播放时窗口模式与全屏模式切换
- (void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    if (isFull) {
        self.isFullScreenPlaying = YES;
        [self presentViewController:self.fullVc animated:YES completion:^{
            self.playView.frame = self.fullVc.view.bounds;
            [self.fullVc.view addSubview:self.playView];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:YES completion:^{
            self.playView.frame = CGRectMake(0, 80, winsize.width, 200);
            [self.currentSelectedCell addSubview:self.playView];
            self.isFullScreenPlaying = NO;

        }];
        
    }
}

#pragma mark - 懒加载代码
- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        self.fullVc = [[FullViewController alloc] init];
    }
    
    return _fullVc;
}

#pragma mark VideoTableViewCell的代理方法
-(void)clickVideoButton:(NSIndexPath *)indexPath {
    [self.playView resetPlayView];

    VideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.currentSelectedCell = cell;
    VideoPlayView *playView = [VideoPlayView videoPlayView];
    TTVideo *video = self.videoArray[indexPath.row];
    playView.frame = CGRectMake(0, 80, winsize.width, 200);
    [cell addSubview:playView];
    cell.playView = playView;
    self.playView = playView;
    self.playView.delegate = self;
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,video.videourl]]];
    self.playView.playerItem = item;
}

#pragma mark VideoTableViewCell的代理方法
-(void)clickCommentButton:(NSIndexPath *)indexPath {
    [self pushToVideoCommentViewControllerWithIndexPath:indexPath];
}

-(NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

#pragma mark --UIScrollViewDelegate--scrollView滑动了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.playView.superview && self.isFullScreenPlaying == NO) {//点全屏和退出的时候，也会调用scrollViewDidScroll这个方法
        NSIndexPath *indePath = [self.tableView indexPathForCell:self.currentSelectedCell];
            if (![self.tableView.indexPathsForVisibleRows containsObject:indePath]) {//播放video的cell已离开屏幕
                [self.playView resetPlayView];
            }
    }

//    if (self.tableView.contentOffset.y>0) {
//        self.navigationController.navigationBar.alpha = 0;
//    } else {
//        CGFloat yValue = - self.tableView.contentOffset.y;//纵向的差距
//        CGFloat alphValue = yValue/self.tableView.contentInset.top;
//        self.navigationController.navigationBar.alpha =alphValue;
//    }
}
-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];
    
}

@end
