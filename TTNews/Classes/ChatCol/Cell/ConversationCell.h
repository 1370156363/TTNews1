//
//  YCBaseTableViewCell.h
//  TTNews
//
//  Created by 薛立强 on 2018/3/6.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationCell : UITableViewCell

@property (retain, nonatomic) UILabel *labName;
@property (retain, nonatomic) UILabel *labMsg;
@property (retain, nonatomic) UILabel *labTime;
@property (retain, nonatomic) EaseImageView *imgHeader;

@end
