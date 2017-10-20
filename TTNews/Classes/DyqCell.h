//
//  DyqCell.h
//  meiguan
//
//  Created by 王迪 on 2017/7/18.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DongtaiModel;
@interface DyqCell : UITableViewCell
@property(nonatomic,copy)void (^zanBlock)();
@property(nonatomic,copy)void (^imageTapBlock)(UIImageView *img,DyqCell *cell);
-(void)setUI:(DongtaiModel *)dict;
@end
