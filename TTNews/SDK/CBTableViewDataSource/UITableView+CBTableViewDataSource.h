
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.

#import <UIKit/UIKit.h>

@class CBBaseTableViewDataSource;
@class CBTableViewDataSourceMaker;

@interface UITableView (CBTableViewDataSource)

@property(nonatomic, strong) CBBaseTableViewDataSource * cbTableViewDataSource;

- (void)cb_makeDataSource:(void (^)(CBTableViewDataSourceMaker * make))maker;
- (void)cb_makeSectionWithData:(NSArray *)data;
- (void)cb_makeSectionWithData:(NSArray *)data andCellClass:(Class)cellClass;

@end

__attribute__((unused)) static void commitEditing(id self, SEL cmd, UITableView * tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath * indexPath);

__attribute__((unused)) static void scrollViewDidScroll(id self, SEL cmd, UIScrollView * scrollView);
