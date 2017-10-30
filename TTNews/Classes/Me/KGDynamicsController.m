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
#define  Margion 5

@interface KGDynamicsController ()
@property (nonatomic, strong) UITableView      *tableview;
@property (nonatomic, strong) NSArray <DymamicModel*>* modelList;

@end

@implementation KGDynamicsController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:navColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title=@"我的动态";
    [self setupBasic];
}

#pragma mark 基本设置
- (void)setupBasic
{
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorColor = RGB(240, 240, 240);
    _tableview.tableFooterView = [[UIView alloc] init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    [_tableview registerClass:[KGDynamicTableViewCell class] forCellReuseIdentifier:@"KGDynamicTableViewCellIdnetify"];
    
    NSMutableDictionary *prms=[@{
                                 @"uid":[[OWTool Instance] getUid] ,
                                 @"page":@1
                                 }mutableCopy];
    
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkmyDynamic withUserInfo:prms success:^(NSDictionary *message)
     {
         [DymamicModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
             return @{@"ID":@"id"};
         }];
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
    return cell;
}
//-(void)SetTableviewMethod
//{
//    [_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
//        [make makeSection:^(CBTableViewSectionMaker *section) {
//            section.cell([KGDynamicTableViewCell class])
//            .data(_modelList)
//            .adapter(^(KGDynamicTableViewCell * cell,DymamicModel*  data,NSUInteger index)
//                     {
//                         cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"KGDynamicTableViewCellIdnetify"];
//                         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                         cell.model = data;
//
//                     })
//            .height(100);
//        }];
//    }];
//    [_tableview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)]];
//}
//
//-(void)hiddenKeyBoard
//{
//    DismissKeyboard;
//}


@end
