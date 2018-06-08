//
//  huidaController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "huidaController.h"

#import "huidaController.h"
#import "WendaModel.h"
#import "WenDaInfoViewController.h"

#import "HuiDaTableViewCell.h"

@interface huidaController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *MainTabView;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray    *dataListArr;

@end

@implementation huidaController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationWithImgAndTitle:@"回答" leftBtton:nil rightButImg:nil rightBut:nil navBackColor:navColor];
    
    if (!self.dataListArr) {
        self.dataListArr=[NSMutableArray array];
    }
    self.MainTabView.delegate=self;
    self.MainTabView.dataSource=self;
    self.MainTabView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self.MainTabView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);

    ///下拉刷新
    [self setupRefresh];
    self.currentPage = 1;
}

-(void)setupRefresh {
    self.MainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [self.MainTabView.mj_header beginRefreshing];
    self.MainTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
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
    //获取验证码
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkWenDaContent withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        if (ws.currentPage==1)
        {
            [ws.dataListArr removeAllObjects];
        }
        NSMutableArray *newArr=[WendaModel mj_objectArrayWithKeyValuesArray:message];
        [ws.dataListArr addObjectsFromArray:newArr];
        if (newArr.count==0) {
            [ws.MainTabView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [ws.MainTabView reloadData];
        }
    } failure:^(NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
     } visibleHUD:YES];

    [self.MainTabView.mj_header endRefreshing];
    [self.MainTabView.mj_footer endRefreshing];
}

#pragma mark - TableView DataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataListArr.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
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
    NSString *cellId;
    WendaModel *wenda=self.dataListArr[indexPath.section];
    HuiDaTableViewCell *cell;
    cellId=@"content";
    cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    cell =[[NSBundle mainBundle] loadNibNamed:@"HuiDaTableViewCell" owner:self options:nil][0];
    cell.titleLab1.text=wenda.title;
    cell.numLab.text=[NSString stringWithFormat:@"已有%@个回答",wenda.answernum];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 112;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WendaModel *wenda=self.dataListArr[indexPath.section];
    NSLog(@"点击的是%ld",(long)indexPath.row);
    WenDaInfoViewController *tickInfo=[[WenDaInfoViewController alloc] initWithNibName:@"WenDaInfoViewController" bundle:nil];
    tickInfo.wenda=wenda;
    [self.navigationController pushViewController:tickInfo animated:YES];

}
@end
