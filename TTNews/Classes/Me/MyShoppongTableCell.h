//
//  MyShoppongTableCell.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShoppongTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgShopView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnOperate;
@property (weak, nonatomic) IBOutlet UILabel *labDingdanState;
@property (weak, nonatomic) IBOutlet UIButton *btnDeletaDingdan;

@property (nonatomic, copy) void(^MyShoppongTable)(NSInteger index);

@end
