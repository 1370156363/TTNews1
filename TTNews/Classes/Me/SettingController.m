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
@property (nonatomic, strong) UITableView    *tableview;
@property (nonatomic, strong) UIButton       *btnLoginOut;
@property (nonatomic, strong) NSMutableArray *arrayDataItems;
@end

@implementation SettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title=@"设置";
    self.arrayDataItems=[NSMutableArray array];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.btnLoginOut];
    [self loadData];
    //self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
}

-(void)loadData
{
    KGTableviewCellModel *model=[[KGTableviewCellModel alloc] init];
    model.title=@"推送通知";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"用户认证";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"编辑资料";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"修改密码";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"黑名单";
    [self.arrayDataItems addObject:model];
    
//    model=[[KGTableviewCellModel alloc] init];
//    model.title=@"清理缓存";
//    [self.arrayDataItems addObject:model];
//
//    model=[[KGTableviewCellModel alloc] init];
//    model.title=@"字体大小";
//    [self.arrayDataItems addObject:model];
//
//    model=[[KGTableviewCellModel alloc] init];
//    model.title=@"列表显示摘要";
//    [self.arrayDataItems addObject:model];
//
//    model=[[KGTableviewCellModel alloc] init];
//    model.title=@"非WI-FI网络流量";
//    [self.arrayDataItems addObject:model];
//
//    model=[[KGTableviewCellModel alloc] init];
//    model.title=@"非WI-FI网络播放提醒";
//    [self.arrayDataItems addObject:model];
    
    
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"关于我们";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"当前版本";
    [self.arrayDataItems addObject:model];
    
    [self SetTableviewMethod];
}

-(void)btnLoginOutClick{
    [[OWTool Instance] saveUid:@""];
    self.loginOutBlock();
    [self.navigationController popViewController];
}

-(void)SetTableviewMethod
{
    weakSelf(ws);
    [self.tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker * section)
         {
             section.cell([UITableViewCell class])
             .data(self.arrayDataItems)
             .adapter(^(UITableViewCell * cell,KGTableviewCellModel * data,NSUInteger index)
             {
                 cell.textLabel.text=data.title;
                 cell.textLabel.font=[UIFont systemFontOfSize:17];
                 if (index==0)
                 {
                     UISwitch *sw=[[UISwitch alloc] init];
                     [sw setEnabled:NO];
                     [cell.contentView addSubview:sw];
                     [sw mas_makeConstraints:^(MASConstraintMaker *make) {
                         make.top.offset(10);
                         make.bottom.offset(-5);
                         make.right.offset(-30);
                         make.width.mas_equalTo(30);
                     }];
                     //通知是否开启
                     if (!([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone)) {
                         [sw setOn:YES];
                     }
                     else{
                        [sw setOn:NO];
                     }
//                     [sw addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
                 }
             })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
             {
                 
                 if (index==2)
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
                           [[SDImageCache sharedImageCache] clearMemory];
                           [SVProgressHUD showSuccessWithStatus:@"缓存清除完毕!"];
                       }];
                     [alert addAction:camera];
                     [alert addAction:phont];
                     [ws presentViewController:alert animated:NO completion:nil];
                 }
 
             })
             .height(50);
         }];
    }];
}

-(UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.width.equalTo(self.view);
             make.left.equalTo(0);
             make.height.equalTo(self.view).offset(-200);
         }];
        
    }
    
    return _tableview;
}
-(UIButton *)btnLoginOut
{
    if (_btnLoginOut == nil) {
        _btnLoginOut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLoginOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableview).offset(20);
            make.left.right.equalTo(self.view).offset(-40);
            make.height.mas_equalTo(45);
        }];
        _btnLoginOut.layer.cornerRadius = 22.5;
        [_btnLoginOut setTitle:@"退出" forState: UIControlStateNormal];
        [_btnLoginOut.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnLoginOut.titleLabel setTextColor:[UIColor redColor]];
        [_btnLoginOut addTarget:self action:@selector(btnLoginOutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnLoginOut;
}

@end
