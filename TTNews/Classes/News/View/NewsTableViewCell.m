//
//  NewsTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell()
{
    
}

@property (retain, nonatomic)  UILabel *txtLab;
@property (retain, nonatomic)  UIImageView *myImage1;
@property (retain, nonatomic)  UIButton *btnZan;
@property (retain, nonatomic)  UIButton *btnPingLun;

@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    
    UILabel * txtLab = [[UILabel alloc] init];
    [txtLab setFont:[UIFont systemFontOfSize:17]];
    [txtLab setTextColor:[UIColor blackColor]];
    _txtLab = txtLab;
    
    UIImageView * myImage1 = [[UIImageView alloc] init];
    myImage1.clipsToBounds = YES;
    myImage1.contentMode = UIViewContentModeScaleAspectFit;
    _myImage1 = myImage1;
    
    
    UIButton * btnZan = [[UIButton alloc] init];
    btnZan.userInteractionEnabled = NO;
    [btnZan.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnZan setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnZan setImage:UIImageNamed(@"zan1") forState:UIControlStateNormal];
    [btnZan setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btnZan setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    _btnZan = btnZan;
    
    UIButton * btnPingLun = [[UIButton alloc] init];
    btnPingLun.userInteractionEnabled = NO;
    [btnPingLun.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btnPingLun setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnPingLun setImage:UIImageNamed(@"pinglun1") forState:UIControlStateNormal];
    [btnPingLun setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [btnPingLun setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    _btnPingLun = btnPingLun;
    
    [self.contentView sd_addSubviews:@[_txtLab,_myImage1,_btnZan,_btnPingLun]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    _txtLab.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    float margin = 5;
    
    _myImage1.sd_layout
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, 2*margin)
    .heightIs(90)
    .widthIs(120);
   
    _txtLab.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, 4*margin)
    .rightSpaceToView(_myImage1, margin)
    .autoHeightRatio(0);
    [_txtLab setMaxNumberOfLinesToShow:3];
    
    _btnZan.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(_txtLab, 3*margin);
    [_btnZan setupAutoSizeWithHorizontalPadding:20 buttonHeight:20];

    
    _btnPingLun.sd_layout
    .leftSpaceToView(_btnZan, 0)
    .topEqualToView(_btnZan);
    [_btnPingLun setupAutoSizeWithHorizontalPadding:20 buttonHeight:20];

    
    [self setupAutoHeightWithBottomViewsArray:@[_btnZan,_myImage1] bottomMargin:2*margin];
    
}

-(void)setModel:(TTVideo *)model{
    _model = model;
    
    NSArray *imagss=[model.fengmian componentsSeparatedByString:@","];
    if (imagss.count!=0) {
        [_myImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,imagss[0]]] placeholderImage:nil];
    }
  
    _txtLab.text=model.title;
    if(model.up){
        [_btnZan setTitle:[NSString stringWithFormat:@"%@赞",model.up] forState:UIControlStateNormal];
    }
    if(model.pinglunnum){
        [_btnPingLun setTitle:[NSString stringWithFormat:@"%@评论",model.pinglunnum] forState:UIControlStateNormal];
    }
    
}

-(void)setCollectionModel:(MyCollectionModel *)collectionModel{
    _collectionModel = collectionModel;
    NSArray *imagss=[collectionModel.fengmian componentsSeparatedByString:@","];
    if (imagss.count!=0) {
        [_myImage1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,imagss[0]]] placeholderImage:nil];
    }
    if(collectionModel.up){
        [_btnZan setTitle:[NSString stringWithFormat:@"%@赞",collectionModel.up] forState:UIControlStateNormal];
    }
    if(collectionModel.pinglunnum){
        [_btnPingLun setTitle:[NSString stringWithFormat:@"%@评论",collectionModel.pinglunnum] forState:UIControlStateNormal];
    }
    self.txtLab.text=collectionModel.title;
}

@end
