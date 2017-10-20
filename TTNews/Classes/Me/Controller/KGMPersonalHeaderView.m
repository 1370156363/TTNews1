//
//  KGMPersonalHeaderView.m
//  Aerospace
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import "KGMPersonalHeaderView.h"


@interface KGMPersonalHeaderView ()

@property(nonatomic,weak)IBOutlet UIImageView  *headImageView;
@property(nonatomic,weak)IBOutlet UIImageView  *headerImg;
@property(nonatomic,weak)IBOutlet UILabel      *name;
@property(nonatomic,weak)IBOutlet UILabel      *contenttext;
@property(nonatomic,weak)IBOutlet UILabel      *dongtai;
@property(nonatomic,weak)IBOutlet UILabel      *fensi;
@property(nonatomic,weak)IBOutlet UILabel      *jifen;
@property(nonatomic,weak)IBOutlet UILabel      *fangwen;
@property(nonatomic,weak)IBOutlet UIView       *backView;
@end

@implementation KGMPersonalHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame])
    {
        self=[[NSBundle mainBundle] loadNibNamed:@"KGMPersonalHeaderView" owner:self options:nil][0];
        self.frame=frame;
    }
    return self;
}

-(void)reloadHeaderUI:(NSDictionary *)dic
{

}

-(IBAction)btnSelect:(UIButton *)sender
{
    self.KGPersonalCheckBlock(sender.tag);
}
@end




