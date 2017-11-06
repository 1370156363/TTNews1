//
//  MyFensiController.m
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyFensiController.h"
#import "fensiTableViewCell.h"
#import "MyFensiModel.h"
#import "UserModel.h"

@interface MyFensiController ()

@property (nonatomic, strong) UITableView      *tableview;
@property (nonatomic, strong) NSArray <MyFensiModel*>* modelList;//我的关注
@property (nonatomic, strong) NSArray <UserModel*>* userModelList;

@end

@implementation MyFensiController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:navColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isShowBtnAttention) {
        self.title=@"添加关注";
    }
    else
        self.title=@"粉丝";
    [self setupBasic];
}

#pragma mark 基本设置
- (void)setupBasic
{
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tableview setSeparatorColor:RGB(240, 240, 240)];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:_tableview];
    [_tableview registerNib:[UINib nibWithNibName:@"fensiTableViewCell" bundle:nil] forCellReuseIdentifier:@"fensiTableViewCellIdentify"];
    
    
    
    if (_isShowBtnAttention) {
        NSMutableDictionary *prms=[@{
                                     @"page":@1
                                     }mutableCopy];
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetUser withUserInfo:prms success:^(NSDictionary *message)
         {
//             [UserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
//                 return @{@"uid":@"uid"
//                          };
//             }];
             _userModelList = [UserModel mj_objectArrayWithKeyValuesArray:message[@"info"]];
             [self.tableview reloadData];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
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
             [self.tableview reloadData];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  100;
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
    else
        cell.model = _modelList[row];
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
