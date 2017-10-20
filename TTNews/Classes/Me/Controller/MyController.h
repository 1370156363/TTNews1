//
//  MyController.h
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeTableViewControllerDelegate <NSObject>
@optional
- (void)shakeCanChangeSkin:(BOOL)status;

@end


@interface MyController : UIViewController
@property(nonatomic, weak) id<MeTableViewControllerDelegate> delegate;
@property (nonatomic, weak) UISwitch *changeSkinSwitch;
@end
