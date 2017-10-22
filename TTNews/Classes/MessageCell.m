//
//  MessageCell.m
//  Aerospace
//
//  Created by 王迪 on 2017/2/9.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import "MessageCell.h"
#import "WendaModel.h"
#define kPicDiv 4.0f

@interface MessageCell ()
@property(nonatomic,strong) UILabel       *titleLab;
@property(nonatomic,strong) UILabel       *answerCountLab;
@property(nonatomic,strong) WendaModel    *dics;
@property(nonatomic,strong)NSMutableArray *lastArr;
@end


@implementation MessageCell

-(void)updateUIwithdic:(WendaModel *)data
{
    
    NSString *str = data.title;
    CGSize constraint = CGSizeMake(winsize.width-20, 20000.0f);
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16]
                  constrainedToSize:constraint
                      lineBreakMode:1];
    self.titleLab.frame=CGRectMake(5, 10, winsize.width-10, size.height);
    self.titleLab.text=data.title;
    CGFloat bodyViewWidth = winsize.width - 20;
    NSArray *imgArr=[data.fengmian componentsSeparatedByString:@","];
    
    if (_lastArr==nil)
    {
        _lastArr=[NSMutableArray array];
    }
    else
    {
        for (UIImageView *img in _lastArr)
        {
            [img removeFromSuperview];
        }
        [_lastArr removeAllObjects];
    }
    CGFloat imgWidth = (bodyViewWidth - 2 * kPicDiv)/3;
    
    for (int i=0; i<[imgArr count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        imageView.frame=CGRectMake((i%3)*(imgWidth+kPicDiv)+10, (i/3)*(imgWidth+kPicDiv)+self.titleLab.wh_bottom+10, imgWidth, imgWidth);
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,imgArr[i]]]];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
        [imageView addGestureRecognizer:tapGesture];
        [_lastArr addObject:imageView];
    }
    for (UIImageView *im in _lastArr)
    {
        [self.contentView addSubview:im];
    }
    
    UIImageView *img=[_lastArr lastObject];
    
    self.answerCountLab.textAlignment=0;
    self.answerCountLab.font=[UIFont systemFontOfSize:10];
    self.answerCountLab.textColor=[UIColor grayColor];
    self.answerCountLab.frame=CGRectMake(10, img.wh_bottom+5, winsize.width-20, 20);
    self.answerCountLab.text=[NSString stringWithFormat:@"已有%@个回答",data.answernum];
}

-(UILabel *)answerCountLab
{
    if (!_answerCountLab)
    {
        _answerCountLab=[[UILabel alloc] init];
        [self.contentView addSubview:_answerCountLab];
    }
    return _answerCountLab;
}

-(UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab=[[UILabel alloc] init];
        _titleLab.font=[UIFont systemFontOfSize:16];
        _titleLab.numberOfLines=0;
        _titleLab.textColor=[UIColor darkGrayColor];
        _titleLab.textAlignment=0;
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}

- (void)onPressImage:(UITapGestureRecognizer *)sender
{
    UIImageView *imageview = (UIImageView *)sender.view;
    self.ImgTapBlock(imageview, self);
}

@end
