//
//  collectController.m
//  Aerospace
//
//  Created by 王迪 on 2017/2/22.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import "collectController.h"
#import "SinglePictureNewsTableViewCell.h"
#import "MyCollectionModel.h"
#import "NewsTableViewCell.h"
#import "NewsInfoViewController.h"
#define  Margion 5

@interface collectController ()<UIScrollViewDelegate>
{
    int currentLPage ;
    int currentRPage ;
    int indexType;
}

@property (weak, nonatomic) IBOutlet UIButton *BtnCollection;
@property (weak, nonatomic) IBOutlet UIButton *BtnHistory;

@property(nonatomic,strong)UIScrollView     *m_Scrollview;
@property(nonatomic,strong)UITableView      *L_tableview;
@property(nonatomic,strong)UITableView      *R_tableview;
@property(nonatomic,strong)UIView           *line;


@property(nonatomic,strong)NSMutableArray   <MyCollectionModel*>  *L_modelList;
@property(nonatomic,strong)NSMutableArray   <MyCollectionModel*>  *R_modelList;

@end

@implementation collectController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.L_tableview.backgroundColor=[UIColor clearColor];
    self.R_tableview.backgroundColor=[UIColor clearColor];
    self.line.backgroundColor=RGB(240, 240, 240);
    self.title=@"收藏/历史";
    [self setupBasic];
}

#pragma mark 基本设置
- (void)setupBasic
{
    self.L_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.R_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    currentLPage = 1;
    currentRPage = 1;
    indexType = 1;
    //初次加载数据
    [self.L_tableview.mj_header beginRefreshing];
    self.L_tableview.estimatedRowHeight =50;
    self.L_tableview.rowHeight = UITableViewAutomaticDimension;
}

//网络请求
-(void)requestURL:(int)index withType:(NetWorkAction)type{
    NSMutableDictionary *prms = [@{
                                   @"uid":[[OWTool Instance] getUid],
                                   
                                   }mutableCopy];
//    if (KNetWorkMyCollection == type){
//        prms=[@{
//                @"uid":[[OWTool Instance] getUid],
//                @"limit":@(index)
//
//                }mutableCopy];
//    }
//    else{
//        prms=;
//    }
//
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:type withUserInfo:prms success:^(NSDictionary *message)
     {
         if ([message[@"status"] intValue]==1)
         {
             if (KNetWorkMyCollection == type){
                 [MyCollectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                     return @{@"article_id":@"articleid"};
                 }];
                 [ws updateLtableViewModel:index dic:message];
             }
             else if (KNetWorkMyHistory == type){
                 [MyCollectionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                     return @{@"article_id":@"article_id"};
                 }];
                 [ws updateRtableViewModel:index dic:message];
             }
             
         }
         else
         {
             [SVProgressHUD showInfoWithStatus:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
    [self.L_tableview.mj_header endRefreshing];
    [self.L_tableview.mj_footer endRefreshing];
    
    [self.R_tableview.mj_header endRefreshing];
    [self.R_tableview.mj_footer endRefreshing];
}
//更新数据
-(void)updateLtableViewModel:(int)index dic:(NSDictionary*)dic{
    
    if (index == 1) {
        _L_modelList = [MyCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
    }
    else{
        [_L_modelList addObjectsFromArray:[MyCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
    }
    [self setModel_L_tableView];
}

-(void)updateRtableViewModel:(int)index dic:(NSDictionary*)dic{
    if (index == 1) {
        _R_modelList = [MyCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
    }
    else{
        [_R_modelList addObjectsFromArray:[MyCollectionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
    }
    [self setModel_R_tablevie];
}
//上拉刷新下拉加载
-(void)setupRefresh:(UITableView*)tableView {
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    if (1 == indexType) {
        currentLPage=1;
        [self requestURL:1 withType:KNetWorkMyCollection];
    }
    else if(2 == indexType){
        currentRPage=1;
        [self requestURL:1 withType:KNetWorkMyHistory];
    }
    
}

- (void)loadMoreData
{
    if (1 == indexType) {
        currentLPage += 1;
        [self requestURL:currentLPage withType:KNetworkMyFensi];
    }
    else if (2 == indexType){
        currentRPage += 1;
        [self requestURL:currentRPage withType:KNetworkGetGUANZHU];
    }
   
    
}

-(IBAction)BtnSelect:(UIButton *)sender
{
    NSInteger tag=sender.tag/100-1;
    self.m_Scrollview.contentOffset=CGPointMake((winsize.width-2*Margion)*tag, 0);
    
    UIView *topView=[self.view viewWithTag:1000];
    CGFloat lineWidth=topView.frame.size.width/2;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(tag*lineWidth);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];
    if(_L_modelList == nil){
        [self.L_tableview.mj_header beginRefreshing];
    }
    if(_R_modelList == nil){
        [self.R_tableview.mj_header beginRefreshing];
    }
    
    if (tag == 0) {
        self.BtnCollection.selected = YES;
        self.BtnHistory.selected = NO;
        indexType = 1;
    }
    else if (tag == 1){
        self.BtnCollection.selected = NO;
        self.BtnHistory.selected = YES;
        indexType = 2;
    }
}

-(UIView *)line
{
    if (!_line)
    {
        _line=[UIView new];
        UIView *topView=[self.view viewWithTag:1000];
        CGFloat lineWidth=topView.frame.size.width/2;
        [topView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.width.mas_equalTo(lineWidth);
             make.left.equalTo(topView);
             make.height.mas_equalTo(2);
             make.bottom.equalTo(topView);
         }];
    }
    return _line;
}

-(UIScrollView *)m_Scrollview
{
    if (!_m_Scrollview)
    {
        _m_Scrollview=[[UIScrollView alloc] init];
        [self.view addSubview:_m_Scrollview];
        [_m_Scrollview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.view).offset(114);
             make.left.equalTo(self.view).offset(Margion);
             make.right.equalTo(self.view).offset(-Margion);
             make.bottom.equalTo(self.view.mas_bottom);
         }];
        _m_Scrollview.contentSize=CGSizeMake(winsize.width*2-6*Margion, 0);
        _m_Scrollview.scrollEnabled=NO;
        _m_Scrollview.delegate=self;
        _m_Scrollview.showsHorizontalScrollIndicator=NO;
    }
    return _m_Scrollview;
}

-(void)setModel_L_tableView{
    weakSelf(ws)
    [self.L_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([NewsTableViewCell class])
            .data(_L_modelList)
            .adapter(^(NewsTableViewCell * cell,MyCollectionModel * data,NSUInteger index)
                     {
                         cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                         cell.collectionModel = data;
                     })
            .event(^(NSUInteger index, MyCollectionModel *model)
                   {
                       NewsInfoViewController *col =  [[NewsInfoViewController alloc]init];
                       col.url=[NSString stringWithFormat:@"%d",model.article_id.intValue];
                       TTVideo *video = [TTVideo new];
                       video.ID = [NSString stringWithFormat:@"%d",[model.article_id intValue]];
                       video.uid = [NSString stringWithFormat:@"%d",[model.uid intValue]];
                       video.model_id = [NSString stringWithFormat:@"%d",[model.model_id intValue]];
                       video.title = model.title;
                       video.fengmian = model.fengmian;
                       video.create_time = model.create_time;
                       video.content = model.info;
                       video.avatar = model.avatar;
                       video.up = model.up;
                       video.pinglunnum = model.pinglunnum;
                       col.video=video;
                      
                       [ws.navigationController pushViewController:col animated:YES];
                   })
            .height(150);
        }];
    }];
}
-(void)setModel_R_tablevie{
    weakSelf(ws)
    [self.R_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([NewsTableViewCell class])
            .data(_R_modelList)
            .adapter(^(NewsTableViewCell * cell,MyCollectionModel * data,NSUInteger index)
                     {
                         cell.collectionModel = data;
                         
                     })
            .event(^(NSUInteger index, MyCollectionModel *model)
                   {
                       NewsInfoViewController *col =  [[NewsInfoViewController alloc]init];
                       col.url=[NSString stringWithFormat:@"%d",model.article_id.intValue];
                       TTVideo *video = [TTVideo new];
                       video.ID = [NSString stringWithFormat:@"%d",[model.article_id intValue]];
                       video.uid = [NSString stringWithFormat:@"%d",[model.uid intValue]];
                       video.model_id = [NSString stringWithFormat:@"%d",[model.model_id intValue]];
                       video.title = model.title;
                       video.fengmian = model.fengmian;
                       video.create_time = model.create_time;
                       video.content = model.info;
                       video.avatar = model.avatar;
                       col.video=video;
                      
                       [ws.navigationController pushViewController:col animated:YES];
                   })
            .height(150);
        }];
    }];
}

-(UITableView *)L_tableview
{
    if (!_L_tableview)
    {
        _L_tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_L_tableview];
        _L_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self setupRefresh:_L_tableview];
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
        _R_tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_R_tableview];
        [self setupRefresh:_R_tableview];
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
    NSInteger index = (NSInteger) (offsetX/(winsize.width-2*Margion));
    NSLog(@"-index=%zi",index);
    UIView *topView=[self.view viewWithTag:1000];
    CGFloat lineWidth=topView.frame.size.width/2;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(index *lineWidth);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];
    if (index==2) {
        [self kg_hidden:NO];
    }
    else{
        [self kg_hidden:YES];
    }
}

@end
