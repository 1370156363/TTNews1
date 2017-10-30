//
//  KGDynamicTableViewCell.h
//  TTNews
//
//  Created by 薛立强 on 2017/10/27.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DymamicModel.h"

@interface KGDynamicTableViewCell : UITableViewCell
//数据模型
@property (nonatomic,strong) DymamicModel   * model;

@end
