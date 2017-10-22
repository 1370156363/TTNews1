//
//  WenDaMessageTableViewCell.h
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WendaModel.h"

#import "DongtaiModel.h"

@interface WenDaMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

///
@property (nonatomic, strong)WendaModel  *comment;

@property (nonatomic,strong)DongtaiModel *dongtai;
@end
