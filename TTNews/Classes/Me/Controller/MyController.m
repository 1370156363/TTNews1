//
//  MyController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyController.h"
#import <SDImageCache.h>
#import "TTDataTool.h"
#import <SVProgressHUD.h>
#import "UIImage+Extension.h"
#import "TTConst.h"
#import "SendFeedbackViewController.h"
#import "AppInfoViewController.h"
#import "EditUserInfoViewController.h"
#import "UIImage+Extension.h"
#import <DKNightVersion.h>
#import "KGTableviewCellModel.h"
#import "KGMPersonalHeaderView.h"
#import "LibraryController.h"
#import "FocusCell.h"
#import "SettingController.h"
#import "collectController.h"
#import "fensiController.h"
#import "KGDynamicsController.h"
#import "LoginController.h"
#import "MyFensiController.h"

@interface MyController ()
@property (nonatomic, weak) UISwitch                *shakeCanChangeSkinSwitch;
@property (nonatomic, assign) CGFloat               cacheSize;
@property (nonatomic, strong)NSMutableArray         *arrayDataItems;
@property (nonatomic,strong)KGMPersonalHeaderView   *personalHeaderView;
@property (nonatomic,strong)UITableView             *tableView;

@end

@implementation MyController


-(void)BtnAction:(NSInteger)tag
{
    if (tag==50)
    {
//        [self.navigationController pushViewController:[SettingController new] animated:YES];
//        if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid]isEqualToString:@""]){
//
//        }
        [self.navigationController pushViewController:[[LoginController alloc] init] animated:YES];
        
    }
    else if (tag==10)
    {
        [self.navigationController pushViewController:[KGDynamicsController new] animated:YES];
    }
    else if (tag==20)
    {
        [self.navigationController pushViewController:[MyFensiController new] animated:YES];
    }
    else if (tag==30)
    {
        [self.navigationController pushViewController:[fensiController new] animated:YES];
    }
    else if (tag==40)
    {
        [self.navigationController pushViewController:[fensiController new] animated:YES];
    }
}
-(KGMPersonalHeaderView *)personalHeaderView
{
    weakSelf(ws);
    if (!_personalHeaderView)
    {
        _personalHeaderView=[[KGMPersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, 190)];
        _personalHeaderView.KGPersonalCheckBlock=^(NSInteger tag)
        {
            [ws BtnAction:tag];
        };
    }
    return _personalHeaderView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height-49) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = RGB(240, 240, 240);
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
    [self caculateCacheSize];
    [self setupBasic];
    self.tableView.tableHeaderView=self.personalHeaderView;
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#dfdfdf"];
    self.arrayDataItems=[NSMutableArray array];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [SVProgressHUD dismiss];
}

-(void)setupBasic{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
}

///刷新
-(void)loadData
{
    KGTableviewCellModel *model=[[KGTableviewCellModel alloc] init];
    model.title=@"消息通知";
    model.imageName=@"xiaoxiTZ";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"收藏/历史";
    model.imageName=@"shoucangjia";
    [self.arrayDataItems addObject:model];
    
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"我要投稿";
    model.imageName=@"tougao";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"社交群组";
    model.imageName=@"qunzu";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"我的商城";
    model.imageName=@"shangcheng";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"电子图书馆";
    model.imageName=@"yuedu";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"日间/夜间";
    model.imageName=@"yejian";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"用户反馈";
    model.imageName=@"fankui";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"发布管理";
    model.imageName=@"shangchuan";
    [self.arrayDataItems addObject:model];
    
    model=[[KGTableviewCellModel alloc] init];
    model.title=@"系统设置";
    model.imageName=@"shezhi";
    [self.arrayDataItems addObject:model];
    
    [self SetTableviewMethod];
}


-(void)caculateCacheSize {
    float imageCache = [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
    //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"data.sqlite"];
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    float sqliteCache = [fileManager attributesOfItemAtPath:path error:nil].fileSize/1024.0/1024.0;
    self.cacheSize = imageCache;
}

-(void)switchDidChange:(UISwitch *)theSwitch {
    
    if (theSwitch.on == YES) {//切换至夜间模式
        self.dk_manager.themeVersion = DKThemeVersionNight;
        self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
        
    } else {
        self.dk_manager.themeVersion = DKThemeVersionNormal;
        self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
        
    }
    //    else if (theSwitch == self.shakeCanChangeSkinSwitch) {//摇一摇夜间模式
    //        BOOL status = self.shakeCanChangeSkinSwitch.on;
    //        [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:IsShakeCanChangeSkinKey];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        if([self.delegate respondsToSelector:@selector(shakeCanChangeSkin:)]) {
    //            [self.delegate shakeCanChangeSkin:status];
    //        }
    //   }
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)SetTableviewMethod
{
    weakSelf(ws);
    [self.tableView cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker * section)
         {
             section.cell([FocusCell class])
             .data(@[@""])
             .adapter(^(FocusCell * cell,NSArray * data,NSUInteger index)
             {
                 
             })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
            {
                [ws.navigationController pushViewController:[fensiController new] animated:YES];
            })
             .height(81);
         }];
        
        [make makeSection:^(CBTableViewSectionMaker *section)
         {
             section.data(self.arrayDataItems)
             .cell([UITableViewCell class])
             .adapter(^(UITableViewCell *cell,KGTableviewCellModel *model,NSUInteger index)
                      {
                          cell=[cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identify"];
                          cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                          cell.textLabel.text=model.title;
                          cell.imageView.image=[UIImage imageNamed:model.imageName];
                          
                          if (index==6)
                          {
                              UISwitch *sw=[[UISwitch alloc] init];
                              [cell.contentView addSubview:sw];
                              [sw mas_makeConstraints:^(MASConstraintMaker *make) {
                                  make.top.offset(5);
                                  make.bottom.offset(-5);
                                  make.right.offset(-20);
                                  make.width.mas_equalTo(30);
                              }];
                              [sw addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
                          }
                          
                      })
             .event(^(NSUInteger index, KGTableviewCellModel *model)
                    {
                        if (index==0)
                        {
                            KGDynamicsController *dyVc=[KGDynamicsController new];
                            [self.navigationController pushViewController:dyVc animated:YES];
                        }
                        else if (index==1)
                        {
                            collectController *collect=[[collectController alloc] init];
                            [self.navigationController pushViewController:collect animated:YES];
                        }
                        else  if (index==5)
                        {
                            LibraryController *libraryVc=[[LibraryController alloc] init];
                            [self.navigationController pushViewController:libraryVc animated:YES];
                        }
                        else if (index==7)
                        {
                            [self.navigationController pushViewController:[[SendFeedbackViewController alloc] init] animated:YES];
                        }
                        
                        
                    })
             .height(45);
         }];
    }];
}


@end
