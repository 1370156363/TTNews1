//
//  OWTool.m
//  SmartPartyBuilding
//
//  Created by 王卫华 on 2017/5/17.
//  Copyright © 2017年 王卫华. All rights reserved.
//


#import <CommonCrypto/CommonDigest.h>
#import <SVProgressHUD.h>
#import "OWTool.h"

NSString *const UserAct = @"userAct";
NSString *const Token = @"token";
NSString *const UserInfo = @"userInfo";

@implementation OWTool

+ (void)SVProgressHUD
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
//    [SVProgressHUD setMaxSupportedWindowLevel:2];
    [SVProgressHUD setMinimumSize:CGSizeMake(110, 110)];
}

static OWTool * instance = nil;
+(OWTool *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

-(void)SaveStateofInstall:(NSString *)a
{
    NSUserDefaults *personInformation = [NSUserDefaults standardUserDefaults];
    [personInformation removeObjectForKey:@"firstLaunch"];
    [personInformation setObject:a forKey:@"firstLaunch"];
    [personInformation synchronize];
}

-(NSString *)getStateofInstall
{
    NSUserDefaults *personInformation = [NSUserDefaults standardUserDefaults];
    return [personInformation objectForKey:@"firstLaunch"];
}

-(void)setUserInfo:(NSDictionary *)userInfo{
    // 将用户信息存入数组或者字典中
    // 持久化操作者
    NSUserDefaults *userInfo1 = [NSUserDefaults standardUserDefaults];
    [userInfo1 removeObjectForKey:@"userInfo"];
    // 操作者将包含用户信息的数组arr持久化
    [userInfo1 setObject:userInfo forKey:@"userInfo"];
    [userInfo1 synchronize];
}
-(NSDictionary*)getUserInfo{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    return [userInfo objectForKey:@"userInfo"];
}

-(void)saveUid:(NSString *)a
{
    NSUserDefaults *personInformation = [NSUserDefaults standardUserDefaults];
    [personInformation removeObjectForKey:@"userUid"];
    [personInformation setObject:a forKey:@"userUid"];
    [personInformation synchronize];
}

-(NSString *)getUid
{
    NSUserDefaults *personInformation = [NSUserDefaults standardUserDefaults];
    return [NSString stringWithFormat:@"%d",[[personInformation objectForKey:@"userUid"] intValue]] ;
}
@end
