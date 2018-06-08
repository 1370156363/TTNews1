//
//  AppDelegate.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/24.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ApplyViewController.h"
#import "TTTabBarController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,EMChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TTTabBarController *mainController;


@end

