//
//  ZhuanjiaController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/25.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ZhuanjiaController.h"

@interface ZhuanjiaController ()
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ZhuanjiaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"专家团";
    [self setupBasic];
    [self SetLastTableviewMethod];
    [self setupRefresh];
}

#pragma mark 基本设置
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

-(void)SetLastTableviewMethod
{
    [self.tableView cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section)
         {
             section.data(@[@"1",@"2",@"3",@"",@"",@"",@"",@"",@"",@""])
             .cell([UITableViewCell class])
             .adapter(^(UITableViewCell *cell,NSString *model,NSUInteger index)
             {
                 cell=[cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identify"];
                 cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                 cell.imageView.image=UIImageNamed(@"qq");
                 cell.textLabel.text=@"张三";
                 cell.detailTextLabel.text=@"资深金融人士，财经问答专家";
                 cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
                 [cell.detailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.left.equalTo(cell.textLabel.mas_right);
                     make.top.equalTo(cell.textLabel.mas_bottom).offset(5);
                     make.right.mas_equalTo(-60);
                     make.bottom.equalTo(cell.contentView).offset(-5);
                 }];
                 
                 UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                 [btn setTitle:@"加关注" forState:UIControlStateNormal];
                 btn.titleLabel.font=[UIFont systemFontOfSize:13];
                 [cell.contentView addSubview:btn];
                 [btn setBackgroundColor:[UIColor redColor]];
                 [btn mas_makeConstraints:^(MASConstraintMaker *make)
                  {
                      make.top.mas_equalTo(15);
                      make.right.mas_equalTo(0);
                      make.width.mas_equalTo(60);
                      make.bottom.offset(-15);
                  }];
             })
             .event(^(NSUInteger index, NSString *model)
                    {
                        
                    })
             .height(60);
         }];
    }];
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
