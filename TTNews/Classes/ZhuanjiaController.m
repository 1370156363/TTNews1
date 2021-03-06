//
//  ZhuanjiaController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/25.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ZhuanjiaController.h"
#import "UserModel.h"
#import "MyFensiModel.h"
#import "AddUserInfoModel.h"
#import "ZhuanjiaSearchController.h"

#import "ZhuanJiaTableViewCell.h"


@interface ZhuanjiaController ()
{
    NSMutableArray *guanzhuNum;
    ///进行比对的arr
    NSMutableArray *mutarr;
}

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) NSMutableArray    *dataListArr;

@end

@implementation ZhuanjiaController

-(void)getguanzhu{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[OWTool Instance] getUid],@"uid",[[OWTool Instance] getUid],@"id", nil];
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetGUANZHU withUserInfo:dict success:^(id message) {
         [SVProgressHUD dismiss];
        if ([message[@"status"] integerValue]==1) {
            [guanzhuNum removeAllObjects];
            NSMutableArray *newArr=[MyFensiModel mj_objectArrayWithKeyValuesArray:message[@"data"]];
            [guanzhuNum addObjectsFromArray:newArr];
            [self getZhuanJia];
            for (MyFensiModel *user in guanzhuNum) {
                [mutarr addObject:user.friend_id];
            }
        }

    } failure:^(NSError *error) {

    } visibleHUD:YES];
}

-(void)getZhuanJia{

    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.currentPage],@"page",[[OWTool Instance]getUid],@"uid", nil];

    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetUser withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        if ([message[@"status"] integerValue]==1) {
            if (self.currentPage==1) {
                [self.dataListArr removeAllObjects];
            }

            NSMutableArray *newArr=[AddUserInfoModel mj_objectArrayWithKeyValuesArray:message[@"info"]];

            [self.dataListArr addObjectsFromArray:newArr];
            if (newArr.count==0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];

    } visibleHUD:YES];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];


}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.dataListArr) {
        self.dataListArr=[[NSMutableArray alloc] init];
    }
    if (!guanzhuNum) {
        guanzhuNum=[[NSMutableArray alloc] init];
    }
    if (!mutarr) {
        mutarr=[[NSMutableArray alloc] init];
    }
    [self setupBasic];
    [self getguanzhu];
}

#pragma mark 基本设置
- (void)setupBasic {
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    [self initNavigationWithImgAndTitle:@"专家团" leftBtton:nil rightButImg:nil rightBut:nil navBackColor:navColor];

    self.currentPage = 1;
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor=HexRGB(0xE4E4E4);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self addRightItemViews];
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
    [self.navigationItem setTitleView:rightSearch];
}

-(void)searchBtnClick{
    //搜索
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入搜索内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        if ( searchText== nil || searchText.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入内容"];
            [SVProgressHUD dismissWithDelay:1];
        }else{
            ZhuanjiaSearchController *col = [[ZhuanjiaSearchController alloc] init];
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

    AddUserInfoModel *model=self.dataListArr[indexPath.section];

    ZhuanJiaTableViewCell *cell;

    cell=[self.tableView dequeueReusableCellWithIdentifier:@"zhuanjia"];
    cell =[[NSBundle mainBundle] loadNibNamed:@"ZhuanJiaTableViewCell" owner:self options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    [cell.iconimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,model.avatar]]];
    cell.title.text=model.nicheng;
    if (model.signature.length!=0) {
        cell.detailLab.text=model.signature;
    }
    else{
        cell.detailLab.text=@"这个人很懒,什么都没留下";
    }

    if (mutarr.count!=0) {
        if ([mutarr containsObject:model.uid]) {
            cell.guanzhuBtu.selected=YES;
            cell.guanzhuBtu.userInteractionEnabled = NO;
            [cell.guanzhuBtu setBackgroundColor:HexRGB(0xE4E4E4)];
            [cell.guanzhuBtu setTitle:@"已关注" forState:UIControlStateNormal];
        }
        else{
            cell.guanzhuBtu.layer.borderColor=[UIColor redColor].CGColor;
            cell.guanzhuBtu.userInteractionEnabled = YES;
            cell.guanzhuBtu.layer.borderWidth=1;
            [cell.guanzhuBtu setTitle:@"关注+" forState:UIControlStateNormal];
        }
    }
    else{
        cell.guanzhuBtu.layer.borderColor=[UIColor redColor].CGColor;
        cell.guanzhuBtu.userInteractionEnabled = YES;
        cell.guanzhuBtu.layer.borderWidth=1;
        [cell.guanzhuBtu setTitle:@"关注+" forState:UIControlStateNormal];
    }
    
    cell.guanzhuBtu.tag=indexPath.section+100;
    cell.guanzhuBtu.layer.cornerRadius=5;
    [cell.guanzhuBtu addTarget:self action:@selector(guanzhu:) forControlEvents:UIControlEventTouchUpInside];

    
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{

    self.currentPage=1;
    [self getZhuanJia];
}

- (void)loadMoreData
{
    self.currentPage+=1;
    [self getZhuanJia];
}

///关注
-(void)guanzhu:(UIButton *)btu{
    [self addGuanZhu:!btu.selected id:btu.tag-100];
}


-(void)addGuanZhu:(BOOL)isAdd id:(NSInteger)Id {
    UserModel *model=self.dataListArr[Id];

     NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:model.uid,@"uid",[[OWTool Instance] getUid],@"id", nil];
    ///添加即时通讯好友
//    [self addContact:model.username];
    ///接口没有调试
    if (isAdd) {
        ///添加关注
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkAddGUANZHU withUserInfo:dict success:^(id message) {
            [SVProgressHUD dismiss];
            if ([message[@"status"] integerValue]==1) {
                ///重新修改关注
                [self getguanzhu];
            }
            else{
                [SVProgressHUD showErrorWithStatus:message[@"msg"]];
            }
        } failure:^(NSError *error) {

        } visibleHUD:YES];

    }
    else{
        ///取消关注
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkDelGuanZhu withUserInfo:dict success:^(id message) {
            [SVProgressHUD dismiss];
            if ([message[@"status"] integerValue]==1) {
                ///重新修改关注
                [self getguanzhu];
            }
        } failure:^(NSError *error) {

        } visibleHUD:YES];
    }

}


@end
