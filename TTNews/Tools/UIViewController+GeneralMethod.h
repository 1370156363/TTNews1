//
//  UIViewController+ViewControllerGeneralMethod.h
//  Golf
//
//  Created by Blankwonder on 6/4/13.
//  Copyright (c) 2013 Suixing Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GeneralMethod)

- (void)popViewController;
- (void)popToRootViewController;
- (void)dismissViewController;

- (void)setBackBarButtonWithSelector:(SEL)selector;
- (void)setBackBarButtonWithTitleAndSelector:(SEL)selector andTitle:(NSString *)title;
- (void)setDoneBarButtonWithSelector:(SEL)selector andTitle:(NSString *)title;
- (void)setRightItemBarButtonWithSelector:(SEL)selector andImgName:(NSString *)img;

@end
