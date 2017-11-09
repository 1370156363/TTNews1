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
#import "IMViewController.h"

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
    
    self.MainTabView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);

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
    ///登录进入
//    [self loginWithUsername:@"1908952839" password:@"2ff20eb1fafc680472fe5c3fc1b1e83e"];

    ///默认在这里登录
    if ([[OWTool Instance] getLastLoginUsername].length!=0) {
        IMViewController *im=[[IMViewController alloc] init];
        [self.navigationController pushViewController:im animated:YES];
    }
    else{
        //登录进入
//        [self loginWithUsername:@"1908952839" password:@"2ff20eb1fafc680472fe5c3fc1b1e83e"];
        [self loginWithUsername:@"18710861689" password:@"123456"];

    }

}


#pragma  mark - private
//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    //    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login...")];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];

        dispatch_async(dispatch_get_main_queue(), ^{
            //            [weakself hideHud];
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                //保存最近一次登录用户名
                [weakself saveLastLoginUsername];
                //发送自动登陆状态通知
            } else {
                switch (error.code)
                {
                    case EMErrorUserNotFound:
                    {
                        [self registUser:username password:password];
                    }
                        break;
                    case EMErrorNetworkUnavailable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                        break;
                    case EMErrorServerNotReachable:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                        break;
                    case EMErrorUserAuthenticationFailed:
                        TTAlertNoTitle(error.errorDescription);
                        break;
                    case EMErrorServerTimeout:
                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                        break;
                    case EMErrorServerServingForbidden:
                        TTAlertNoTitle(NSLocalizedString(@"servingIsBanned", @"Serving is banned"));
                        break;
                    case EMErrorUserLoginTooManyDevices:
                        TTAlertNoTitle(NSLocalizedString(@"alert.multi.tooManyDevices", @"Login too many devices"));
                        break;
                    default:
                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                        break;
                }
            }
        });
    });
}


- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

///注册
-(void)registUser:(NSString *)username password:(NSString *)password{
    [[EMClient sharedClient] registerWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            NSLog(@"注册成功");
            [self loginWithUsername:username password:password];
        }
    }];
}


@end
