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

static NSMutableArray *tasks;


+(NSMutableArray *)tasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        DLog(@"创建数组");
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

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
        case KNetWorkYzmLogin:
            actionValue=@"api/login/index";
            break;
        case KNetWorkgetVideolist:
            actionValue=@"api/user/get_mypinglun";
            break;

        case kNetWorkActionRegister:
            ///注册
            actionValue = @"api/login/reg";
            break;
        
        case KNetworkWenAddDongTai:
            actionValue=@"api/user/adddt";
            break;
        case KNetworkWenAddWenDa:
            actionValue=@"api/user/addanswer";
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
        case KNetworkWenAddWenDaComment:
            actionValue=@"api/content/addawpinglun/";
            break;
        case KNetworkADDDongTaiComment:
            actionValue=@"api/content/adddtpinglun/";
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
        case KNetworkmyDynamic:
            actionValue = @"api/user/mydynamiclists";
            break;
        case KNetWorkYzmAction:
            //获取验证码
            actionValue=@"api/content/get_mobileverify.html";
            break;
        case KNetWorkYzmLogin:
            actionValue=@"api/login/index";
            break;
        case KNetWorkgetVideolist:
            actionValue=@"api/content/shipinlists/id/1/page/1";
            break;
        case KNetworkWenDaContent:
        {
            actionValue=@"api/content/answerlists/";
//            actionValue=[NSString stringWithFormat:@"api/content/answerlists/page/%@",[params objectForKey:@"page"]];
//            params = [[NSMutableDictionary alloc] initWithCapacity:2];

        }
            break;
        case KNetworkWenDaComment:
        {
             actionValue=@"api/content/answerpinglun/";
        }
            break;
        case KNetworkGetUser:
        {
            actionValue=@"api/user/tuijianuser/";
        }
            break;
        case KNetworkMyFensi:
            actionValue=@"api/user/get_myfensi";
            break;
        case KNetworkGetGUANZHU:
        {
            actionValue=@"api/user/get_myguanzhu/";
        }
            break;
        case KNetworkAddGUANZHU:{
            ///添加关注
            actionValue=@"api/user/addfriend";
        }
            break;
        case KNetworkDelGuanZhu:{
            ///删除关注:
            actionValue=@"api/user/delfriend";
        }
            break;
        case KNetworkDongTaiComment:{
            ///
            actionValue=@"api/content/dtpinglun/";
        }
            break;
        case KNetworkGetCategory:
        {
            actionValue=@"api/index/get_category";
        }
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

#pragma mark 上传照片
///上传照片接口
+(void)uploadImageWithArray:(NSMutableArray *)imageArray parameter:(NSDictionary *)parameter success:(void(^)(id response)) success fail:(void(^) (NSError *error))fail
{
    //    [SVProgressHUD show];

    UIImage *image = imageArray[0];
    //组合成url
    NSString *url=[NSString stringWithFormat:@"%@/index/upload/upload.html",kNewWordBaseURLString];
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    parameter=[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"flash",@"service",@"fileType",@"images",@"filename", nil];

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval=15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];


    NSURLSessionTask *sessionTask=[manager POST:urlStr parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        ///压缩图片
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        //制定名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *name = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName=[NSString stringWithFormat:@"%@.jpg", name];

        if(imageData){
            [formData appendPartWithFileData:imageData name:@"file" fileName:imageFileName mimeType:@"image/jpeg"];
        }
        // 上传图片，以文件流的格式
        //        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:@"image/jpeg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {

        //        typedef void( ^ LXUploadProgress)(int64_t bytesProgress,
        //                                          int64_t totalBytesProgress);
        //
        //        typedef void( ^ LXDownloadProgress)(int64_t bytesProgress,
        //                                            int64_t totalBytesProgress);
        //        DLog(@"上传进度--%lld,总进度---%lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        //        if (progress) {
        //            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        //        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传图片成功=%@",responseObject);
        //        [SVProgressHUD dismiss];
        if (success) {
            success(responseObject);
        }

        [[self tasks] removeObject:sessionTask];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if (fail) {
            fail(error);
            //            [SVProgressHUD dismiss];

        }

        [[self tasks] removeObject:sessionTask];
    }];

    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }


    [sessionTask resume];

}

///修改编码
+(NSString *)strUTF8Encoding:(NSString *)str{
    //return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
