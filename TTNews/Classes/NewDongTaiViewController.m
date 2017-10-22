//
//  NewDongTaiViewController.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "NewDongTaiViewController.h"

#import "DongtaiModel.h"

#import "DongTaiTableViewCell.h"

#import "ZhuanjiaController.h"

#import "tiwenController.h"
///详情
#import "DongTaiInfoViewController.h"


@interface NewDongTaiViewController ()<UITableViewDelegate,UITableViewDataSource>
{

}

- (IBAction)sendAction:(UIButton *)sender;
- (IBAction)IMAction:(UIButton *)sender;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray    *dataListArr;
@property (weak, nonatomic) IBOutlet UITableView *MainTabView;



@end

@implementation NewDongTaiViewController

#pragma mark -懒加载


#pragma mark -网络传输
- (void)getNewList
{
    AFHTTPSessionManager *manager = [[KGNetworkManager sharedInstance] baseHtppRequest];
    NSString *urlStr = [[NSString stringWithFormat:@"%@/%@/%d",kNewWordBaseURLString,@"api/content/dynamiclists/page",self.currentPage] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray  *_Nullable message)
     {
         NSMutableArray *newArr=[DongtaiModel mj_objectArrayWithKeyValuesArray:message];
         if (self.currentPage==1)
         {
             [self.dataListArr removeAllObjects];
         }
         [self.dataListArr addObjectsFromArray:newArr];

         if (newArr.count==0) {
             [self.MainTabView.mj_footer endRefreshingWithNoMoreData];
         }
         else{
             [self.MainTabView reloadData];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
    [self.MainTabView.mj_header endRefreshing];
    [self.MainTabView.mj_footer endRefreshing];

}

#pragma mark -界面
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getNewList];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.dataListArr) {
        self.dataListArr=[NSMutableArray array];
    }

    self.MainTabView.delegate=self;
    self.MainTabView.dataSource=self;

    [self setupBasic];
    [self setupRefresh];

    self.MainTabView.contentInset=UIEdgeInsetsMake(0, 0, 40, 0);

    // 注册
    [self.MainTabView registerNib:[UINib nibWithNibName:NSStringFromClass([DongTaiTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"dongtai"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 基本设置
- (void)setupBasic
{

    [self initNavigationWithImgAndTitle:@"动态" leftBtton:@"" rightButImg:[UIImage imageNamed:@"jiahaoyou"] rightBut:nil navBackColor:navColor];
    [self.navigationItem.rightBarButtonItems[1] setAction:@selector(okAction)];

}
-(void)setupRefresh {

    self.MainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.MainTabView.mj_header.automaticallyChangeAlpha = YES;
    [self.MainTabView.mj_header beginRefreshing];
    self.MainTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
}
#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    self.currentPage=1;
    [self getNewList];

}

- (void)loadMoreData
{
    self.currentPage+=1;
    [self getNewList];

}

#pragma mark - TableView DataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//每个section头部的标题－Header
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [NSString stringWithFormat:@"共有%lu辆车",(unsigned long)dataArr.count];
//}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //    view.tintColor = [UIColor blackColor];

    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {

    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId=@"dongtai";
    DongtaiModel *wenda=self.dataListArr[indexPath.section];

    DongTaiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    cell.comment=wenda;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DongtaiModel *wenda=self.dataListArr[indexPath.section];
    NSLog(@"点击的是%ld",(long)indexPath.row);
    DongTaiInfoViewController *tickInfo=[[DongTaiInfoViewController alloc] initWithNibName:@"DongTaiInfoViewController" bundle:nil];
    tickInfo.wenda=wenda;
    [self.navigationController pushViewController:tickInfo animated:YES];
}

#pragma mark
///确定添加关注
-(void)okAction{
    ZhuanjiaController *zhuanVc=[[ZhuanjiaController alloc] init];
    [self.navigationController pushViewController:zhuanVc animated:YES];
}

- (IBAction)sendAction:(UIButton *)sender {
    tiwenController *tiwen=[[tiwenController alloc] init];
    tiwen.type=DongTaiType;
    [self.navigationController pushViewController:tiwen animated:YES];
}

- (IBAction)IMAction:(UIButton *)sender {
    
}
@end
