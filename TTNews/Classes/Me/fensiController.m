//
//  fensiController.m
//  Aerospace
//
//  Created by 王迪 on 2017/2/22.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import "fensiController.h"
#import "SinglePictureNewsTableViewCell.h"
#import "MyFensiController.h"
#import "fensiTableViewCell.h"
#import "MyFensiModel.h"
#define  Margion 5

@interface fensiController ()<UIScrollViewDelegate>
{
    int currentLPage ;
    int currentCPage ;
    int currentRPage ;
    int indexType;
}
@property(nonatomic,strong)UIScrollView     *m_Scrollview;
@property(nonatomic,strong)UITableView      *L_tableview;
@property(nonatomic,strong)UITableView      *C_tableview;
@property(nonatomic,strong)UITableView      *R_tableview;
@property(nonatomic,strong)NSMutableArray   <MyFensiModel*>  *L_modelList;
@property(nonatomic,strong)NSMutableArray   <MyFensiModel*>  *C_modelList;
@property(nonatomic,strong)NSMutableArray   <MyFensiModel*>  *R_modelList;


@property(nonatomic,strong)UIView           *line;

@property (nonatomic,strong) UIView   * myfensiHeaderView;

@property (weak, nonatomic) IBOutlet UIButton *BtnGusts;
@property (weak, nonatomic) IBOutlet UIButton *BtnFocus;
@property (weak, nonatomic) IBOutlet UIButton *btnFensi;

@end

@implementation fensiController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.L_tableview.backgroundColor=[UIColor clearColor];
    self.C_tableview.backgroundColor=[UIColor clearColor];
    self.R_tableview.backgroundColor=[UIColor clearColor];
    self.line.backgroundColor=RGB(240, 240, 240);
    self.title=@"粉丝";
    [self setupBasic];
    
}

#pragma mark 基本设置
- (void)setupBasic
{
    self.L_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.C_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    self.R_tableview.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    [MyFensiModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    currentLPage = 1;
    currentCPage = 1;
    currentRPage = 1;
    indexType = 1;
    //初次加载数据
    [self.L_tableview.mj_header beginRefreshing];
}
//网络请求
-(void)requestURL:(int)index withType:(NetWorkAction)type{
    NSMutableDictionary *prms;
    if (KNetworkGetGUANZHU == type){
        prms=[@{
                @"uid":[[OWTool Instance] getUid],
                @"limit":@(index)
                
                }mutableCopy];
    }
    else{
        prms=[@{
                @"uid":[[OWTool Instance] getUid],
                @"page":@(index)
                
                }mutableCopy];
    }
    
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:type withUserInfo:prms success:^(NSDictionary *message)
     {
         if ([message[@"status"] intValue]==1)
         {
             if (KNetworkMyFensi == type) {
                 [ws updateCtableViewModel:index dic:message];
             }
             else if (KNetworkGetGUANZHU == type){
                 [ws updateLtableViewModel:index dic:message];
             }
             else if (KNetworkGetMyFangwen == type){
                 [ws updateRtableViewModel:index dic:message];
             }
             
         }
         else
         {
             [SVProgressHUD showImage:nil status:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
    [self.L_tableview.mj_header endRefreshing];
    [self.L_tableview.mj_footer endRefreshing];
    
    [self.C_tableview.mj_header endRefreshing];
    [self.C_tableview.mj_footer endRefreshing];
    
    [self.R_tableview.mj_header endRefreshing];
    [self.R_tableview.mj_footer endRefreshing];
}
//更新数据
-(void)updateLtableViewModel:(int)index dic:(NSDictionary*)dic{
    
    if (index == 1) {
        _L_modelList = [MyFensiModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
    }
    else{
        [_L_modelList addObjectsFromArray:[MyFensiModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
    }
    [self setModel_L_tableView];
}
-(void)updateCtableViewModel:(int)index dic:(NSDictionary*)dic{
    if (index == 1) {
        _C_modelList = [MyFensiModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
    }
    else{
        [_C_modelList addObjectsFromArray:[MyFensiModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
    }
    [self setModel_C_tablevie];
}
-(void)updateRtableViewModel:(int)index dic:(NSDictionary*)dic{
    if (index == 1) {
        _R_modelList = [MyFensiModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
    }
    else{
        [_R_modelList addObjectsFromArray:[MyFensiModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
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
    if (2 == indexType) {
        currentLPage=1;
        [self requestURL:1 withType:KNetworkMyFensi];
    }
    else if (1 == indexType){
        currentCPage=1;
        [self requestURL:1 withType:KNetworkGetGUANZHU];
    }
    else if(3 == indexType){
        currentRPage=1;
        [self requestURL:1 withType:KNetworkGetMyFangwen];
    }
    
}

- (void)loadMoreData
{
    if (2 == indexType) {
        currentLPage += 1;
        [self requestURL:currentLPage withType:KNetworkMyFensi];
    }
    else if (1 == indexType){
        currentCPage += 1;
        [self requestURL:currentCPage withType:KNetworkGetGUANZHU];
    }
    else if(3 == indexType){
        currentRPage += 1;
        [self requestURL:currentRPage withType:KNetworkGetMyFangwen];
    }
    
}

-(IBAction)BtnSelect:(UIButton *)sender
{
    NSInteger tag=sender.tag/100-1;
    self.m_Scrollview.contentOffset=CGPointMake((winsize.width-2*Margion)*tag, 0);
    
    UIView *topView=[self.view viewWithTag:1000];
    CGFloat lineWidth=topView.frame.size.width/3;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(tag*lineWidth);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];
    if (tag == 0) {
        self.BtnGusts.selected = NO;
        self.BtnFocus.selected = NO;
        self.btnFensi.selected = YES;
        indexType = 1;
    }
    else if (tag == 1){
        self.BtnGusts.selected = NO;
        self.BtnFocus.selected = YES;
        self.btnFensi.selected = NO;
        indexType = 2;
    }
    else if (tag == 2){
        self.BtnGusts.selected = YES;
        self.BtnFocus.selected = NO;
        self.btnFensi.selected = NO;
        indexType = 3;
    }
    if(_L_modelList == nil){
        [self.L_tableview.mj_header beginRefreshing];
    }
    if(_C_modelList == nil){
        [self.C_tableview.mj_header beginRefreshing];
    }
    if(_R_modelList == nil){
        [self.R_tableview.mj_header beginRefreshing];
    }
    if (tag==2) {
        [self kg_hidden:NO];
    }
    else{
        [self kg_hidden:YES];
    }
}

-(UIView *)line
{
    if (!_line)
    {
        _line=[UIView new];
        UIView *topView=[self.view viewWithTag:1000];
        CGFloat lineWidth=topView.frame.size.width/3;
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
        _m_Scrollview.contentSize=CGSizeMake(winsize.width*3-6*Margion, 0);
        _m_Scrollview.pagingEnabled=YES;
        _m_Scrollview.delegate=self;
        _m_Scrollview.showsHorizontalScrollIndicator=NO;
    }
    return _m_Scrollview;
}

-(UIView *)myfensiHeaderView
{
    if (!_myfensiHeaderView){
        _myfensiHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, 110)];
        _myfensiHeaderView.backgroundColor = [UIColor whiteColor];
        UIImageView * imgHeadView= [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 70, 70)];
        imgHeadView.layer.masksToBounds = YES;
        imgHeadView.contentMode = UIViewContentModeScaleAspectFit;
        imgHeadView.image = [UIImage imageNamed:@"wendaimg"];
        
        UIView* separatorView = [[UIView alloc]init];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        separatorView.alpha = 0.6;
        
        UILabel *labTitle = [[UILabel alloc]init];
        labTitle.text = @"我的问答";
        labTitle.font = [UIFont systemFontOfSize:17];
        
        [_myfensiHeaderView sd_addSubviews:@[imgHeadView,labTitle,separatorView]];
        
        separatorView.sd_layout.leftSpaceToView(_myfensiHeaderView, 20).heightIs(0.5).rightSpaceToView(_myfensiHeaderView, 0).bottomSpaceToView(_myfensiHeaderView, 2);
        
        labTitle.sd_layout.leftSpaceToView(imgHeadView, 20).widthIs(80).heightIs(30).centerYEqualToView(_myfensiHeaderView);
        
        [_myfensiHeaderView wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self myfensiHeaderViewClick];
        }];
    }
    return _myfensiHeaderView;
}

-(void)myfensiHeaderViewClick{
    NSLog(@"myfensiHeaderViewClicked");
}


-(UITableView *)L_tableview
{
    if (!_L_tableview)
    {
        _L_tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_L_tableview];
        _L_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        _L_tableview.tableHeaderView = self.myfensiHeaderView;
        [_L_tableview mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.height.width.equalTo(self.m_Scrollview);
            make.left.mas_equalTo(0);
        }];
        [self setupRefresh:_L_tableview ];
       
        [_L_tableview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)]];
    }
    return _L_tableview;
}
-(void)setModel_L_tableView{
    [self.L_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([fensiTableViewCell class])
            .data(_L_modelList)
            .adapter(^(fensiTableViewCell * cell,NSDictionary * data,NSUInteger index)
                     {
                         cell.model = _L_modelList[index];
                     })
            .height(100);
        }];
    }];
}
///添加关注
- (IBAction)btnAddGuanzhuClick:(id)sender {
    MyFensiController *fensiCol = [MyFensiController new];
    fensiCol.isShowBtnAttention = YES;
    [self.navigationController pushViewController:fensiCol animated:YES ];
}

-(void)hiddenKeyBoard
{
    DismissKeyboard;
}

-(UITableView *)C_tableview
{
    if (!_C_tableview)
    {
        _C_tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_C_tableview];
        _C_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_C_tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.height.width.equalTo(self.m_Scrollview);
             make.left.equalTo(self.L_tableview.mas_right);
         }];
        [self setupRefresh:_C_tableview ];
        
    }
    return _C_tableview;
}
-(void)setModel_C_tablevie{
    [self.C_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([fensiTableViewCell class])
            .data(_C_modelList)
            .adapter(^(fensiTableViewCell * cell,NSDictionary * data,NSUInteger index)
                     {
                         cell.model = _C_modelList[index];
                     })
            .height(100);
        }];
    }];
}

-(UITableView *)R_tableview
{
    if (!_R_tableview)
    {
        _R_tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.m_Scrollview addSubview:_R_tableview];
        _R_tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_R_tableview mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.height.width.equalTo(self.m_Scrollview);
             make.left.equalTo(self.C_tableview.mas_right);
         }];
        [self setupRefresh:_R_tableview ];
        
    }

    return _R_tableview;
}
-(void)setModel_R_tablevie{
    [self.R_tableview cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section) {
            section.cell([fensiTableViewCell class])
            .data(_R_modelList)
            .adapter(^(fensiTableViewCell * cell,NSDictionary * data,NSUInteger index)
                     {
                         cell.model = _R_modelList[index];
                     })
            .height(100);
        }];
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (NSInteger) (offsetX/(winsize.width-2*Margion));
    NSLog(@"-index=%zi",index);
    UIView *topView=[self.view viewWithTag:1000];
    CGFloat lineWidth=topView.frame.size.width/3;
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(index *lineWidth);
    }];
    [UIView animateWithDuration:0.35 animations:^{
        [topView layoutIfNeeded];
    }];
    if (index==0) {
        [self BtnSelect:self.btnFensi];
        //[self kg_hidden:NO];
    }
    else if (index == 1){
        [self BtnSelect:self.BtnFocus];
    }
    else{
        [self BtnSelect:self.BtnGusts];
    }
}

@end
