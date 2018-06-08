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

///详情
#import "DongTaiInfoViewController.h"
#import "LoginController.h"
#import "AddMessageViewController.h"
#import "LoginController.h"




#import "MLBasePageViewController.h"

@interface NewDongTaiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIBarButtonItem *_addFriendItem;
    
}
- (IBAction)sendAction:(UIButton *)sender;
- (IBAction)IMAction:(UIButton *)sender;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableArray    *dataListArr;
@property (weak, nonatomic) IBOutlet UITableView *MainTabView;
///当点击发布的时候  刷新页面
@property (assign ,nonatomic) BOOL shouldRefresh;


@property (strong, nonatomic)MLBasePageViewController   * vc;///segmentCiewCol

@end

@implementation NewDongTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    [self setupRefresh];
    
}


#pragma mark 基本设置
- (void)setupBasic
{
    [self initNavigationWithImgAndTitle:@"动态" leftBtton:@"" rightButImg:[UIImage imageNamed:@"jiahaoyou"] rightBut:nil navBackColor:navColor];
    [self.navigationItem.rightBarButtonItems[1] setAction:@selector(okAction)];
    
    self.MainTabView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    
    if (!self.dataListArr) {
        self.dataListArr=[NSMutableArray array];
    }
    
    self.MainTabView.delegate=self;
    self.MainTabView.dataSource=self;
    [self.MainTabView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.MainTabView.tableFooterView = [UIView new];
    
    [self.MainTabView registerClass:[DongTaiTableViewCell class] forCellReuseIdentifier:@"DongTaiTableViewCellIdentify"];
    
    _badgeView = [[RKNotificationHub alloc]initWithView:self.BtnChat];
    [_badgeView moveCircleByX:-20 Y:15];
    [_badgeView scaleCircleSizeBy:0.7];
    
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_badgeView) {
        if (unreadCount > 0) {
            
            [_badgeView setCount:(int)unreadCount];
            [_badgeView pop];
        }else{
            [_badgeView setCount:0];
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //主动刷新数据
    if(self.MainTabView.mj_header && _shouldRefresh){
        _shouldRefresh = NO;
        [self.MainTabView.mj_header beginRefreshing];
    }
     [self setupUnreadMessageCount];
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
    [self getNewList];
}

- (void)loadMoreData
{
    self.currentPage+=1;
    [self getNewList];

}

#pragma mark -网络传输
- (void)getNewList
{
    NSMutableDictionary *dict =[[NSMutableDictionary alloc] initWithDictionary:@{@"page":@(self.currentPage)}] ;
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkAllDynamic withUserInfo:dict success:^(id message) {
        NSMutableArray *newArr=[DongtaiModel mj_objectArrayWithKeyValuesArray:message];
        if (ws.currentPage==1)
        {
            [ws.dataListArr removeAllObjects];
        }
        [ws.dataListArr addObjectsFromArray:newArr];
        
        if (newArr.count==0) {
            [ws.MainTabView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [ws.MainTabView reloadData];
            [ws.MainTabView.mj_footer endRefreshing];
        }
        [ws.MainTabView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        
    } visibleHUD:NO];
}

#pragma mark - TableView DataSource

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DongtaiModel *model = _dataListArr[indexPath.row];
    float height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DongTaiTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    NSLog(@"当前列表是%ld，高度是%.2f",(long)indexPath.row,height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DongTaiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DongTaiTableViewCellIdentify" forIndexPath:indexPath];
    cell.row = indexPath.row;
    cell.model=self.dataListArr[indexPath.row];
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
//    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DongtaiModel *wenda=self.dataListArr[indexPath.row];
    NSLog(@"点击的是%ld",(long)indexPath.row);
    DongTaiInfoViewController *tickInfo=[[DongTaiInfoViewController alloc] initWithNibName:@"DongTaiInfoViewController" bundle:nil];
    tickInfo.wenda=wenda;
    [self.navigationController pushViewController:tickInfo animated:YES];
}

#pragma mark
///确定添加关注
-(void)okAction{
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
    else{
        ZhuanjiaController *zhuanVc=[[ZhuanjiaController alloc] init];
        [self.navigationController pushViewController:zhuanVc animated:YES];
    }
}

- (IBAction)sendAction:(UIButton *)sender {
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
    else{
        _shouldRefresh = YES;
        AddMessageViewController *col = [[AddMessageViewController alloc]init];
        [self.navigationController pushViewController:col animated:YES];
    }
}

- (IBAction)IMAction:(UIButton *)sender {
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }else{
        [self.navigationController pushViewController:self.vc animated:YES];
    }
    
}

#pragma mark LazyLoad

-(ContactListViewController *)contactListCol{
    if (_contactListCol == nil) {
        _contactListCol = [ContactListViewController new];
        
    }
    return _contactListCol;
}
-(ChatListViewController *)chatListCol{
    
    if (_chatListCol == nil) {
        _chatListCol = [ChatListViewController new];
        
    }
    return _chatListCol;
}

-(MLBasePageViewController*)vc{
    if (_vc == nil) {
        _vc = [[MLBasePageViewController alloc] init];
        _vc.VCArray = @[ self.chatListCol,self.contactListCol];
        _vc.sectionTitles = @[ @"消息", @"联系人"];
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [addButton addTarget:self.contactListCol action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
        _addFriendItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        weakSelf(ws);
        _vc.MLBasePageViewBlock = ^(int index) {
            if (index == 0) {
                ws.vc.navigationItem.rightBarButtonItem = nil;
            }
            else{
                ws.vc.navigationItem.rightBarButtonItem = _addFriendItem;
            }
        };
        
    }
    return _vc;
}





@end
