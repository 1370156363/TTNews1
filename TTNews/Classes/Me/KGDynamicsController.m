//
//  KGDynamicsController.m
//  Aerospace
//
//  Created by 王迪 on 2017/2/22.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import "KGDynamicsController.h"
#import "SinglePictureNewsTableViewCell.h"
#import "DymamicModel.h"
#import "KGDynamicTableViewCell.h"
#import "UserModel.h"
#import "DongTaiInfoViewController.h"
#define  Margion 5

@interface KGDynamicsController ()
@property (nonatomic, strong) UITableView      *tableview;
@property (nonatomic, strong) NSArray <DymamicModel*>* modelList;

@end

@implementation KGDynamicsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title=@"我的动态";
    [self setupBasic];
}

#pragma mark 基本设置
- (void)setupBasic
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorColor = RGB(240, 240, 240);
    _tableview.tableFooterView = [[UIView alloc] init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:_tableview];
    
    [_tableview registerClass:[KGDynamicTableViewCell class] forCellReuseIdentifier:@"KGDynamicTableViewCellIdnetify"];
    
    NSMutableDictionary *prms;
    
    if (_userID != nil) {
        prms =[@{
           @"uid":_userID,
           @"page":@1
           }mutableCopy];
    }
    else{
      prms =  [@{
           @"uid":[[OWTool Instance] getUid] ,
           @"page":@1
           }mutableCopy];
    }
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkmyDynamic withUserInfo:prms success:^(NSDictionary *message)
     {
         _modelList = [DymamicModel mj_objectArrayWithKeyValuesArray:message];
         [self.tableview reloadData];
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  [self.tableview cellHeightForIndexPath:indexPath model:_modelList[indexPath.row] keyPath:@"model" cellClass:[KGDynamicTableViewCell class] contentViewWidth:SCREEN_WIDTH];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DongtaiModel *wenda=(DongtaiModel *)_modelList[indexPath.row];
    NSLog(@"点击的是%ld",(long)indexPath.row);
    DongTaiInfoViewController *tickInfo=[[DongTaiInfoViewController alloc] initWithNibName:@"DongTaiInfoViewController" bundle:nil];
    tickInfo.wenda=wenda;
    [self.navigationController pushViewController:tickInfo animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelList ?_modelList.count: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    KGDynamicTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"KGDynamicTableViewCellIdnetify" forIndexPath:indexPath];
    
    cell.model = _modelList[row];
    UserModel *userModel = [UserModel mj_objectWithKeyValues:[[OWTool Instance] getUserInfo]];
    [cell.imgHeaderView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,userModel.avatar]]];
    return cell;
}

@end
