//
//  TTTabBarController.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewWenDaViewController.h"
#import "NewDongTaiViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface TTTabBarController : UITabBarController
@property (nonatomic,strong) NewWenDaViewController *wendaVc;
@property (nonatomic, strong)NewDongTaiViewController* dongtaiVc;


- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;

@end
