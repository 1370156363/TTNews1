//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBTableViewDataSource.h"

@interface CBDataSourceSection : NSObject

@property(nonatomic, strong) NSArray * data;
@property(nonatomic, strong) Class cell;
@property(nonatomic, strong) NSString * identifier;
@property(nonatomic, copy) AdapterBlock adapter;
@property(nonatomic, copy) EventBlock event;
@property(nonatomic, strong) NSString * headerTitle;
@property(nonatomic, strong) NSString * footerTitle;
@property(nonatomic, strong) UIView * headerView;
@property(nonatomic, strong) UIView * footerView;
@property(nonatomic, assign) BOOL isAutoHeight;
@property(nonatomic, assign) CGFloat staticHeight;

@property(nonatomic, assign) UITableViewCellStyle tableViewCellStyle;
@end
