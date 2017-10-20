//
//  KGTableviewCellModel.h
//  Aerospace
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGTableviewCellModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *rightTitle; //显示在右边
@property (assign, nonatomic) BOOL isBadge;       //是否需要在右边显示小红点
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *imageName;  //左边图标名字
@property (copy, nonatomic) NSString *imageForRightName;
@property (strong, nonatomic) UIColor *color;
@property (copy, nonatomic) NSString *viewControllerClassName;
@property (strong, nonatomic) UIImage *image;


@end
