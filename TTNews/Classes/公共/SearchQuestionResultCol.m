//
//  SearchQuestionResultCol.m
//  TTNews
//
//  Created by 薛立强 on 2018/3/13.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "SearchQuestionResultCol.h"
#import "WendaModel.h"
#import "WenDaTableViewCell.h"
#import "WenDaInfoViewController.h"

@interface SearchQuestionResultCol ()

@property (nonatomic, strong) NSMutableArray *arrayList;

@end

@implementation SearchQuestionResultCol

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.arrayList) {
        self.arrayList=[NSMutableArray array];
    }
    [self setupBasic];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView registerClass:[WenDaTableViewCell class] forCellReuseIdentifier:@"WenDaTableViewCellIdentify"];
    
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupBasic {
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
   
}


///网络请求
-(void)loadList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"keyword":_searchStr}];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkSearchQuesion withUserInfo:dict success:^(id message) {
        if([[message objectForKey:@"status"]intValue ] == 1){
            NSArray *array = [message objectForKey:@"data"];
            [self.tableView.mj_header endRefreshing];
            if (array && array.count>0) {
                [SVProgressHUD dismiss];
                ws.arrayList = [WendaModel mj_objectArrayWithKeyValuesArray:array];
                [ws.tableView reloadData];
            }
            else{
                [SVProgressHUD showInfoWithStatus:@"抱歉，没有找到相关资源！"];
                [SVProgressHUD dismissWithDelay:2.0];
            }
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"查找资源错误！"];
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD dismissWithDelay:2.0];
        }
        
    } failure:^(NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
     } visibleHUD:YES];
}

-(void)setupRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadList)];
    [self.tableView.mj_header beginRefreshing];
   
}

#pragma mark - TableView DataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayList.count;
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
    
    cell.wendaModel=self.arrayList[indexPath.row];
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WendaModel *model = _arrayList[indexPath.row];
    float height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"wendaModel" cellClass:[WenDaTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    NSLog(@"当前列表是%ld，高度是%.2f",(long)indexPath.row,height);
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WendaModel *wenda=self.arrayList[indexPath.row];
    NSLog(@"点击的是%ld",(long)indexPath.row);
    WenDaInfoViewController *tickInfo=[[WenDaInfoViewController alloc] initWithNibName:@"WenDaInfoViewController" bundle:nil];
    tickInfo.wenda=wenda;
    [self.navigationController pushViewController:tickInfo animated:YES];
}

@end
