//
//  MyFavQuestionColViewController.m
//  TTNews
//
//  Created by 薛立强 on 2018/3/21.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "MyFavQuestionCol.h"
#import "WendaModel.h"
#import "WenDaTableViewCell.h"
#import "WenDaInfoViewController.h"
#import "WenDaTableViewCell.h"

@interface MyFavQuestionCol ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray    *dataListArr;
@property (weak, nonatomic) IBOutlet UIView *headView;


@property (strong, nonatomic) UITableView *MainTabView;

@end



@implementation MyFavQuestionCol

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.dataListArr) {
        self.dataListArr=[NSMutableArray array];
    }
    [self setupBasic];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupBasic {
    
    self.MainTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height-49) style:UITableViewStylePlain];
    self.MainTabView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    self.MainTabView.delegate=self;
    self.MainTabView.dataSource=self;
    self.MainTabView.showsVerticalScrollIndicator = NO;
    self.MainTabView.backgroundColor = [UIColor clearColor];
    self.MainTabView.separatorColor = RGB(240, 240, 240);
    self.MainTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.MainTabView];
    self.MainTabView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    self.MainTabView.separatorColor = [UIColor colorWithHexString:@"#dfdfdf"];
     [self.MainTabView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.MainTabView registerClass:[WenDaTableViewCell class] forCellReuseIdentifier:@"WenDaTableViewCellIdentify"];
    
}

///网络请求
-(void)loadList
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:[[OWTool Instance] getUid],@"uid", nil];
    WS(weakSelf)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkQuestionAnswerPush withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
        if ([message[@"status"] integerValue] == 1) {
            NSMutableArray *newArr=[WendaModel mj_objectArrayWithKeyValuesArray:message[@"data"][@"guanzhu"]];
            if (newArr.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"暂无数据"];
            }
            else{
                weakSelf.dataListArr = newArr;
                [weakSelf.MainTabView reloadData];
            }
            [weakSelf.MainTabView.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error)
     {
         [weakSelf.MainTabView.mj_header endRefreshing];
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
     } visibleHUD:YES];
}

-(void)setupRefresh {
    
    self.MainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadList)];
    [self.MainTabView.mj_header beginRefreshing];
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
    NSLog(@"点击的是%ld",(long)indexPath.row);
    WenDaInfoViewController *tickInfo=[[WenDaInfoViewController alloc] initWithNibName:@"WenDaInfoViewController" bundle:nil];
    tickInfo.wenda=wenda;
    [self.navigationController pushViewController:tickInfo animated:YES];
}


@end
