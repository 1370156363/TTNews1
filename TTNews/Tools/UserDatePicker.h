//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//


#import <UIKit/UIKit.h>

/**
 日期选择器
 */

@interface UserDatePicker : UIView

@property(nonatomic, copy) void (^UserDateBlock)(UserDatePicker *picker, NSString *date, NSString *udate);

+ (UserDatePicker*)UserDatePicker;

- (void)setTitle:(NSString*)title;

@end
