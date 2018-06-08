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
    _comment = comment;
    self.titleLab.text=comment.des;
}

-(void)setDongtai:(DongtaiModel *)dongtai{
//    CGSize constraint = CGSizeMake(winsize.width-30, 20000.0f);
//
//    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:dongtai.desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//
//    CGRect rect=[attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//
//    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make)
//     {
//         make.height.mas_equalTo(rect.size.height);
//     }];
    _dongtai = dongtai;
    self.titleLab.text=dongtai.desc;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"WenDaMessageTableViewCell" owner:self options:nil][0];
        [self setupviews];
    }
    return self;
}

-(void)setupviews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.titleLab.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .topEqualToView(self.contentView)
    .autoHeightRatio(0);
    [self setupAutoHeightWithBottomView:self.titleLab bottomMargin:5];
}

@end
