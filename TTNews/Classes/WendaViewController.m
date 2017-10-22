//
//  WendaViewController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/25.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "WendaViewController.h"
#import "SinglePictureNewsTableViewCell.h"
#import "WendaHeaderView.h"
#import "ZhuanjiaController.h"
#import "tiwenController.h"
#import "MessageCell.h"
#import "WendaModel.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"

#import "KGNetworkManager.h"


@interface WendaViewController ()<UISearchBarDelegate>
{
    NSInteger page;
}

@property (nonatomic, assign) int currentPage;
@property (nonatomic,retain)UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray    *dataListArr;
@end

@implementation WendaViewController

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    if(searchBar.text.length==0||[searchBar.text isEqualToString:@""]||[searchBar.text isKindOfClass:[NSNull class]])
    {

    }
    else
    {

    }
}
#pragma mark -获取问答列表
///获取问答列表
-(void)getContent:(NSString *)page{
//    AFHTTPSessionManager *manager = [[KGNetworkManager sharedInstance] baseHtppRequest];
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"page",page, nil];
    //获取验证码
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworkWenDaContent withUserInfo:dict success:^(id message) {
        [SVProgressHUD dismiss];
//        [];
    } failure:^(NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"网络错误"];
     } visibleHUD:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    page=1;
//    [self getContent:[NSString stringWithFormat:@"%ld",(long)page]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBasic];
    self.dataListArr=[NSMutableArray array];
    [self setupRefresh];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 7, winsize.width-20, 30)];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.barStyle = UIBarMetricsDefault;
    [_searchBar setTranslucent:YES];// 设置是否透明
    self.navigationItem.titleView=_searchBar;
    [self SetLastTableviewMethod];
}

#pragma mark 基本设置
- (void)setupBasic {
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);

    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0xfa5054,0x444444,0xfa5054);
    self.currentPage = 1;

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
    weakSelf(ws);
    [self.tableView cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section)
         {
//             section.data(self.dataListArr)
//             .cell([MessageCell class])
//             .adapter(^(SinglePictureNewsTableViewCell *cell,WendaModel *model,NSUInteger index){
//                 cell.
////                 cell.imageUrl = @"http://cms-bucket.nosdn.127.net/c77db61cf01d4a79bcd9b9f886eb709720170725180734.jpeg";
////                 cell.contentTittle = @"习近平:军队全力以赴全党全国支持 推动国防改革";
////                 cell.desc = @"新华社北京7月25日电中共中央政治局7月24日下午就推进军队规模结构和力量编成改革，重塑中国特色现代军事力量体系进行第四十二次集体学习。中共中央总书记习近平在主";
//             })
//             .headerView(^{
//                 WendaHeaderView *wenView=[[WendaHeaderView alloc] init];
//                 wenView.btnBlock=^(NSInteger tag)
//                 {
//                     //10,20,30
//                     [ws BtnAction:tag];
//                 };
//                         return 0;
//             })
//             .event(^(NSUInteger index, NSString *model){
//
//             })
//             .height(100);


//             section.data(@[@"1",@"2",@"3",@"",@"",@"",@"",@"",@"",@""])
//             .cell([SinglePictureNewsTableViewCell class])
//             .adapter(^(SinglePictureNewsTableViewCell *cell,NSString *model,NSUInteger index)
//                      {
//
//                          cell.imageUrl = @"http://cms-bucket.nosdn.127.net/c77db61cf01d4a79bcd9b9f886eb709720170725180734.jpeg";
//                          cell.contentTittle = @"习近平:军队全力以赴全党全国支持 推动国防改革";
//                          cell.desc = @"新华社北京7月25日电中共中央政治局7月24日下午就推进军队规模结构和力量编成改革，重塑中国特色现代军事力量体系进行第四十二次集体学习。中共中央总书记习近平在主";
//                      })
//             .headerView(^()
//                         {
//                             WendaHeaderView *wenView=[[WendaHeaderView alloc] init];
//                             wenView.btnBlock=^(NSInteger tag)
//                             {
//                                 //10,20,30
//                                 [ws BtnAction:tag];
//                             };
//                             return wenView;
//                         })
//             .event(^(NSUInteger index, NSString *model)
//                    {
//
//                    })
//             .height(100)
//             ;
         }];
    }];
}


#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    self.currentPage=1;
    [self loadList];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//    });
}

- (void)loadMoreData
{
    self.currentPage+=1;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadList];
    });
}

-(void)loadList
{
    
    AFHTTPSessionManager *manager = [[KGNetworkManager sharedInstance] baseHtppRequest];
    NSString *urlStr = [[NSString stringWithFormat:@"%@/%@%d",kNewWordBaseURLString,@"api/content/answerlists/page/",self.currentPage] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray  *_Nullable message)
     {
         if (self.currentPage==1)
         {
             [self.dataListArr removeAllObjects];
         }
         NSMutableArray *newArr=[WendaModel mj_objectArrayWithKeyValuesArray:message];
         [self.dataListArr addObjectsFromArray:newArr];
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

-(void)BtnAction:(NSInteger)tag
{
    if (tag==10)
    {
        tiwenController *tiwenVc=[[tiwenController alloc] init];
        [self.navigationController pushViewController:tiwenVc animated:YES];
    }
    else if (tag==20)
    {
    
    }
    else if (tag==30)
    {
        ZhuanjiaController *zhuanVc=[[ZhuanjiaController alloc] init];
        [self.navigationController pushViewController:zhuanVc animated:YES];
    }
}

@end
