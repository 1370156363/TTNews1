//
//  KGLogController.h
//  Aerospace
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface GLBannerView : UIView<UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame andImages:(NSArray*)imgs;

@property(nonatomic,copy)void (^enterBlock)();

@end
