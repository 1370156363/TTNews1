//
//  ZoneView.m
//  CircleOfFriendsDisplay
//
//  Created by 李云祥 on 16/9/22.
//  Copyright © 2016年 李云祥. All rights reserved.
//
#import "InputPanel.h"
#import "ZoneView.h"
#import "Masonry.h"
#import "DyqCell.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "IDMPhotoBrowser.h"
#import "DongtaiModel.h"
#import "WebViewController.h"
#define Tag_MyReplySheetShow 0x01
#define Tag_LongPressTextSheetShow 0x02
#define Tag_LongPressPicSheetShow 0x03
#define Tag_CoverViewSheetShow 0x04
#define Tag_LongPressShareUrlShow 0x05
#define Tag_CopyMyReplySheetShow 0x06

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ZoneView()<IDMPhotoBrowserDelegate,LCActionSheetDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *zoneTableView;
@property(nonatomic,strong)NSMutableArray *dynamics;

@property (nonatomic, assign) int currentPage;

@end
@implementation ZoneView

-(instancetype)init
{
    if (self=[super init])
    {
        _dynamics=[NSMutableArray array];
        self.currentPage = 1;
        _zoneTableView = [[UITableView alloc]init];
        _zoneTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_zoneTableView];
        [_zoneTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
        }];
        [_zoneTableView setNeedsLayout];
        [_zoneTableView setNeedsDisplay];
        [self setExtraCellLineHidden:_zoneTableView];
        [self SetLeftTableviewMethod];
        //首页动态的下拉与上拉
        _zoneTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dynamicTableViewheaderRereshing)];
        _zoneTableView.mj_header.automaticallyChangeAlpha = YES;
        [_zoneTableView.mj_header beginRefreshing];
        _zoneTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dynamicTableViewfooterRereshing)];
    }
    
    return self;
}

- (void)dynamicTableViewheaderRereshing
{
    self.currentPage=1;
    [self getNewList];
}
- (void)dynamicTableViewfooterRereshing{
    [self getNewList];
}
- (void)getNewList
{
    AFHTTPSessionManager *manager = [[KGNetworkManager sharedInstance] baseHtppRequest];
    NSString *urlStr = [[NSString stringWithFormat:@"%@/%@%d",kNewWordBaseURLString,@"api/content/dynamiclists/page",self.currentPage] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray  *_Nullable message)
     {
         NSMutableArray *newArr=[DongtaiModel mj_objectArrayWithKeyValuesArray:message];
         if (self.currentPage==1)
         {
             [self.dynamics removeAllObjects];
         }
         [self.dynamics addObjectsFromArray:newArr];
         [self.zoneTableView reloadData];
         [self.zoneTableView.mj_header endRefreshing];
         [self.zoneTableView.mj_footer endRefreshing];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

//- (void)onPressMoreBtnOnDynamicCell:(DynamicCell *)cell{
//    NSIndexPath *path = [_zoneTableView indexPathForCell:cell];
//    NSArray *paths = [[NSArray alloc]initWithObjects:path, nil];
//    [_zoneTableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
//}


-(void)SetLeftTableviewMethod
{
    [_zoneTableView cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
        [make makeSection:^(CBTableViewSectionMaker *section)
         {
             section.data(self.dynamics)
             .cell([DyqCell class])
             .adapter(^(DyqCell *cell,DongtaiModel *model,NSUInteger index)
                      {
                          cell.selectionStyle=UITableViewCellSelectionStyleNone;
                          [cell setUI:model];
                          cell.zanBlock=^(DyqCell *cell)
                          {
                          };
                          cell.imageTapBlock=^(UIImageView *img,DyqCell *cell)
                          {
                          };
                      })
             .event(^(NSUInteger index, DongtaiModel *model)
                    {
                        self.SelectTableRow(model);
                    })
             .autoHeight();
         }];
    }];
}
//
//#pragma mark - tableviewdelegate
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _dynamics.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zoneCell" forIndexPath:indexPath];
//    DongtaiModel *item = _dynamics[indexPath.row];
//    cell.delegate = self;
//    cell.data = item;
//    cell.fd_enforceFrameLayout = YES;
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.SelectTableRow(_dynamics[indexPath.row]);
//}
// 
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DynamicItem *item = [_dynamics objectAtIndex:indexPath.row];
//    
//    //    NSLog(@"indexpath.row=%d",indexPath.row);
//    CGFloat height ;
//    @try {
//        
//       
//        height = [tableView fd_heightForCellWithIdentifier:@"zoneCell" cacheByIndexPath:indexPath configuration:^(DynamicCell *cell) {
//            //         cell = [[DynamicCell alloc]init];
//            cell.fd_enforceFrameLayout = YES;
//            cell.data = item;
//        }];
//        
//        //        height = [tableView fd_heightForCellWithIdentifier:@"zoneCell" configuration:^(id cell) {
//        ////
//        //            DynamicCell * cll =  (DynamicCell *) cell;
//        //            cll.fd_enforceFrameLayout = YES;
//        //                        cll.dynamicPower = _zoneInfo;
//        //                        cll.data = item;
//        ////            (DynamicCell *) view = cell;
//        //        }];
//        
//        
//    } @catch (NSException *exception) {
//        //        NSLog(@"%@",exception.description);
//        
//        height = 150;
//    } @finally {
//        
//    }
//    return height+6;
//}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)onPressShareUrlOnUrl:(NSURL *)url
{
    WebViewController *webViewController = [[WebViewController alloc]init];
    webViewController.url = url;

    [_fVC.navigationController pushViewController:webViewController animated:YES];
}
- (void)onPressImageView:(UIImageView *)imageView onDynamicCell:(DongtaiModel *)cell{
//    DynamicItem *item = cell.data;
////    if (item == nil) {
////        return;
////    }
////    NSMutableArray *imgArray = [NSMutableArray array];
////    [imgArray addObject:item.imgs];
//    
//    NSArray *imgArr=[];
//    NSMutableArray * photoArray = [[NSMutableArray alloc]init];
//    for (int i=0; i<[item.imgs count]; i++) {
//        NSString * FileUrl = item.imgs[i];
//        NSURL * url = [NSURL URLWithString:FileUrl];
//        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
//        [photoArray addObject:photo];
//    }
//    
//    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc]initWithPhotos:photoArray animatedFromView:imageView];
//    browser.doneButtonImage = [UIImage imageNamed:@"图片返回"];
//    [browser setInitialPageIndex:imageView.tag];
//    browser.delegate = self;
//    browser.displayActionButton = YES;
//    browser.displayArrowButton = NO;
//    browser.displayCounterLabel = YES;
////    browser.useWhiteBackgroundColor = YES;
//    browser.actionButtonTitles = @[@"转发到聊天",@"转发到公告",@"收藏",@"保存到手机" ];
//    [_fVC presentViewController:browser animated:YES completion:nil ];
}
//- (void)onLongPressText:(NSString *)text onDynamicCell:(DynamicCell *)cell{
//    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"收藏", @"转发到聊天", @"转发到公告"] redButtonIndex:-1 delegate:self];
//
//    sheet.tag = Tag_LongPressTextSheetShow;
//    [sheet show];
//
//}
//- (void)onLongPressImageView:(UIImageView *)imageView onDynamicCell:(DynamicCell *)cell{
//    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"收藏", @"转发到聊天", @"转发到公告"] redButtonIndex:-1 delegate:self];
//    sheet.userObj = imageView;
//    sheet.userObj2 = cell;
//    sheet.tag = Tag_LongPressPicSheetShow;
//    [sheet show];
//}

#pragma mark - 图片浏览器代理
-(void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index{
    
}

-(void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index{
    
}

-(void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex{
    if(buttonIndex == 0){
        //转发到聊天
        //        [photoBrowser dismissViewControllerAnimated:YES completion:^{
        //            [self didsendToChatWithPicIndex:photoIndex];
        
        
        IDMPhoto *photo = (IDMPhoto *)[photoBrowser photoAtIndex:photoIndex];
        
        
        
        //             Msg *dict = item.msg;
//        F_Photo *fowardPic = [[F_Photo alloc]init];
//        fowardPic.url = [NSString stringWithFormat:@"%@",photo.photoURL];
//        fowardPic.PhotoId = [NSString stringWithFormat:@"%@",photo.picId];
//        
//        
//        [FowardCommonClass FowardTo:chat F_data:fowardPic msgType:fowardTypePhoto currentVC:[self viewController] FowardDic:nil];
//        
//        [photoBrowser closeBroswer];
        //        }];
        
    }else if(buttonIndex == 1){
        //转发到公告
        IDMPhoto *photo = (IDMPhoto *)[photoBrowser photoAtIndex:photoIndex];
        
//        [self transToNoticeWithPicId:[photo.picId integerValue] andUrl:[photo.photoURL absoluteString]];
        [photoBrowser closeBroswer];
    }else if(buttonIndex == 2){
        //收藏
//        IDMPhoto *photo = (IDMPhoto *)[photoBrowser photoAtIndex:photoIndex];
//        [self savePicWithPicId:[photo.picId integerValue]];
    }else if(buttonIndex == 3){
        //保存到手机
//        IDMPhoto *photo = (IDMPhoto *)[photoBrowser photoAtIndex:photoIndex];
//        [self didSaveToPhoneWithImage:[photo getImage]];
    }
}

-(void)didSaveToPhoneWithImage:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    if (error) {
//        [_fVC showErrorHubContent:@"保存失败"];
//    } else {
//        [_fVC showSuccessHubContent:@"已成功保存到相册"];
//    }
}


//- (void)showReplyViewWithCell:(DynamicCell *)cell andLabelView:(UIView *)view{
//    ZoneReplyView *replyView = [self getReplyView];
//    if (_replyView.isShow == YES) {
//        [_replyView.input resignFirstResponder];
//        _replyView.isShow = NO;
//        return;
//    }
//    CGRect frame = replyView.frame;
//    replyView.replyCell = cell;
//    replyView.replyLabelView = view;
//    
//    frame.origin.y = SCREEN_HEIGHT - 46 - 248;
//    replyView.frame = frame;
//    [self addSubview:replyView];
//    [replyView.input becomeFirstResponder];
//}
//- (ZoneReplyView *)getReplyView{
//    if (_replyView == nil) {
//        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ZoneReply" owner:self options:nil];
//        _replyView  = [nib objectAtIndex:0];
//        _replyView.frame = CGRectMake(0, SCREEN_HEIGHT - 46 - 248, SCREEN_WIDTH, 46);
//        _replyView.delegate = self;
//        _replyView.input.delegate=self;
//        _replyView.isShow = NO;
//    }
//    return _replyView;
//}
#pragma mark - cell委托
//- (void)onPressReplyBtnOnDynamicCell:(DynamicCell *)cell{
//    [self showReplyViewWithCell:cell andLabelView:nil];
    
    //
    //    [[InputPanel Inputpanel] setTitle:@"输入联系方式" TextField:textField];
    //    [[InputPanel Inputpanel] setCallBack:^(InputPanel *input, int code) {
    //    }];
//}
#pragma mark - 推送处理

- (void)onReceiveNewDynamic:(NSDictionary *)dic{
    [_zoneTableView.mj_header beginRefreshing];
}

////点赞
//- (void)onPressZanBtnOnDynamicCell:(DynamicCell *)cell
//{
//
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//}

@end
