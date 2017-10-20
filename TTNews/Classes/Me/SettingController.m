//
//  SettingController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "SettingController.h"
#import "InformEditController.h"
#import "KGTableviewCellModel.h"
#import "TTDataTool.h"

@interface SettingController ()
@property(nonatomic,strong)NSMutableArray *arrayDataItems;
@end

@implementation SettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"设置";
    self.arrayDataItems=[NSMutableArray array];
    [self loadData];
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
}

-(void)loadData
{
    KGTableviewCellModel *model=[[KGTableviewCellModel alloc] init];
    model.title=@"编辑资料";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"账号和绑定设置";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"黑名单";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"清理缓存";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"字体大小";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"列表显示摘要";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"非WI-FI网络流量";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"非WI-FI网络播放提醒";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"推送通知";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"离线下载";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"当前版本";
    [self.arrayDataItems addObject:model];
    
    [self SetTableviewMethod];
}

-(void)SetTableviewMethod
{
    weakSelf(ws);
    [self.tableView cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker * section)
         {
             section.cell([UITableViewCell class])
             .data(self.arrayDataItems)
             .adapter(^(UITableViewCell * cell,KGTableviewCellModel * data,NSUInteger index)
             {
                 cell.textLabel.text=data.title;
                 cell.textLabel.font=[UIFont systemFontOfSize:15];
             })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
             {
                 if (index==0)
                 {
                     InformEditController *editVc=[[InformEditController alloc] init];
                     [ws.navigationController pushViewController:editVc animated:YES];
                 }
                 else if (index==3)
                 {
                     CKAlertViewController *alert=[CKAlertViewController alertControllerWithTitle:@"提示" message:@"确定要删除所有缓存吗？"];
                     CKAlertAction *camera=[CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action)
                     {
                         
                     }];
                     CKAlertAction *phont=[CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action)
                       {
                           [SVProgressHUD show];
                           [TTDataTool deletePartOfCacheInSqlite];
                           [[SDImageCache sharedImageCache] clearDisk];
                           [SVProgressHUD showSuccessWithStatus:@"缓存清除完毕!"];
                       }];
                     [alert addAction:camera];
                     [alert addAction:phont];
                     [ws presentViewController:alert animated:NO completion:nil];
                 }
 
             })
             .height(45);
         }];
    }];
}
@end
