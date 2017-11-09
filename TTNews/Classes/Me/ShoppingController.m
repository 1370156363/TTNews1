//
//  ShoppingController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/6.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ShoppingController.h"
#import "ShoppingTableCell.h"
#import "ShoppingModel.h"
#import "VideoInfoViewController.h"
#import "KGTableviewCellModel.h"
#import "ShoppingMyTableCell.h"
#import "MyShopCollectController.h"
#import "AddressManageController.h"
#import "MyDingdanController.h"

#define Margion 5

@interface ShoppingController ()<UIScrollViewDelegate>
{
    NSInteger currentPage;
}
@property (weak, nonatomic) IBOutlet UIButton *BtnShopView;
@property (weak, nonatomic) IBOutlet UIButton *BtnMyView;

@property(nonatomic,strong)UIScrollView     *m_Scrollview;
@property(nonatomic,strong)UITableView      *L_tableview;
@property(nonatomic,strong)UITableView      *R_tableview;

@property(nonatomic,strong)NSMutableArray   <ShoppingModel*>  *L_modelList;
@end

@implementation ShoppingController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.L_tableview.backgroundColor=[UIColor clearColor];
    self.R_tableview.backgroundColor=[UIColor clearColor];
    self.title=@"商城";
    currentPage = 1;
    [self setupBasic];
}

#pragma mark 基本设置
- (void)setupBasic
{
    self.L_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.R_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    [self setModel_R_tablevie ];
    //初次加载数据
    [self.L_tableview.mj_header beginRefreshing];
    
    [_BtnShopView setTitleEdgeInsets:UIEdgeInsetsMake(20, -30, 0, 30)];
    [_BtnShopView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    
    [_BtnMyView setTitleEdgeInsets:UIEdgeInsetsMake(20, -30, 0, 30)];
    [_BtnMyView setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
}

//网络请求
-(void)request{
    NSMutableDictionary *prms = [@{
                                   @"page":@(currentPage)
                                   }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkGetShoppinglist withUserInfo:prms success:^(NSDictionary *message)
     {
         if (message.count> 0) {
             if (currentPage == 1) {
                 ws.L_modelList = [ShoppingModel mj_objectArrayWithKeyValuesArray:message];
             }
             else{
                 [ws.L_modelList addObjectsFromArray:[ShoppingModel mj_objectArrayWithKeyValuesArray:message]];
             }
             [ws setModel_L_tableView];
         }
         else
         {
             [SVProgressHUD showImage:nil status:@"暂无数据！"];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
    [self.L_tableview.mj_header endRefreshing];
    [self.L_tableview.mj_footer endRefreshing];
}

//上拉刷新下拉加载
-(void)setupRefresh {
    self.L_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.L_tableview.mj_header.automaticallyChangeAlpha = YES;
    self.L_tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadData{
    currentPage = 1;
    [self request];
}

- (void)loadMoreData
{
    currentPage += 1;
    [self request];
}

-(IBAction)BtnSelect:(UIButton *)sender
{
    NSInteger tag=sender.tag/100-1;
    
    if (tag == 0) {
        self.title=@"商城";
        self.BtnShopView.selected = YES;
        self.BtnMyView.selected = NO;
    }
    else if (tag == 1){
        self.title=@"我的商城";
        self.BtnShopView.selected = NO;
        self.BtnMyView.selected = YES;
    }
    self.m_Scrollview.contentOffset=CGPointMake((winsize.width)*tag, 0);
    
    UIView *topView=[self.view viewWithTag:1000];
    
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];
}

-(UIScrollView *)m_Scrollview
{
    if (!_m_Scrollview)
    {
        _m_Scrollview=[[UIScrollView alloc] init];
        [self.view addSubview:_m_Scrollview];
        [_m_Scrollview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.view).offset(64);
             make.left.equalTo(self.view);
             make.right.equalTo(self.view);
             make.bottom.equalTo(self.view.mas_bottom).offset(-50);
         }];
        _m_Scrollview.contentSize=CGSizeMake(winsize.width*2, 0);
        _m_Scrollview.scrollEnabled=YES;
        _m_Scrollview.delegate=self;
        _m_Scrollview.showsHorizontalScrollIndicator=NO;
    }
    return _m_Scrollview;
}

-(void)setModel_L_tableView{
    weakSelf(ws)
    [self.L_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([ShoppingTableCell class])
            .data(_L_modelList)
            .adapter(^(ShoppingTableCell * cell,ShoppingModel * data,NSUInteger index)
                     {
                         cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                         cell.model = data;
                     })
            .event(^(NSUInteger index, ShoppingModel *model)
                   {
                       VideoInfoViewController *info=[[VideoInfoViewController alloc] init];
                       info.url=model.category_id;
                       [ws.navigationController pushViewController:info animated:YES];
                   })
            .height(200);
        }];
    }];
}
-(void)setModel_R_tablevie{
    weakSelf(ws)
    [self.R_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([ShoppingMyTableCell class])
            .data(@[@1])
            .adapter(^(ShoppingMyTableCell * cell,NSDictionary * data,NSUInteger index)
                     {
                         [cell ShoppingTableReturn:^(NSInteger index) {
                             [ws rightTableBtnBlock:index];
                         }];
                     })
            .event(^(NSUInteger index, NSDictionary *model)
                   {
                   })
            .height(80);
        }];
    }];
}

-(void)rightTableBtnBlock:(NSInteger)index{
    if (index == 100) {
        [self.navigationController pushViewController:[AddressManageController new] animated:YES];
    }
    else if (index == 200){
        [self.navigationController pushViewController:[MyDingdanController new] animated:YES];
    }
    else if (index ==300)
    {
        [self.navigationController pushViewController:[MyShopCollectController new] animated:YES];
    }
}

-(UITableView *)L_tableview
{
    if (!_L_tableview)
    {
        _L_tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-114) style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_L_tableview];
        _L_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self setupRefresh];
        [_L_tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.height.width.equalTo(self.m_Scrollview);
             make.left.mas_equalTo(0);
         }];
    }
    return _L_tableview;
}

-(void)hiddenKeyBoard
{
    DismissKeyboard;
}


-(UITableView *)R_tableview
{
    if (!_R_tableview)
    {
        _R_tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-114) style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_R_tableview];
        _R_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_R_tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.height.width.equalTo(self.m_Scrollview);
             make.left.equalTo(self.L_tableview.mas_right);
         }];
    }
    
    return _R_tableview;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (NSInteger) (offsetX/(winsize.width));
    NSLog(@"-index=%zi",index);
    if (index==0) {
        [self BtnSelect:self.BtnShopView];
        //[self kg_hidden:NO];
    }
    else{
        //[self kg_hidden:YES];
        [self BtnSelect:self.BtnMyView];
    }
    
    
    
}


@end
