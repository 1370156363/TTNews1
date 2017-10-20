//
//  dongtaiController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/25.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "dongtaiController.h"
#import "ZoneView.h"
#import "qpyDetailController.h"

@interface dongtaiController ()
@property (nonatomic, assign) NSInteger currentPage;
@property(nonatomic,strong)ZoneView *zoneView;
@end

@implementation dongtaiController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupBasic];
    [self getZonInfo];
}

#pragma mark 基本设置
- (void)setupBasic
{
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
}

-(void)getZonInfo
{
    //下方模拟的是数据请求  请求下来数组Info
    weakSelf(ws);
    //将数据传到zoneView(这里传递的数据可以是身份信息，例如id)然后在zoneView中根据该id进行
    if (_zoneView == nil) {
        _zoneView = [[ZoneView alloc]init];
        _zoneView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_zoneView];
        [_zoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    _zoneView.SelectTableRow = ^(DongtaiModel *item) {
        qpyDetailController *detailVc=[[qpyDetailController alloc] init];
        detailVc.dynameItem=item;
        [ws.navigationController pushViewController:detailVc animated:YES];
    };
    _zoneView.fVC = self;
}

@end
