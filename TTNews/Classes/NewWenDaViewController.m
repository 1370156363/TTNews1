//
//  NewWenDaViewController.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "NewWenDaViewController.h"

#import "WendaModel.h"
#import "WenDaTableViewCell.h"
#import "WenDaInfoViewController.h"
#import "ZhuanjiaController.h"
#import "huidaController.h"
#import "TiWenViewController.h"
#import "LoginController.h"
#import "SearchQuestionResultCol.h"
#import "WenDaTableViewCell.h"

@interface NewWenDaViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    ///点击提问按钮是返回到该页面主动刷新一次数据
    BOOL shouldRefreshView;

}
///页面
@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray    *dataListArr;
@property (weak, nonatomic) IBOutlet UIView *headView;


@property (strong, nonatomic) IBOutlet UITableView *MainTabView;

//@property (weak, nonatomic) IBOutlet UIMainTabView *MainTabView;
@property (nonatomic,retain)UISearchBar *searchBar;


@end

@implementation NewWenDaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.dataListArr) {
        self.dataListArr=[NSMutableArray array];
    }
    [self setupBasic];

    self.MainTabView.delegate=self;
    self.MainTabView.dataSource=self;
    self.MainTabView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.MainTabView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.MainTabView registerClass:[WenDaTableViewCell class] forCellReuseIdentifier:@"WenDaTableViewCellIdentify"];
    
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
    [self.navigationItem setTitleView:rightSearch];
    
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupBasic {
    self.MainTabView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    self.currentPage = 1;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if(self.MainTabView.mj_header && shouldRefreshView){
        shouldRefreshView = NO;
        [self.MainTabView.mj_header beginRefreshing];
    }
}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    self.currentPage=1;
    [self loadList];

}

- (void)loadMoreData
{
    self.currentPage+=1;
    [self loadList];

}
///网络请求
-(void)loadList
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.currentPage],@"page", nil];
    WS(weakSelf)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkWenDaContent withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        if (weakSelf.currentPage==1)
        {
            [weakSelf.dataListArr removeAllObjects];
        }
        NSMutableArray *newArr=[WendaModel mj_objectArrayWithKeyValuesArray:message];
        [weakSelf.dataListArr addObjectsFromArray:newArr];
        if (newArr.count==0) {
            [weakSelf.MainTabView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [weakSelf.MainTabView reloadData];
            [weakSelf.MainTabView.mj_footer endRefreshing];
        }
        [weakSelf.MainTabView.mj_header endRefreshing];

    } failure:^(NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
     } visibleHUD:YES];
}

-(void)setupRefresh {

    self.MainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.MainTabView.mj_header beginRefreshing];
    self.MainTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
}

#pragma mark - TableView DataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}
//每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 14;
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
    WenDaTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WenDaTableViewCellIdentify" forIndexPath:indexPath];
    
    cell.wendaModel=self.dataListArr[indexPath.row];
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WendaModel *model = _dataListArr[indexPath.row];
    float height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"wendaModel" cellClass:[WenDaTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    NSLog(@"当前列表是%ld，高度是%.2f",(long)indexPath.row,height);
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WendaModel *wenda=self.dataListArr[indexPath.row];
    WenDaInfoViewController *tickInfo=[[WenDaInfoViewController alloc] initWithNibName:@"WenDaInfoViewController" bundle:nil];
    tickInfo.wenda=wenda;
    [self.navigationController pushViewController:tickInfo animated:YES];
}

///专家团
- (IBAction)zhuanjiaAction:(id)sender {
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
    else{
        ZhuanjiaController *zhuanVc=[[ZhuanjiaController alloc] init];
        [self.navigationController pushViewController:zhuanVc animated:YES];
    }
    
}
///回答
- (IBAction)wenDaAction:(UIButton *)sender {
    huidaController *tiwenVc=[[huidaController alloc] init];
    [self.navigationController pushViewController:tiwenVc animated:YES];
}
///提问
- (IBAction)tiWenAction:(UIButton *)sender {
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
    else{
        shouldRefreshView = YES;
        TiWenViewController *col = [[TiWenViewController alloc] init];
        [self.navigationController pushViewController:col animated:YES];
    }
    
}


-(void)searchBtnClick{
    //搜索
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入要搜索的问题" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        if ( searchText== nil || searchText.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入要搜索的问题"];
            [SVProgressHUD dismissWithDelay:1];
        }else{
            SearchQuestionResultCol *col = [[SearchQuestionResultCol alloc] init];
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



@end
