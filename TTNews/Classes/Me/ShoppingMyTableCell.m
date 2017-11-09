//
//  ShoppingMyTableCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/6.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ShoppingMyTableCell.h"

@interface ShoppingMyTableCell()
@property (weak, nonatomic) IBOutlet UIButton *btnDingdanManage;
@property (weak, nonatomic) IBOutlet UIButton *btnMyDingdan;
@property (weak, nonatomic) IBOutlet UIButton *btnMyCollection;

@end

@implementation ShoppingMyTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupviews];
    
}

-(void)setupviews{
    [_btnDingdanManage setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 20)];
    [_btnDingdanManage setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 30, 0)];
    
    [_btnMyDingdan setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 20)];
    [_btnMyDingdan setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 30, 0)];
    
    [_btnMyCollection setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 20)];
    [_btnMyCollection setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 30, 0)];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ShoppingMyTableCell" owner:self options:nil][0];
    }
    return self;
}

- (IBAction)btnButtonClick:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}


-(void)ShoppingTableReturn:(ShoppingTableBlock)block{
    self.block = block;
}

@end
