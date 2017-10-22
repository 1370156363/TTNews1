//
//  TTTabBarController.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/3/25.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "TTTabBarController.h"
#import "TTNavigationController.h"
#import "NewsViewController.h"
#import "PictureViewController.h"
#import "VideoViewController.h"
#import "MyController.h"
#import "WendaViewController.h"
#import "dongtaiController.h"
#import "TTConst.h"
#import <DKNightVersion.h>
#import <SDImageCache.h>

#import "NewWenDaViewController.h"
#import "NewDongTaiViewController.h"

@interface TTTabBarController ()<MeTableViewControllerDelegate>
{
    MyController *_MeController;
}
@property (nonatomic, assign) BOOL isShakeCanChangeSkin;

@end

@implementation TTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NewsViewController *vc1 = [[NewsViewController alloc] init];
    [self addChildViewController:vc1 withImage:[UIImage imageNamed:@"shouye"] selectedImage:[UIImage imageNamed:@"shouyeXZ"] withTittle:@"首页"];
    
    VideoViewController *vc3 = [[VideoViewController alloc] init];
    [self addChildViewController:vc3 withImage:[UIImage imageNamed:@"shipin"] selectedImage:[UIImage imageNamed:@"shipinXZ"] withTittle:@"视频"];

//    WendaViewController *wendaVc=[[WendaViewController alloc] init];
    NewWenDaViewController *wendaVc=[[NewWenDaViewController alloc] initWithNibName:@"NewWenDaViewController" bundle:nil];
    [self addChildViewController:wendaVc withImage:[UIImage imageNamed:@"wenda"] selectedImage:[UIImage imageNamed:@"wendaXZ"] withTittle:@"问答"];

    
//    dongtaiController *dongtaiVc=[[dongtaiController alloc] init];
    NewDongTaiViewController *dongtaiVc=[[NewDongTaiViewController alloc] initWithNibName:@"NewDongTaiViewController" bundle:nil];
    [self addChildViewController:dongtaiVc withImage:[UIImage imageNamed:@"dongtai"] selectedImage:[UIImage imageNamed:@"dongtaiXZ"] withTittle:@"动态"];
    

    
    MyController *vc4 = [[MyController alloc] init];
    _MeController = vc4;
    [self addChildViewController:vc4 withImage:[UIImage imageNamed:@"geren"] selectedImage:[UIImage imageNamed:@"gerenxz"] withTittle:@"我的"];
    vc4.delegate = self;
    
    [self setupBasic];
}

-(void)setupBasic {
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {
        self.tabBar.barTintColor = [UIColor whiteColor];
    } else {
        self.tabBar.barTintColor = navColor;
    }

    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    self.isShakeCanChangeSkin = [[NSUserDefaults standardUserDefaults] boolForKey:IsShakeCanChangeSkinKey];
}

-(void)dealloc {
    
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        if (self.isShakeCanChangeSkin == NO) return;
        if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNormal]) {//将要切换至夜间模式
//            self.dk_manager.themeVersion = DKThemeVersionNight;                self.tabBar.barTintColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
            self.tabBar.barTintColor = navColor;
            _MeController.changeSkinSwitch.on = YES;
        } else {
                self.dk_manager.themeVersion = DKThemeVersionNormal;             self.tabBar.barTintColor = [UIColor whiteColor];
            _MeController.changeSkinSwitch.on = NO;

        }
    }
}

- (void)addChildViewController:(UIViewController *)controller withImage:(UIImage *)image selectedImage:(UIImage *)selectImage withTittle:(NSString *)tittle{
    TTNavigationController *nav = [[TTNavigationController alloc] initWithRootViewController:controller];
    
    [nav.tabBarItem setImage:image];
    [nav.tabBarItem setSelectedImage:selectImage];
//    nav.tabBarItem.title = tittle;
//    controller.navigationItem.title = tittle;
    controller.title = tittle;//这句代码相当于上面两句代码
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    [self addChildViewController:nav];
}

-(void)shakeCanChangeSkin:(BOOL)status {
    self.isShakeCanChangeSkin = status;
}

-(void)didReceiveMemoryWarning {
    [[SDImageCache sharedImageCache] clearDisk];

}
@end
