//
//  ImageTableCell.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/10.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitleName;
@property (weak, nonatomic) IBOutlet UILabel *labDetailText;

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@property (nonatomic, assign) int  aproveImgId;
@end
