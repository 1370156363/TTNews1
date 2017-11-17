//
//  LoginController.h
//  TTNews
//
//  Created by 王迪 on 2017/9/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LoginController : UIViewController

///type为1的时候是从login登录
@property(nonatomic,assign)NSInteger type;

@property (nonatomic, copy)void(^LoginSuccessBlock)();

@property (strong, nonatomic) UIWindow *window;
@end
