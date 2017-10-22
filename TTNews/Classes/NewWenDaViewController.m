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
#import "tiwenController.h"
#import "ZhuanjiaController.h"
#import "huidaController.h"

#import "SearchInfoViewController.h"

@interface NewWenDaViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{


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

#pragma mark -搜索
// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
//    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    [searchBar setShowsCancelButton:YES animated:YES];
    SearchInfoViewController *search =[[SearchInfoViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    
}

#pragma mark -界面

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    [self loadList];

}

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
    self.MainTabView.contentInset=UIEdgeInsetsMake(0, 0, 40, 0);
    [self setupRefresh];

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 7, winsize.width-20, 30)];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarMetricsDefault;
    //找到取消按钮
    [_searchBar setTranslucent:YES];// 设置是否透明
    self.navigationItem.titleView=_searchBar;
    [_searchBar setBackgroundColor:navColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupBasic {
//    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
//    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithColors(navColor);
    self.navigationController.navigationBar.tintColor=navColor;

//    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
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
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkWenDaContent withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        if (self.currentPage==1)
        {
            [self.dataListArr removeAllObjects];
        }
        NSMutableArray *newArr=[WendaModel mj_objectArrayWithKeyValuesArray:message];
        [self.dataListArr addObjectsFromArray:newArr];
        if (newArr.count==0) {
            [self.MainTabView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self.MainTabView reloadData];
        }


    } failure:^(NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
     } visibleHUD:YES];

    [self.MainTabView.mj_header endRefreshing];
    [self.MainTabView.mj_footer endRefreshing];
}

-(void)setupRefresh {

    self.MainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.MainTabView.mj_header.automaticallyChangeAlpha = YES;
    [self.MainTabView.mj_header beginRefreshing];
    self.MainTabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    NSString *cellId;
    WendaModel *wenda=self.dataListArr[indexPath.row];
    WenDaTableViewCell *cell;
    NSArray *imags=[wenda.fengmian componentsSeparatedByString:@","];

    if (imags.count>1) {
        cellId=@"two";
        cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        cell =[[NSBundle mainBundle] loadNibNamed:@"WenDaTableViewCell" owner:self options:nil][1];
        cell.twotitleLab.text=wenda.title;

        [cell.imag1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,imags[0]]] placeholderImage:nil];
        [cell.img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,imags[1]]] placeholderImage:nil];
        
        cell.imag1.clipsToBounds  = YES;
        cell.img2.clipsToBounds  = YES;
        cell.twoCountLab.text=[NSString stringWithFormat:@"已有%@个问答",wenda.answernum];

    }
    else{
        cellId=@"one";
        cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        cell =[[NSBundle mainBundle] loadNibNamed:@"WenDaTableViewCell" owner:self options:nil][0];
        cell.oneTitleLab.text=wenda.title;

        if (imags.count!=0) {
            [cell.oneImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,imags[0]]] placeholderImage:nil];
        }
        cell.countLab.text=[NSString stringWithFormat:@"已有%@个问答",wenda.answernum];

    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WendaModel *wenda=self.dataListArr[indexPath.row];
    NSArray *imags=[wenda.fengmian componentsSeparatedByString:@","];

    if (imags.count>1) {
        return 330;
    }
    else{
        return 175;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WendaModel *wenda=self.dataListArr[indexPath.row];
    NSLog(@"点击的是%ld",(long)indexPath.row);
    WenDaInfoViewController *tickInfo=[[WenDaInfoViewController alloc] initWithNibName:@"WenDaInfoViewController" bundle:nil];
    tickInfo.wenda=wenda;
    [self.navigationController pushViewController:tickInfo animated:YES];
}

///专家团
- (IBAction)zhuanjiaAction:(id)sender {
    ZhuanjiaController *zhuanVc=[[ZhuanjiaController alloc] init];
    [self.navigationController pushViewController:zhuanVc animated:YES];
}
///问答
- (IBAction)wenDaAction:(UIButton *)sender {
    huidaController *tiwenVc=[[huidaController alloc] init];
    [self.navigationController pushViewController:tiwenVc animated:YES];
}
///提问
- (IBAction)tiWenAction:(UIButton *)sender {
    tiwenController *tiwenVc=[[tiwenController alloc] init];
    tiwenVc.type=WenDaType;
    [self.navigationController pushViewController:tiwenVc animated:YES];
}




@end
