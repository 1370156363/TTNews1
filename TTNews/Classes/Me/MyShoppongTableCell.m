//
//  MyShoppongTableCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyShoppongTableCell.h"

@implementation MyShoppongTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 0;
    // Initialization code
}
- (IBAction)btnButtonClick:(UIButton*)sender {
    self.MyShoppongTable(sender.tag);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyShoppongTableCell" owner:self options:nil][0];
    }
    return self;
}

@end
