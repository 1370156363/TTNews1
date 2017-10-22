//
//  ZhuanJiaTableViewCell.h
//  TTNews
//
//  Created by mac on 2017/10/22.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuanJiaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconimage;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtu;

@end
