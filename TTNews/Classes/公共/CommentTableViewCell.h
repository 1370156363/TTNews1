//
//  CommentTableViewCell.h
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WenDaComment.h"
#import "DongtaiModel.h"


@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commentImg;
///题目
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
///内容
@property (weak, nonatomic) IBOutlet UILabel *contentlab;
///时间
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic,strong)WenDaComment *comment;
@property(nonatomic,strong)DongtaiModel *dongtai;

@end
