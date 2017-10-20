//
//  CommentCell.m
//  TTNews
//
//  Created by 王迪 on 2017/9/22.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self=[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil][0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
