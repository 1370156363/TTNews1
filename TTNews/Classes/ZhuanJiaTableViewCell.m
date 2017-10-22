//
//  ZhuanJiaTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/22.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ZhuanJiaTableViewCell.h"

@implementation ZhuanJiaTableViewCell

-(void)layoutSubviews{
    [super layoutSubviews];
    self.iconimage.layer.cornerRadius=self.iconimage.wh_height/2;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
