//
//  DongTaiTableViewCell.h
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DongtaiModel.h"

@interface DongTaiTableViewCell : UITableViewCell

@property (nonatomic, strong)DongtaiModel  *model;

@property (nonatomic, assign)NSInteger row;


@end
