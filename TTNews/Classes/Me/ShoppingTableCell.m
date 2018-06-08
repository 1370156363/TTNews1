//
//  ShoppingTableCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/6.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ShoppingTableCell.h"

@interface ShoppingTableCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgShopView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;

@end

@implementation ShoppingTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupview];
    // Initialization code
}

-(void)setupview{
    self.imgShopView.clipsToBounds = YES;
    [self.labTitle setNumberOfLines:0];
    [self.labMoney setNumberOfLines:0];
    
}

-(void) setModel:(ShoppingModel *)model
{
    _model = model;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,model.fengmian]];
//    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    //[self.imgShopView setImage:[UIImage imageWithData:data]];
    [self.imgShopView sd_setImageWithURL:url placeholderImage:ImageNamed(@"tupianGL.png")];
    [self.labMoney setText:[NSString stringWithFormat:@"￥%@",model.price]];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ShoppingTableCell" owner:self options:nil][0];
    }
    return self;
}

@end
