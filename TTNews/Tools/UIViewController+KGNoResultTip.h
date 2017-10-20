//
//  UIViewController+KGNoResultTip.h
//  kindergarten
//
//  Created by 王小军 on 15/3/20.
//  Copyright (c) 2015年 wxj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  统一处理空白页面提示
 */
@interface UIViewController (KGNoResultTip)

- (void)kg_hidden:(BOOL)hidden;
- (void)kg_setMessage:(NSString *)message;
- (void)kg_setImage:(UIImage *)image;
- (void)kg_setMessage:(NSString *)message withImage:(UIImage *)image;

@end
