//
//  SearchResultControl.m
//  TTNews
//
//  Created by 薛立强 on 2018/1/25.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "SearchResultControl.h"


#import "VideoInfoViewController.h"
#import "VideoTableViewCell.h"

#import "NewsTableViewCell.h"
#import "NewsInfoViewController.h"
#import "TTVideo.h"

@interface SearchResultControl ()
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *arrayList;

@end

static NSString * const VideoCell = @"VideoCell";

@implementation SearchResultControl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark --private Method--设置tableView
-(void)setupBasic {
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [UIView new];
    if (!self.arrayList) {
        self.arrayList=[[NSMutableArray alloc] init];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:VideoCell];
    
    [self.tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"NewsTableViewCellIdentify"];
    [self loadDataForType];
}


- (void)loadDataForType
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{@"keyword":_searchStr}];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkSearch withUserInfo:dict success:^(id message) {
        if([[message objectForKey:@"status"]intValue ] == 1){
            
            NSArray *array = [message objectForKey:@"data"];
            if (array && array.count>0) {
                [SVProgressHUD dismiss];
                ws.arrayList = [TTVideo mj_objectArrayWithKeyValuesArray:array];
                [ws.tableView reloadData];
            }
            else{
                [SVProgressHUD showInfoWithStatus:@"抱歉，没有找到相关资源！"];
                [SVProgressHUD dismissWithDelay:2.0];
            }
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"查找资源错误！"];
            [self.tableView.mj_header endRefreshing];
            [SVProgressHUD dismissWithDelay:2.0];
        }
        
    } failure:^(NSError *error)
     {
         [self.tableView.mj_header endRefreshing];
     } visibleHUD:YES];
}

#pragma mark -UITableViewDataSource 返回tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -UITableViewDataSource 返回tableView每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTVideo *model=self.arrayList[indexPath.row];
    if ([model.model_id integerValue] != 6) {
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[NewsTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    }
    else
        return 322;
}

#pragma mark -UITableViewDataSource 返回indexPath对应的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTVideo *video=self.arrayList[indexPath.row];
    
    if ([video.model_id integerValue]==6) {
        ///视频
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCell];
        cell.video = video;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
    else{
        NewsTableViewCell *cell;
        cell=[tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCellIdentify" forIndexPath:indexPath];
        cell.model = video;
        return cell;
    }
}

#pragma mark -UITableViewDelegate 点击了某个cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TTVideo *video=self.arrayList[indexPath.section];
    if ([video.model_id integerValue]==6) {
        VideoInfoViewController *info=[[VideoInfoViewController alloc] init];
        info.url=video.ID;
        info.video=video;
        [self.navigationController pushViewController:info animated:YES];
    }
    else{
        NewsInfoViewController *info=[[NewsInfoViewController alloc] init];
        info.url=video.ID;
        info.video=video;
        [self.navigationController pushViewController:info animated:YES];
    }
}

@end
