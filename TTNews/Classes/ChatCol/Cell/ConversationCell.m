//
//  YCBaseTableViewCell.m
//  TTNews
//
//  Created by 薛立强 on 2018/3/6.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "ConversationCell.h"

@implementation ConversationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupView];  
    }
    
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    _imgHeader = [[EaseImageView alloc] init];
    _imgHeader.frame = CGRectMake(10, 5, 40, 40);
    [self addSubview:_imgHeader];
    
    _labName = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 250, 20)];
    _labName.textColor = [UIColor blackColor];
    _labName.textAlignment = NSTextAlignmentLeft;
    _labName.font = [UIFont systemFontOfSize:17.0];
    
    [self addSubview:_labName];
    
    _labMsg = [[UILabel alloc]initWithFrame:CGRectMake(55, 25, 250, 20)];
    _labName.textColor = [UIColor grayColor];
    _labName.textAlignment = NSTextAlignmentLeft;
    _labName.font = [UIFont systemFontOfSize:17.0];
    
    [self addSubview:_labMsg];
    
    _labTime = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 5, 250, 20)];
    _labName.textColor = [UIColor grayColor];
    _labName.textAlignment = NSTextAlignmentLeft;
    _labName.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:_labTime];
}

- (void)setDictInfo:(NSDictionary *)dictInfo
{
    
}
@end
