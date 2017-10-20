//
//  HJNetworkManager.m
//  kindergarten
//
//  Created by Jun on 14-2-26.
//  Copyright (c) 2014年 WXJ. All rights reserved.
//

#import "KGNetworkManager.h"
//#import "NSString+XYMethod.h"


@implementation KGNetworkManager

+ (instancetype)sharedInstance {
    static KGNetworkManager *networkManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[self alloc] init];
    });
    
    return networkManager;
}

-(AFHTTPSessionManager *)baseHtppRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    return manager;
}

///POST请求
- (void)invokeNetWorkAPIWith:(NetWorkAction)action withUserInfo:(NSMutableDictionary *)params success:(HJMNetWorkSuccessBlock)successBlock failure:(HJMFailureBlock)failureBlock visibleHUD:(BOOL)visible{
//    NetworkStatus status = [self networkStatus];
//    if (status == NotReachable) {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"没有网络!", nil)];
//        NSError *error ;
//        failureBlock(error);
//        return;
//    }
    if (params == nil) {
        params = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    NSString *actionValue = nil;
    NSString *baseUrl=kNewWordBaseURLString;
    switch (action)
    {
        case kNetWorkActionLogin:
            actionValue = @"api/login/login";
            break;
        case KNetWorkgetVideolist:
            actionValue=@"api/user/get_mypinglun";
            break;
            

            
            
        case KNetWrokGetVersion:
            actionValue=@"api/pubshare/sysVersion/getLatestVersion";
            break;
        case KNetWorkGetuserInfom:
            actionValue=@"api/member/getUserInfo";
            break;
        case KNetWorkResetPassword:
            actionValue=@"api/member/modifyPassword";
            break;
        case KNetWorkGetYZM:
            actionValue=@"api/member/checkMobileAndSend";
            break;
        case KNetworkHongdianCount:
            actionValue=@"api/member/updateUserTag";
            break;
        case KNetWorkUnreadCount:
            actionValue=@"api/cms/accessRecord/getUnReadStatics";
            break;
        case KNetWorkZGGBUnreadCount:
            actionValue=@"api/pb/statics/getUnReadStatics";
            break;
        case KNetworkGetuserBiaoqian:
            actionValue=@"api/member/generateUserTag";
            break;
        case KNetWorkBangdingPhone:
            actionValue=@"api/member/modifyMobile";
            break;
        case KNetWorkGetAllLanMuData:
            actionValue=@"api/cms/channel/getAllChannel";
            break;
        case KNetWorkLanMuData:
            actionValue=@"api/cms/channel/channleListData";
            break;
        case KNetWorkMyCollection:
            actionValue=@"api/pubshare/myCollection/getListJsonData";
            break;
        case KNetWorkZuzhijigou:
            actionValue=@"api/common/getAllOrg";
            break;
        case KNetWorkRelationChange:
            actionValue=@"api/pb/relationChange/save";
            break;
        case KNetWorkRelationChangeRecorder:
            actionValue=@"api/pb/relationChange/getListJsonData";
            break;
        case KNetWorkJiaonaSearch:
            actionValue=@"api/pb/partyFareNotice/getListJsonData";
            break;
        case KNetWorkPersonalzuzhiRelation:
            actionValue=@"api/pb/relationChange/getParty";
            break;
        case KNetWorkGetSingleDetailContent:
            actionValue=@"api/cms/channel/channleContentData";
            break;
        case KNetWorkSexAnalyase:
            actionValue=@"api/pb/statics/getSex";
            break;
        case KNetWorkWenzhangAnalyase:
            actionValue=@"api/pb/statics/getArticle";
            break;
        case KNetWorkDeplomaAnalyase:
            actionValue=@"api/pb/statics/getEducation";
            break;
        case KNetWorkMinzuAnalyase:
            actionValue=@"api/pb/statics/getNation";
            break;
        case KNetWorkAgeAnalyase:
            actionValue=@"api/pb/statics/getAge";
            break;
        case KNetWorkLuntanDangyuanquanAllData:
            actionValue=@"api/pb/tiezi/getAllListJsonData";
            break;
        case KNetWorkshujuzidian:
            actionValue=@"api/common/getAllDicData";
            break;
        case KNetWorkMyjifen:
            actionValue=@"api/console/userScore/getListJsonStaticsDataRecord";
            break;
        case KNetWorkJifenChaxun:
            actionValue=@"api/console/userScore/getListJsonData";
            break;
        case KNetWorkShenpijilu:
            actionValue=@"api/pb/common/getApproveData";
            break;
        case KNetWorkYijianfankui:
            actionValue=@"api/pubshare/suggestions/save";
            break;
        case KNetworkYijianfankuiPhoto:
            actionValue=@"console/pubshare/suggestionsfileUpload/uploadMultiple";
            break;
        case KNetworkCommentContent:
            actionValue=@"api/cms/common/saveChannelComment";
            break;
        case KNetworkGetcommentData:
            actionValue=@"api/cms/common/getChannelCommentData";
            break;
        case KNetworkDianzan:
            actionValue=@"api/cms/common/toDown";
            break;
        case KNetworkzuixinxinde:
            actionValue=@"api/pb/xinde/queryLatest";
            break;
        case KNetworkmyXinde:
            actionValue=@"api/pb/xinde/getListJsonData";
            break;
        case KNetworklearnRecord:
            actionValue=@"api/pb/learnRecord/getLearnStatics";
            break;
        case KNetworkchengjichaxun:
            actionValue=@"api/pubshare/examResult/getListJsonData";
            break;
        case KNetworklearnRecordchaxun:
            actionValue=@"api/pb/learnRecord/getListJsonData";
            break;
        case KNetworkReceiveMsg:
            actionValue=@"api/console/systemMessage/getListJsonData";
            break;
        case KNetworkToupiaoData:
            actionValue=@"api/cms/vote/getByClassify";
            break;
        case KNetworkmyJudjement:
            actionValue=@"api/pb/partyEvaluation/getListJsonData";
            break;
        case KNetworkFabuTiezi:
            actionValue=@"api/pb/tiezi/saveData";
            break;
        case KNetworkgetshijuanContent:
            actionValue=@"api/pubshare/testPaper/getPaperByCode";
            break;
        case KNetworkQunzuInformation:
            actionValue=@"api/pb/chatGroup/getByDept";
            break;
    }
    
    if (visible) {
        [SVProgressHUD showWithStatus:@"发送中..."];
    }
    
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    
    NSString *urlStr = [[NSString stringWithFormat:@"%@%@",baseUrl,actionValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    if (kNetWorkActionLogin!=action)
//    {
//        [params setObject:configEmpty([[OWTool Instance] getUserInfo][@"ticket"]) forKey:@"ticket"];
//    }
    
    NSLog(@"post parameter == %@",params);
    NSLog(@"url=%@",urlStr);
    
    [manager POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (!responseObject) {
             [SVProgressHUD dismiss];
             return;
         }
         
         NSLog(@"response result == %@",responseObject);
         if (successBlock)
         {
             successBlock(responseObject);
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error == %@",error);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

///GET请求
-(void)GetInvokeNetWorkAPIWith:(NetWorkAction)action withUserInfo:(NSMutableDictionary *)params success:(HJMNetWorkSuccessBlock)successBlock failure:(HJMFailureBlock)failureBlock visibleHUD:(BOOL)visible
{
//    NetworkStatus status = [self networkStatus];
//    if (status == NotReachable) {
//        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"没有网络!", nil)];
//        NSError *error ;
//        failureBlock(error);
//        return;
//    }
    if (params == nil) {
        params = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    
    NSString *baseUrl=kNewWordBaseURLString;
    NSString *actionValue = nil;
    switch (action)
    {
        case KNetWorkYzmAction:
            actionValue=@"api/content/get_mobileverify.html";
            break;
        case KNetWorkYzmLogin:
            actionValue=@"api/login/index";
            break;
        case KNetWorkgetVideolist:
            actionValue=@"api/content/shipinlists/id/1/page/1";
            break;
        default:
            break;
    }
    if (visible) {
        [SVProgressHUD showWithStatus:@"发送中..."];
    }
    NSLog(@"post parameter == %@",params);
    
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    NSString *urlStr = [[NSString stringWithFormat:@"%@/%@",baseUrl,actionValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (!responseObject) {
            [SVProgressHUD dismiss];
            return;
        }
        if (successBlock) {
            
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"error == %@",error);
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

#pragma mark - 网络检测

//检查网络状态
-(BOOL)checkedNetworkStatus{
    
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)) {
        return NO;
    }
    return YES;
}

//获取网络类型
- (NetworkStatus)networkStatus{
    
    if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == ReachableViaWiFi) {
        return ReachableViaWiFi;
    }else if([Reachability reachabilityForInternetConnection].currentReachabilityStatus == ReachableViaWWAN){
        return ReachableViaWWAN;
    }else{
        return NotReachable;
    }
}

@end
