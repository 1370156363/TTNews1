//
//  WenDaTableViewCell.h
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WenDaTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *oneTitleLab;
@property (strong, nonatomic) IBOutlet UIImageView *oneImg;
@property (strong, nonatomic) IBOutlet UILabel *countLab;

///2个模式
@property (weak, nonatomic) IBOutlet UILabel *twotitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imag1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *twoCountLab;



@end
