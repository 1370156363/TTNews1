//
//  WendaHeaderView.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/25.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "WendaHeaderView.h"

@interface WendaHeaderView ()
{
    IBOutlet UIImageView    *img;
    IBOutlet UILabel        *title;
    IBOutlet UILabel        *content;
}
@end

@implementation WendaHeaderView

-(instancetype)init
{
    if (self=[super init])
    {
        self=[[NSBundle mainBundle] loadNibNamed:@"WendaHeaderView" owner:self options:nil][0];
    }
    return self;
}

-(IBAction)BtnSelevt:(UIButton *)sender
{
    self.btnBlock(sender.tag);
}
@end
