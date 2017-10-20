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
    return [personInformation objectForKey:@"userUid"];
}
@end
