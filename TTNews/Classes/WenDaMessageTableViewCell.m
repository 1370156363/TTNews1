//
//  WenDaMessageTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "WenDaMessageTableViewCell.h"

@implementation WenDaMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

///问答
-(void)setComment:(WendaModel *)comment{

    CGSize constraint = CGSizeMake(winsize.width-30, 20000.0f);
    CGSize size = [comment.des sizeWithFont:[UIFont systemFontOfSize:15]
                            constrainedToSize:constraint
                                lineBreakMode:1];

    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:comment.des attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];

    CGRect rect=[attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];

    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(rect.size.height);
     }];

    self.titleLab.text=comment.des;
}

-(void)setDongtai:(DongtaiModel *)dongtai{
    CGSize constraint = CGSizeMake(winsize.width-30, 20000.0f);

    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:dongtai.desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];

    CGRect rect=[attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];

    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(rect.size.height);
     }];

    self.titleLab.text=dongtai.desc;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
