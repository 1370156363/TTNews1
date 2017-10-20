//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import <UIKit/UIkit.h>

@class CBDataSourceSection;

@protocol CBBaseTableViewDataSourceProtocol<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) NSMutableArray<CBDataSourceSection * > * sections;
@property(nonatomic, strong) NSMutableDictionary * delegates;
@end

typedef void (^AdapterBlock)(id cell,id data,NSUInteger index);
typedef void (^EventBlock)(NSUInteger index,id data);

@class CBDataSourceSection;

@interface CBBaseTableViewDataSource : NSObject <CBBaseTableViewDataSourceProtocol>

@property(nonatomic, strong) NSMutableArray<CBDataSourceSection * > * sections;

@end

@interface CBSampleTableViewDataSource: CBBaseTableViewDataSource

@end
