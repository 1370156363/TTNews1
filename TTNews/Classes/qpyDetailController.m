//
//  qpyDetailController.m
//  TTNews
//
//  Created by 王迪 on 2017/9/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "qpyDetailController.h"
#import "DynamicCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "CommentCell.h"

@interface qpyDetailController ()
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation qpyDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBasic];
    [self setupRefresh];
    [self.tableView registerClass:[DynamicCell class]
           forCellReuseIdentifier:@"zoneCell"];
}

- (void)setupBasic {
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    self.currentPage = 0;
}

-(void)setupRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.currentPage = 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zoneCell" forIndexPath:indexPath];
        cell.data = self.dynameItem;
        cell.fd_enforceFrameLayout = YES;
    }
    CommentCell *cell=[[CommentCell alloc] init];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // 先从缓存池中找header
    UILabel *sectionHeaderLabel = [[UILabel alloc] init];
    sectionHeaderLabel.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-10, 20);
    sectionHeaderLabel.text = @"全部评论";
    sectionHeaderLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    sectionHeaderLabel.backgroundColor=[UIColor whiteColor];
    return sectionHeaderLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0)
    {
        return 20;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        DynamicItem *item = self.dynameItem;
        CGFloat height ;
        @try {
            height = [tableView fd_heightForCellWithIdentifier:@"zoneCell" cacheByIndexPath:indexPath configuration:^(DynamicCell *cell) {
                //         cell = [[DynamicCell alloc]init];
                cell.fd_enforceFrameLayout = YES;
                cell.data = item;
            }];
            
        } @catch (NSException *exception)
        {
            height = 150;
        } @finally {
            
        }
        return height+6;
    }
    return 80;
}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    //    // http://c.m.163.com//nc/article/headline/T1348647853363/0-30.html
    //    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/0-20.html",self.urlString];
    //    [self loadDataForType:1 withURL:allUrlstring];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)loadMoreData
{
    //    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,(self.arrayList.count - self.arrayList.count%10)];
    //    //    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,self.arrayList.count];
    //    [self loadDataForType:2 withURL:allUrlstring];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}
@end
