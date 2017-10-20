//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -- Class CBDataSourceSectionMaker
@class CBDataSourceSection;

@interface CBTableViewSectionMaker : NSObject

- (CBTableViewSectionMaker * (^)(Class))cell;

- (CBTableViewSectionMaker * (^)(NSArray *))data;

- (CBTableViewSectionMaker * (^)(void(^)(id cell, id data, NSUInteger index)))adapter;

- (CBTableViewSectionMaker * (^)(CGFloat))height;

- (CBTableViewSectionMaker * (^)())autoHeight;

- (CBTableViewSectionMaker * (^)(void(^)(NSUInteger index, id data)))event;

- (CBTableViewSectionMaker * (^)(NSString *))headerTitle;
- (CBTableViewSectionMaker * (^)(NSString *))footerTitle;

- (CBTableViewSectionMaker * (^)(UIView * (^)()))headerView;
- (CBTableViewSectionMaker * (^)(UIView * (^)()))footerView;

@property(nonatomic, strong) CBDataSourceSection * section;

@end
