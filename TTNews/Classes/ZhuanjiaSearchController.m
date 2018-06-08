//
//  ZhuanjiaSearchController.m
//  TTNews
//
//  Created by 薛立强 on 2018/2/6.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "ZhuanjiaSearchController.h"
#import "AddUserInfoModel.h"
#import "fensiTableViewCell.h"
#import "InformEditController.h"

@interface ZhuanjiaSearchController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView      *tableview;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *userModelList;

@end

@implementation ZhuanjiaSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    // Do any additional setup after loading the view.
}

#pragma mark --private Method--设置tableView
-(void)setupBasic {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableview setSeparatorColor:RGB(240, 240, 240)];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:@"fensiTableViewCell" bundle:nil] forCellReuseIdentifier:@"fensiTableViewCellIdentify"];
    [self requestUrl];
}


- (void)requestUrl
{
    NSMutableDictionary *prms=[@{
                                 @"keyword":_searchStr,
                                 @"page":@1,
                                 @"uid":[[OWTool Instance] getUid]
                                 }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkSearchUser withUserInfo:prms success:^(NSDictionary *message)
     {
         _userModelList = [AddUserInfoModel mj_objectArrayWithKeyValuesArray:message[@"info"]];
         [ws.tableview reloadData];
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    fensiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"fensiTableViewCellIdentify"forIndexPath:indexPath];
    cell.model1 = _userModelList[row];
    ///图片点击回调事件，跳转到用户详情页面
    weakSelf(ws)
    cell.ImageBlock = ^{
        InformEditController *userInfoCol =  [[InformEditController alloc] init];
        userInfoCol.userID = [NSString stringWithFormat:@"%d",[cell.userID intValue]];
        [ws.navigationController pushViewController:userInfoCol animated:NO];
    };
    
    return cell;
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _userModelList ?_userModelList.count: 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

@end
