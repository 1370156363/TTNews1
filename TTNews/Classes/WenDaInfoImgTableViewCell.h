//
//  WenDaInfoImgTableViewCell.h
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WendaModel.h"



@interface WenDaInfoImgTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImage *Image;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property(strong,nonatomic)NSString *url;

@end
