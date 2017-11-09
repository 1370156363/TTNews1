//
//  AddressTableCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "AddressTableCell.h"

@interface AddressTableCell()

@end

@implementation AddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)AddressTableReturn:(AddressTableBlock)block{
    self.block = block;
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"AddressTableCell" owner:self options:nil][0];
    }
    return self;
}
@end
