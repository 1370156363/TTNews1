//
//  CommentTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

///
-(void)setComment:(WenDaComment *)comment{

    self.titlelab.text=comment.nicheng;
    [self.commentImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,comment.avatar]]];
    self.timeLab.text=comment.create_time;
    CGSize constraint = CGSizeMake(winsize.width-59, 20000.0f);

    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:comment.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];

    CGRect rect=[attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];

    [self.contentlab mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(rect.size.height);
     }];
    self.contentlab.text=comment.title;

}

-(void)setDongtai:(DongtaiModel *)dongtai{

    self.titlelab.text=dongtai.nicheng;
    [self.commentImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,dongtai.avatar]]];
    self.timeLab.text=dongtai.create_time;
    CGSize constraint = CGSizeMake(winsize.width-59, 20000.0f);

    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:dongtai.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];

    CGRect rect=[attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];

    [self.contentlab mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(rect.size.height);
     }];
    self.contentlab.text=dongtai.title;

}

@end
