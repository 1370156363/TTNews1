//
//  SettingController.h
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingController : UIViewController

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy) void(^loginOutBlock)();

@end
