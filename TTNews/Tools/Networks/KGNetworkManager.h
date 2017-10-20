//
//  HJNetworkManager.h
//  kindergarten
//
//  Created by Jun on 14-2-26.
//  Copyright (c) 2014年 WXJ. All rights reserved.
//

//#import "AFHTTPRequestOperationManager.h"
//#import "NetWorkMessage.h"
#import "Reachability.h"
#import <Foundation/Foundation.h>
#import "NetWorkConstants.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>


//请求超时
#define TIMEOUT 50

@interface KGNetworkManager : NSObject

+ (instancetype)sharedInstance;
-(AFHTTPSessionManager *)baseHtppRequest;

///POST请求
- (void)invokeNetWorkAPIWith:(NetWorkAction)action withUserInfo:(NSMutableDictionary *)params success:(HJMNetWorkSuccessBlock)successBlock failure:(HJMFailureBlock)failureBlock visibleHUD:(BOOL)visible;

///GET请求
-(void)GetInvokeNetWorkAPIWith:(NetWorkAction)action withUserInfo:(NSMutableDictionary *)params success:(HJMNetWorkSuccessBlock)successBlock failure:(HJMFailureBlock)failureBlock visibleHUD:(BOOL)visible;

- (BOOL)checkedNetworkStatus;
- (NetworkStatus)networkStatus;

@end
