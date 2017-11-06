//
//  fensiTableViewCell.h
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFensiModel.h"
#import "UserModel.h"
@interface fensiTableViewCell : UITableViewCell

@property (nonatomic, strong)  MyFensiModel *model;//我的关注
@property (nonatomic, strong) UserModel* model1;//添加关注
@property (nonatomic, strong) IBOutlet UIImageView *imgHeaderView;
@property (nonatomic, strong) IBOutlet UILabel *labNickname;
@property (nonatomic, strong) IBOutlet UILabel *labSignature;
@property (nonatomic, strong) IBOutlet UIButton *btnAttention;

@end
