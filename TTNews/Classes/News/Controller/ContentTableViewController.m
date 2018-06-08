//
//  ContentTableViewController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/26.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "ContentTableViewController.h"
#import "SinglePictureNewsTableViewCell.h"
#import "MultiPictureTableViewCell.h"
#import "DetailViewController.h"
#import "ShowMultiPictureViewController.h"
#import "TTConst.h"
#import <DKNightVersion.h>
#import <SDImageCache.h>
#import "SXNetworkTools.h"
#import "SXNewsEntity.h"
#import <MJExtension.h>
#import "TopTextTableViewCell.h"
#import "TopPictureTableViewCell.h"
#import "BigPictureTableViewCell.h"
#import <UIImageView+WebCache.h>

#import "VideoInfoViewController.h"
#import "VideoTableViewCell.h"

#import "NewsTableViewCell.h"
#import "NewsInfoViewController.h"
#import "TTVideo.h"

@interface ContentTableViewController ()



@property (nonatomic, strong) NSMutableArray *headerNewsArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *normalNewsArray;
@property (nonatomic, copy) NSString *currentSkinModel;
@property (nonatomic, strong) NSMutableArray *arrayList;
@property(nonatomic,assign)BOOL update;

@end

static NSString * const VideoCell = @"VideoCell";


@implementation ContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self setupRefresh];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.update == YES) {
        [self.tableView.mj_header beginRefreshing];
        self.update = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark --private Method--设置tableView
-(void)setupBasic {
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [UIView new];
    if (!self.arrayList) {
        self.arrayList=[[NSMutableArray alloc] init];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:VideoCell];
    [self.tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"NewsTableViewCellIdentify"];
}
#pragma mark --private Method--初始化刷新控件
-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    self.currentPage=1;
    [self loadDataForType];
}

- (void)loadMoreData
{
    self.currentPage++;
    [self loadDataForType];
}

- (void)loadDataForType
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"id":self.channelId,@"page":@(self.currentPage)}];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetWorkLanMuData withUserInfo:dict success:^(NSDictionary* message) {
        if(ws.currentPage==1){
            [ws.arrayList removeAllObjects];
        }
        
        NSArray *arrayM = [TTVideo mj_objectArrayWithKeyValuesArray:message];
        if (_currentPage == 1) {
            [ws.arrayList removeAllObjects];
        }
        [ws.arrayList addObjectsFromArray:arrayM];
        if ( arrayM == nil || arrayM.count==0) {
            [ws.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [ws.tableView reloadData];
            [ws.tableView.mj_footer endRefreshing];
        }
        [ws.tableView.mj_header endRefreshing];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error)
     {
     } visibleHUD:YES];

}

#pragma mark -UITableViewDataSource 返回tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -UITableViewDataSource 返回tableView每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTVideo *model=self.arrayList[indexPath.row];
    if ([model.model_id integerValue] != 6) {
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewsTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    }
    else
        return 322;
}

#pragma mark -UITableViewDataSource 返回indexPath对应的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TTVideo *video=self.arrayList[indexPath.row];

    if ([video.model_id integerValue]==6) {
        ///视频
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCell];
        cell.video = video;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
    else{
        NewsTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCellIdentify" forIndexPath:indexPath];
        cell.model = video;
        return cell;
    }
}

#pragma mark -UITableViewDelegate 点击了某个cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TTVideo *video=self.arrayList[indexPath.row];
    if ([video.model_id integerValue]==6) {
        VideoInfoViewController *info=[[VideoInfoViewController alloc] init];
        info.url=video.ID;
        info.video=video;
        [self.navigationController pushViewController:info animated:YES];
    }
    else{
        NewsInfoViewController *info=[[NewsInfoViewController alloc] init];
        info.url=video.ID;
        info.video=video;
        [self.navigationController pushViewController:info animated:YES];
    }
}

#pragma mark --private Method--点击了某一条新闻，调转到新闻对应的网页去
-(void)pushToDetailViewControllerWithUrl:(NSString *)url {
    DetailViewController *viewController = [[DetailViewController alloc] init];
    viewController.url = url;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark --懒加载--normalNewsArray
-(NSMutableArray *)normalNewsArray {
    if (!_normalNewsArray) {
        _normalNewsArray = [NSMutableArray array];
    }
    return _normalNewsArray;
}

#pragma mark --懒加载--headerNewsArray
-(NSMutableArray *)headerNewsArray {
    if (!_headerNewsArray) {
        _headerNewsArray = [NSMutableArray array];
    }
    return _headerNewsArray;
}
-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearMemory];
    
}
@end
