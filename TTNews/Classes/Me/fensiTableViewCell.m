//
//  fensiTableViewCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "fensiTableViewCell.h"

@interface fensiTableViewCell(){
    
}
@property(nonatomic,strong)UIView *separatorView;

@end

@implementation fensiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupview];
    // Initialization code
}

//懒加载创建
-(UIView *)separatorView{
    
    if (_separatorView == nil) {
        
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = [UIColor lightGrayColor];
        _separatorView.alpha = 0.6;
    }
    return _separatorView;
}

//在layout方法里设置frame
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width;
    CGFloat h = 0.5;
    CGFloat x = 30;
    CGFloat y = self.bounds.size.height-h;
    self.separatorView.frame = CGRectMake(x, y, w, h);
}

-(void)setupview{
    _imgHeaderView.layer.cornerRadius = 40;
    _imgHeaderView.contentMode = UIViewContentModeScaleAspectFit;
    _imgHeaderView.clipsToBounds = YES;
    
    _btnAttention.layer.cornerRadius = 5.0;
    _btnAttention.layer.borderWidth = 1.0;
    _btnAttention.layer.borderColor = [UIColor redColor].CGColor;
    
    [self.contentView addSubview:self.separatorView];
 
}
- (IBAction)btnAttentionClick:(UIButton*)sender {
    [_btnAttention setTitle:@"已关注" forState:UIControlStateNormal];
    [_btnAttention setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _btnAttention.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnAttention.userInteractionEnabled = false;
}


-(void)setModel:(MyFensiModel *)model{
    if(!_isShowBtnAttention){
        _btnAttention.hidden = YES;
    }
    [_imgHeaderView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"geren"]];
    _labNickname.text = model.nicheng?model.nicheng:model.username;
    _labSignature.text = model.sign?model.sign:@"这个家伙很懒，什么都没有留下！";
}

@end
