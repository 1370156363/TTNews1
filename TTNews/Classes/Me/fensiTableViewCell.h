//
//  fensiTableViewCell.h
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFensiModel.h"

@interface fensiTableViewCell : UITableViewCell
/** @brief 关注按钮是否显示*/
@property (nonatomic, assign) BOOL isShowBtnAttention;

@property (nonatomic, strong) MyFensiModel *model;

@end
