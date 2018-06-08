//
//  MyFensiController.m
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyFensiController.h"
#import "fensiTableViewCell.h"
#import "AddUserInfoModel.h"
#import "MyFensiModel.h"
#import "UserModel.h"
#import "InformEditController.h"

@interface MyFensiController ()

@property (nonatomic, strong) UITableView      *tableview;
@property (nonatomic, strong) NSArray <MyFensiModel*>* modelList;//我的关注
@property (nonatomic, strong) NSArray <AddUserInfoModel*>* userModelList;

@end

@implementation MyFensiController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isShowBtnAttention) {
        self.title=@"添加关注";
    }
    else if (_isShowBtnInvite){
        self.title = @"添加邀请";
    }
    else
        self.title=@"粉丝";
    [self setupBasic];
}

#pragma mark 基本设置
- (void)setupBasic
{
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableview setSeparatorColor:RGB(240, 240, 240)];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:@"fensiTableViewCell" bundle:nil] forCellReuseIdentifier:@"fensiTableViewCellIdentify"];
    
    
    weakSelf(ws);
    ///添加关注
    if (_isShowBtnAttention) {
        NSMutableDictionary *prms=[@{
                                     @"page":@1,
                                     @"uid":[[OWTool Instance] getUid],
                                     }mutableCopy];
        
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetUser withUserInfo:prms success:^(NSDictionary *message)
         {
             _userModelList = [AddUserInfoModel mj_objectArrayWithKeyValuesArray:message[@"info"]];
             [ws.tableview reloadData];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
    ///邀请问答
    else if (_isShowBtnInvite) {
        NSMutableDictionary *prms=[@{
                                     @"page":@1,
                                     @"uid":[[OWTool Instance] getUid],
                                     @"answer_id":_answerID,
                                     }mutableCopy];
        
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetUser withUserInfo:prms success:^(NSDictionary *message)
         {
             _userModelList = [AddUserInfoModel mj_objectArrayWithKeyValuesArray:message[@"info"]];
             [ws.tableview reloadData];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
    ///粉丝
    else{
        NSMutableDictionary *prms=[@{
                                     @"uid":[[OWTool Instance] getUid] ,
                                     @"page":@1
                                     }mutableCopy];
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkMyFensi withUserInfo:prms success:^(NSDictionary *message)
         {
             [MyFensiModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                 return @{@"ID":@"id"};
             }];
             _modelList = [MyFensiModel mj_objectArrayWithKeyValuesArray:message[@"data"]];
             [ws.tableview reloadData];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
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
    if (_isShowBtnAttention) {
        cell.model1 = _userModelList[row];
    }
    else if (_isShowBtnInvite){
        cell.model2 = _userModelList[row];
        cell.answerID = _answerID;
    }
    else
        cell.model = _modelList[row];
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
    if (_isShowBtnAttention) {
        return _userModelList ?_userModelList.count: 0;
    }
    else if(_isShowBtnInvite){
        return _userModelList ?_userModelList.count: 0;
    }
    else
        return _modelList ?_modelList.count: 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
