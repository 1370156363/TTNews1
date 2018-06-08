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
    // 超时时间
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    // 个人建议还是自己解析的比较好，有时接口返回的数据不合格会报3840错误，大致是AFN无法解析返回来的数据
    return manager;
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
//
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
//    return manager;
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
        case kNetWorkActionChangePassword:
            actionValue = @"api/login/editpw";
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
            actionValue=@"api/login/forgetpassword";
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
            actionValue=@"api/content/lists";
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
        case KNetworkMyApprove:
            actionValue= @"api/user/myrenzhengstatus";
            break;
        case KnetworkApplyApprove:
            actionValue = @"api/content/addrenzheng";
            break;
        case KnetworkAddPingLun:
            actionValue=@"api/content/addpinglun";
            break;
        case KnetworkAddcollect:
            actionValue=@"api/content/addcollect";
            break;
        case KnetworkAdduserAction:
            actionValue=@"api/content/adduseraction";
            break;
        case KNetworkSearch:
<<<<<<< HEAD
            actionValue=@"api/content/searcharticle";
            break;
        case KNetworkSearchQuesion:
            actionValue=@"index/search/searchAnswer";
            break;
        case KNetworkMySign:
            ///我的签名
            actionValue = @"api/user/qianming";
            break;
        case kNetWorkIsOnFocuseLike:
            actionValue = @"api/user/isfocuselike";
            break;
        case KNetworkAddGUANZHU:
            ///添加关注
            actionValue=@"api/user/addfriend";
            break;
        case KNetworkAddIQuestionNivite:
            actionValue=@"api/index/answerYaoqing";
            break;
        case KNetworkAddQuestionGuanzhu:
            actionValue=@"api/index/addguanzhu";
            break;
        case NNetworkUpdateUserInfo:
            actionValue=@"api/user/editmyinfo";
            break;
        case NNetworkUpdateUserAvatar:
            actionValue = @"api/user/avatar";
            break;
            break;
        case KNetworkDelGuanZhu:
            ///删除关注:
            actionValue=@"api/user/delfriend";
            break;
            
        case KNetWorkMyCollection:
            actionValue=@"api/index/getCollect";
            break;
        case KNetWorkMyHistory:
            actionValue = @"api/index/readHistory";
=======
            actionValue=@"api/content/search";
>>>>>>> 0675c265b492e4da721e3ffcadba42cbdbedfa57
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
            actionValue=@"api/sms/sendsms";
            break;
        case KNetWorkYzmLogin:
            actionValue=@"api/login/index";
            break;
        case KNetWorkgetVideolist:
            actionValue=@"api/content/shipinlists/id/1/page/1";
            break;
        case KNetworkAllDynamic:
            actionValue=@"api/content/dynamiclists";
            break;
        case KNetworGetUserINfo:
            actionValue=@"api/user/get_myinfo";
            break;
        case KNetworkWenDaContent:
        {
            actionValue=@"api/content/answerlists/";
//            actionValue=[NSString stringWithFormat:@"api/content/answerlists/page/%@",[params objectForKey:@"page"]];
//            params = [[NSMutableDictionary alloc] initWithCapacity:2];

        }
            break;
        case KNetworkQuestionAnswerPush:
            actionValue= @"api/index/pushMessage";
            break;
        case KNetworkFavQUestionPush:
            actionValue= @"api/index/pushMessage";
            break;
        case KNetworkWenDaComment:
        {
             actionValue=@"api/content/answerpinglun/";
        }
            break;
        case KNetworkGetUser:
        {
            actionValue=@"api/user/vipuser";
        }
            break;
        case KNetworkSearchUser:
            actionValue = @"api/content/usersearch";
            break;
        case KNetworkMyFensi:
            actionValue=@"api/user/get_myfensi";
            break;
        case KNetworkGetGUANZHU:
        {
            actionValue=@"api/user/get_myguanzhu";
        }
            break;
        case KNetworkGetMyFangwen:
            actionValue=@"api/user/get_myfangwen";
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
        case KNetworkGetMyApprove:
            actionValue=@"api/user/getmyrenzheng";
            break;
        
        case KNetworkGetShoppinglist:
            actionValue = @"api/goods/goodslist";
            break;
        case KNetworkGetShoppingDetail:
            actionValue = @"api/goods/goodsdetail";
            break;
        case KNetworkGetShopAddress:
            actionValue = @"api/goods/address";
            break;
        case kNetworkGetAllAddress:
            actionValue = @"api/goods/get_myaddress";
            break;
        case KNetworkGetDeleteAddress:
            actionValue = @"api/goods/deladdress";
            break;
        case KnetworkGetMyDingdan:
            actionValue = @"api/goods/get_myorder";
            break;
        case KNetworkGetDeleteDingdan:
            actionValue = @"api/goods/delorder";
            break;
        case KNetWorkSearchMyInfo:
        {
            actionValue=@"api/user/searchmyinfo";
            break;
        }
        case KNetworkGetCommnet:
        {
            actionValue=@"api/content/get_pinglun";
        }
            break;
        case KNetworkWendaDetailInfo:
            actionValue = @"api/content/readAnswer";
            break;
        case KThirdJHNetworkGetBook:
            actionValue = @"http://apis.juhe.cn/goodbook/catalog?key=60b128ad78986087bed5c895bc03f342";
        default:
            break;
    }
    if (visible) {
        [SVProgressHUD showWithStatus:@"发送中..."];
    }
    NSLog(@"post parameter == %@",params);
    
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    NSString *urlStr ;
    if (action != KThirdJHNetworkGetBook) {
       urlStr = [[NSString stringWithFormat:@"%@/%@",baseUrl,actionValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else{
        urlStr = actionValue;
    }

    [manager GET:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        [SVProgressHUD dismiss];
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

////检查网络状态
//-(BOOL)checkedNetworkStatus{
//
//    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
//        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)) {
//        return NO;
//    }
//    return YES;
//}

- (void)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
}

#pragma mark 上传照片
///上传照片接口
-(void)uploadImageWithArray:(NSMutableArray *)imageArray parameter:(NSDictionary *)parameter success:(void(^)(id response)) success fail:(void(^) (NSError *error))fail
{
    //    [SVProgressHUD show];

    UIImage *image = imageArray[0];
    //组合成url
    NSString *url=[NSString stringWithFormat:@"%@index/upload/upload.html",kNewWordBaseURLString];
    parameter=[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"flash",@"service",@"fileType",@"images",@"filename", nil];

    AFHTTPSessionManager *manager=[self baseHtppRequest];
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        ///压缩图片
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        //制定名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *name = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName=[NSString stringWithFormat:@"%@.jpg", name];

        if(imageData){
            [formData appendPartWithFileData:imageData name:@"file[]" fileName:imageFileName mimeType:@"image/jpeg"];
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

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if (fail) {
            fail(error);
            //            [SVProgressHUD dismiss];

        }
    }];

}

-(void)POST:(NSString *)URLString
 parameters:(id)parameters
uploadImages:(NSArray <UIImage*>*)uploadImages
 uploadName:(NSString *)uploadName
    success:(HJMNetWorkSuccessBlock)successBlock failure:(HJMFailureBlock)failureBlock visibleHUD:(BOOL)visible
{
    if (visible) {
        [SVProgressHUD showWithStatus:@"发送中..."];
    }
    NSDictionary *parameter=[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"flash",@"service",@"fileType",@"images",@"filename", nil];
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    [manager POST:[NSString stringWithFormat:@"%@index/upload/upload.html",kNewWordBaseURLString] parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i < uploadImages.count; i++) {
            //图片转data
            NSData *data = UIImageJPEGRepresentation(uploadImages[i], 0.3);
            
            //获取当前时间
            NSDate * today = [NSDate date];
            //转换时间格式
            NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
            [df setDateFormat:@"yyyyMMddHHmmss"];
            NSString * curentTimeStr = [df stringFromDate:today];
            
            [formData appendPartWithFileData:data
                                        name:uploadName
                                    fileName:[NSString stringWithFormat:@"%@%d",curentTimeStr,i]
                                    mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [SVProgressHUD dismiss];
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

///修改编码
+(NSString *)strUTF8Encoding:(NSString *)str{
    //return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


@end
