//
//  OWTool.h
//  SmartPartyBuilding
//
//  Created by 王卫华 on 2017/5/17.
//  Copyright © 2017年 王卫华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWTool : NSObject

+(OWTool *) Instance;


/**是否首次安装*/
-(void)SaveStateofInstall:(NSString *)a;
-(NSString *)getStateofInstall;
/** 用户信息*/
-(void)setUserInfo:(NSDictionary*)userInfo;
-(NSDictionary*)getUserInfo;
/** 用户id*/
-(void)saveUid:(NSString *)a;
-(NSString *)getUid;
///获取环信账号
- (NSString *)getLastLoginUsername;
//修改环信账号
-(void)setHuanXin:(NSString *)username;

@end
