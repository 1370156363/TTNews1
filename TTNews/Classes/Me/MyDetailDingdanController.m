//
//  MyDetailDingdanController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyDetailDingdanController.h"
#import "MyShoppongTableCell.h"

@interface MyDetailDingdanController (){
    NSInteger currentPage;
}
@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray <NSDictionary*> * modelList;
@end

@implementation MyDetailDingdanController

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelList = [NSMutableArray new];
    [self.view addSubview:self.tableview];
    [self.tableview.mj_header beginRefreshing];
    [self.tableview registerNib:[UINib nibWithNibName:@"MyShoppongTableCell" bundle:nil] forCellReuseIdentifier:@"MyShoppongTableCellIdentify"];
    self.tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    [self request];
}

-(void)loadData{
    currentPage = 1;
    [self request];
}

- (void)loadMoreData
{
    currentPage += 1;
    [self request];
}
//网络请求
-(void)request{
    NSMutableDictionary *prms = [@{
                                   @"uid":[[OWTool Instance] getUid],
                                   @"status":@(_state),
                                   @"page":@(currentPage)
                                   }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KnetworkGetMyDingdan withUserInfo:prms success:^(NSArray *message)
     {
         if (message.count> 0) {
             if (currentPage == 1) {
                 _modelList = [[NSMutableArray alloc]initWithArray:message];
             }
             else{
                 [_modelList addObjectsFromArray:message];
             }
             [ws.tableview reloadData];
         }
         else
         {
             [SVProgressHUD showInfoWithStatus:@"暂无数据！"];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
}

-(void)deleteDingdan:(NSInteger)index{
    
    //            [cell removeFromSuperview];
    
    NSMutableDictionary *prms = [@{
                                   @"uid":[[OWTool Instance] getUid],
                                   @"id":self.modelList[index][@"id"]
                                   }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetDeleteDingdan withUserInfo:prms success:^(NSArray *message)
     {
         //删除
         [ws.modelList removeObjectAtIndex:index];
         [ws.tableview reloadData];
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    weakSelf(ws)
    MyShoppongTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyShoppongTableCellIdentify" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.labTitle.text = self.modelList[row][@"goods"][@"title"];
    cell.labPrice.text = [NSString stringWithFormat:@"￥%@",self.modelList[row][@"goods"][@"price"]];
    [cell.imgShopView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://xinwen.52jszhai.com",self.modelList[row][@"goods"][@"fengmian"]]] placeholderImage:ImageNamed(@"tupianGL")];
    cell.MyShoppongTable = ^(NSInteger index) {
        if (index == 100) {
            weakSelf(ws)
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除订单" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [ws deleteDingdan:row];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if (index == 200){
            //去付款
        }
    };
    
    if (_state == Dingdan_No_Pay) {
        [cell.labDingdanState setHidden:YES];
        [cell.btnDeletaDingdan setHidden:NO];
        [cell.btnOperate setHidden:NO];
        [cell.btnOperate setTitle:@"去付款" forState:UIControlStateNormal];
    }
    else if(_state == Dingdan_No_Fahuo){
        [cell.labDingdanState setHidden:NO];
        [cell.btnDeletaDingdan setHidden:YES];
        [cell.btnOperate setHidden:YES];
        cell.labDingdanState.text = @"订单已提交，等待发货";
    }
    else if(_state == Dingdan_No_Receive){
        [cell.labDingdanState setHidden:NO];
        [cell.btnDeletaDingdan setHidden:YES];
        [cell.btnOperate setHidden:YES];
        cell.labDingdanState.text = @"正在运输途中";
    }
    else if(_state == Dingdan_Back_Pay){
        [cell.labDingdanState setHidden:NO];
        [cell.btnDeletaDingdan setHidden:YES];
        [cell.btnOperate setHidden:YES];
        cell.labDingdanState.text = @"正在退款";
    }
    return cell;
}
-(UITableView*)tableview{
    
    if (_tableview == nil) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, winsize.width, winsize.height-64) style:UITableViewStylePlain];
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorColor = RGB(240, 240, 240);
        _tableview.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [UIView new];
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableview;
}

@end
