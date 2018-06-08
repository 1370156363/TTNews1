/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2016 Hyphenate Inc. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Inc.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Inc.
  */

#import "AddFriendCell.h"

@implementation AddFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    
    _addLabel = [[UILabel alloc] init];
    _addLabel.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0];
    _addLabel.textAlignment = NSTextAlignmentCenter;
    _addLabel.text = NSLocalizedString(@"add", @"Add");
    _addLabel.textColor = [UIColor whiteColor];
    _addLabel.font = [UIFont systemFontOfSize:14.0];
    _addLabel.sd_cornerRadius = @5;
    
    _headView = [[UIImageView alloc] init];
    _headView.sd_cornerRadius = @20;
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.textColor = [UIColor blackColor];
    _contentLab.font = [UIFont systemFontOfSize:17];
    
    [self.contentView sd_addSubviews:@[_addLabel,_headView,_contentLab]];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}

-(void)updateConstraints{
    
    [super updateConstraints];
    
    _headView.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .heightIs(40)
    .widthIs(40);
    
    _addLabel.sd_layout
    .rightSpaceToView(self.contentView, 5)
    .widthIs(50)
    .heightIs(30)
    .centerYEqualToView(_headView);
    
    _contentLab.sd_layout
    .leftSpaceToView(_headView, 5)
    .centerYEqualToView(_headView)
    .heightIs(30)
    .rightSpaceToView(_addLabel, 5);
    
    
    
}




@end
