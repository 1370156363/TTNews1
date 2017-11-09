//
//  AddressManageController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "AddressManageController.h"

#import "EditAddressController.h"

#import "AddressTableCell.h"

@interface AddressManageController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)NSMutableArray   <NSDictionary*>  *modelList;
@end

@implementation AddressManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.tableFooterView = [UIView new];
    self.tableview.separatorColor = RGB(200, 200, 200);
    self.tableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.title = @"地址管理";
    self.modelList=[NSMutableArray array];
    [self request];
    // Do any additional setup after loading the view from its nib.
}
//网络请求
-(void)request{
    NSMutableDictionary *prms = [@{
                                   @"uid":[[OWTool Instance] getUid]
                                   }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:kNetworkGetAllAddress withUserInfo:prms success:^(NSDictionary *message)
     {
         if (message.count> 0) {
             _modelList = [[NSMutableArray alloc]initWithArray:message];
             [ws setModel_tableView];
         }
         else
         {
             [SVProgressHUD showImage:nil status:@"暂无数据！"];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
    
}
- (IBAction)btnAddAddressClick:(UIButton *)sender {
    weakSelf(ws)
    EditAddressController * editCol = [EditAddressController new];
    editCol.EditDoneReturnBlock = ^{
        [ws request];
    };
    [self.navigationController pushViewController:editCol animated:YES];
}

-(void)setModel_tableView{
    weakSelf(ws)
    [self.tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([AddressTableCell class])
            .data(self.modelList)
            .adapter(^(AddressTableCell * cell,NSDictionary * data,NSUInteger index)
                     {
                         cell.selectionStyle = UITableViewCellSelectionStyleNone;
                         cell.labTitle.text = data[@"consignee"];
                         cell.labPhoneNum.text = data[@"mobile"];
                         cell.labAddress.text = [NSString stringWithFormat:@"%@%@%@%@",data[@"province"],data[@"city"],data[@"district"],data[@"address"]];
                         [cell AddressTableReturn:^(NSInteger tag) {
                             [ws tableBtnBlock:tag index:index];
                         }];
                     })
            .event(^(NSUInteger index, NSDictionary *model)
                   {
                       
                   })
            .height(120);
        }];
    }];
}

-(void)tableBtnBlock:(NSInteger)tag index:(NSUInteger)index{
    if (tag == 100) {
        EditAddressController *editCol = [[EditAddressController alloc]init];
        editCol.EditDoneReturnBlock = ^{
            [self request];
        };
       
        editCol.addressName = [NSString stringWithFormat:@"%@-%@-%@",self.modelList[index][@"province"],self.modelList[index][@"city"],self.modelList[index][@"district"]];
        editCol.ID = self.modelList[index][@"id"];
        editCol.ditailAddress = self.modelList[index][@"address"];
        editCol.phoneNum = self.modelList[index][@"mobile"];
        editCol.receiveName = self.modelList[index][@"consignee"];
        ///编辑
        [self.navigationController pushViewController:editCol animated:YES];
    }
    else if (tag == 200){
        ///删除
        NSMutableDictionary *prms=[@{
                                     @"uid":[[OWTool Instance] getUid],
                                     @"id":self.modelList[index][@"id"],
                                     }mutableCopy];
        weakSelf(ws)
        [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetDeleteAddress withUserInfo:prms success:^(NSDictionary *message)
         {
             [ws.modelList removeObjectAtIndex:index];
             
            UITableViewCell * cell = [ws.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
             [cell removeFromSuperview];
             [ws setModel_tableView];
         } failure:^(NSError *error) {
             
         } visibleHUD:NO];
        
        
    }
}

@end
