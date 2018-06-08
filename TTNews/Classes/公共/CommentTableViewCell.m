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
    [self setupview];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil][0];
    }
    return self;
}

-(void)setupview{
    
    
    self.commentImg.contentMode = UIViewContentModeScaleAspectFit;
    self.commentImg.clipsToBounds = YES;
    
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}

-(void) updateConstraints{
    [super updateConstraints];
    
    float margin = 5;
    
//    self.commentImg.sd_layout
//    .topSpaceToView(self.contentView, margin)
//    .leftSpaceToView(self.contentView, margin)
//    .heightIs(60)
//    .widthIs(60);
    
    self.titlelab.sd_layout
    .leftSpaceToView(self.commentImg, 2*margin)
    .topSpaceToView(self.contentView, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    
    self.contentlab.sd_layout
    .leftSpaceToView(self.commentImg, 2*margin)
    .topSpaceToView(self.titlelab, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    [self.contentlab setMaxNumberOfLinesToShow:5];
    
    
    self.timeLab.sd_layout
    .topSpaceToView(self.contentlab, margin)
    .leftSpaceToView(self.commentImg, 2*margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.timeLab bottomMargin:10];
}

-(void)setComment:(WenDaComment *)comment{

    _comment = comment;
    self.titlelab.text=(comment.nicheng && comment.nicheng.length > 0)?comment.nicheng:@"匿名用户";
    [self.commentImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,comment.avatar]] placeholderImage:[UIImage imageNamed:@"gerenxz"]];
    self.timeLab.text=comment.create_time;
    
    self.contentlab.text=comment.title;

}

-(void)setDongtai:(DongtaiModel *)dongtai{

    self.titlelab.text=dongtai.nicheng;
    [self.commentImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,dongtai.avatar]]];
    self.timeLab.text=dongtai.create_time;
   
    self.contentlab.text=dongtai.title;

}

@end
