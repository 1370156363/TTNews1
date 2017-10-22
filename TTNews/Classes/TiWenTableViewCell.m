//
//  TiWenTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/22.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "TiWenTableViewCell.h"

#import "UIButton+WebCache.h"

@implementation TiWenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.image1.userInteractionEnabled=YES;
    self.image2.userInteractionEnabled=YES;
    self.iamgeBtu3.userInteractionEnabled=YES;
    self.iamgeBtu4.userInteractionEnabled=YES;
    self.iamgeBtu5.userInteractionEnabled=YES;
    self.iamgeBtu6.userInteractionEnabled=YES;
    self.iamgeBtu7.userInteractionEnabled=YES;
    self.iamgeBtu8.userInteractionEnabled=YES;
    self.iamgeBtu9.userInteractionEnabled=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

///针对第一个的界面
-(void)setTitle:(NSString *)Title
{
    if (Title.length!=0) {
        self.messageTxt.text=Title;
    }
}

///针对内容页
-(void)setContent:(NSString *)Content
{
    if (Content.length!=0) {
        self.contextTxt.text=Content;
        [self.contentLab setHidden:YES];
    }
}


///图片页面
-(void)setImages:(NSMutableArray *)images{
    ///防止内存泄漏
    if (!images) {
        return;
    }
    [self toHideImages:images.count];

    switch (images.count) {
        case 0:
        {

        }
            break;
        case 1:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[2]];
            [self.iamgeBtu3 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        case 4:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[2]];
            [self.iamgeBtu3 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[3]];
            [self.iamgeBtu4 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[2]];
            [self.iamgeBtu3 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[3]];
            [self.iamgeBtu4 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[4]];
            [self.iamgeBtu5 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        case 6:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[2]];
            [self.iamgeBtu3 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[3]];
            [self.iamgeBtu4 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[4]];
            [self.iamgeBtu5 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[5]];
            [self.iamgeBtu6 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        case 7:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[2]];
            [self.iamgeBtu3 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[3]];
            [self.iamgeBtu4 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[4]];
            [self.iamgeBtu5 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[5]];
            [self.iamgeBtu6 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[6]];
            [self.iamgeBtu7 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        case 8:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[2]];
            [self.iamgeBtu3 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[3]];
            [self.iamgeBtu4 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[4]];
            [self.iamgeBtu5 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[5]];
            [self.iamgeBtu6 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[6]];
            [self.iamgeBtu7 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[7]];
            [self.iamgeBtu8 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        case 9:
        {
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[2]];
            [self.iamgeBtu3 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[3]];
            [self.iamgeBtu4 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[4]];
            [self.iamgeBtu5 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[5]];
            [self.iamgeBtu6 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[6]];
            [self.iamgeBtu7 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[7]];
            [self.iamgeBtu8 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[8]];
            [self.iamgeBtu9 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
        default:
        {
            ///0的可能
            NSString *url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[0]];
            [self.image1 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[1]];
            [self.image2 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[2]];
            [self.iamgeBtu3 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[3]];
            [self.iamgeBtu4 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[4]];
            [self.iamgeBtu5 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[5]];
            [self.iamgeBtu6 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[6]];
            [self.iamgeBtu7 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[7]];
            [self.iamgeBtu8 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            url=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,images[8]];
            [self.iamgeBtu9 sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        }
            break;
    }
}

///隐藏重置
-(void)toHideImages:(NSInteger)count{
    switch (count) {
        case 0:
        {
            [self.image1 setHidden:NO];
            self.image1.userInteractionEnabled=YES;
            [self.image2 setHidden:YES];
            [self.iamgeBtu3 setHidden:YES];
            [self.iamgeBtu4 setHidden:YES];
            [self.iamgeBtu5 setHidden:YES];
            [self.iamgeBtu6 setHidden:YES];
            [self.iamgeBtu7 setHidden:YES];
            [self.iamgeBtu8 setHidden:YES];
            [self.iamgeBtu9 setHidden:YES];
        }
            break;
        case 1:
            {
                [self.image1 setHidden:NO];
                [self.image2 setHidden:NO];
                [self.iamgeBtu3 setHidden:YES];
                [self.iamgeBtu4 setHidden:YES];
                [self.iamgeBtu5 setHidden:YES];
                [self.iamgeBtu6 setHidden:YES];
                [self.iamgeBtu7 setHidden:YES];
                [self.iamgeBtu8 setHidden:YES];
                [self.iamgeBtu9 setHidden:YES];
                self.image1.userInteractionEnabled=YES;
                self.image2.userInteractionEnabled=YES;
            }
            break;
        case 2:
        {
            [self.image1 setHidden:NO];
            [self.image2 setHidden:NO];
            [self.iamgeBtu3 setHidden:NO];
            [self.iamgeBtu4 setHidden:YES];
            [self.iamgeBtu5 setHidden:YES];
            [self.iamgeBtu6 setHidden:YES];
            [self.iamgeBtu7 setHidden:YES];
            [self.iamgeBtu8 setHidden:YES];
            [self.iamgeBtu9 setHidden:YES];
            self.image1.userInteractionEnabled=YES;
            self.image2.userInteractionEnabled=YES;
            self.iamgeBtu3.userInteractionEnabled=YES;

        }
            break;
        case 3:
        {
            [self.image1 setHidden:NO];
            [self.image2 setHidden:NO];
            [self.iamgeBtu3 setHidden:NO];
            [self.iamgeBtu4 setHidden:NO];
            [self.iamgeBtu5 setHidden:YES];
            [self.iamgeBtu6 setHidden:YES];
            [self.iamgeBtu7 setHidden:YES];
            [self.iamgeBtu8 setHidden:YES];
            [self.iamgeBtu9 setHidden:YES];
            self.image1.userInteractionEnabled=YES;
            self.image2.userInteractionEnabled=YES;
            self.iamgeBtu3.userInteractionEnabled=YES;
            self.iamgeBtu4.userInteractionEnabled=YES;

        }
            break;
        case 4:
        {
            [self.image1 setHidden:NO];
            [self.image2 setHidden:NO];
            [self.iamgeBtu3 setHidden:NO];
            [self.iamgeBtu4 setHidden:NO];
            [self.iamgeBtu5 setHidden:NO];
            [self.iamgeBtu6 setHidden:YES];
            [self.iamgeBtu7 setHidden:YES];
            [self.iamgeBtu8 setHidden:YES];
            [self.iamgeBtu9 setHidden:YES];

            self.image1.userInteractionEnabled=YES;
            self.image2.userInteractionEnabled=YES;
            self.iamgeBtu3.userInteractionEnabled=YES;
            self.iamgeBtu4.userInteractionEnabled=YES;
            self.iamgeBtu5.userInteractionEnabled=YES;

        }
            break;
        case 5:
        {
            [self.image1 setHidden:NO];
            [self.image2 setHidden:NO];
            [self.iamgeBtu3 setHidden:NO];
            [self.iamgeBtu4 setHidden:NO];
            [self.iamgeBtu5 setHidden:NO];
            [self.iamgeBtu6 setHidden:NO];
            [self.iamgeBtu7 setHidden:YES];
            [self.iamgeBtu8 setHidden:YES];
            [self.iamgeBtu9 setHidden:YES];

            self.image1.userInteractionEnabled=YES;
            self.image2.userInteractionEnabled=YES;
            self.iamgeBtu3.userInteractionEnabled=YES;
            self.iamgeBtu4.userInteractionEnabled=YES;
            self.iamgeBtu5.userInteractionEnabled=YES;
            self.iamgeBtu6.userInteractionEnabled=YES;

        }
            break;
        case 6:
        {
            [self.image1 setHidden:NO];
            [self.image2 setHidden:NO];
            [self.iamgeBtu3 setHidden:NO];
            [self.iamgeBtu4 setHidden:NO];
            [self.iamgeBtu5 setHidden:NO];
            [self.iamgeBtu6 setHidden:NO];
            [self.iamgeBtu7 setHidden:NO];
            [self.iamgeBtu8 setHidden:YES];
            [self.iamgeBtu9 setHidden:YES];

            self.image1.userInteractionEnabled=YES;
            self.image2.userInteractionEnabled=YES;
            self.iamgeBtu3.userInteractionEnabled=YES;
            self.iamgeBtu4.userInteractionEnabled=YES;
            self.iamgeBtu5.userInteractionEnabled=YES;
            self.iamgeBtu6.userInteractionEnabled=YES;
            self.iamgeBtu7.userInteractionEnabled=YES;

        }
            break;
        case 7:
        {
            [self.image1 setHidden:NO];
            [self.image2 setHidden:NO];
            [self.iamgeBtu3 setHidden:NO];
            [self.iamgeBtu4 setHidden:NO];
            [self.iamgeBtu5 setHidden:NO];
            [self.iamgeBtu6 setHidden:NO];
            [self.iamgeBtu7 setHidden:NO];
            [self.iamgeBtu8 setHidden:NO];
            [self.iamgeBtu9 setHidden:YES];

            self.image1.userInteractionEnabled=YES;
            self.image2.userInteractionEnabled=YES;
            self.iamgeBtu3.userInteractionEnabled=YES;
            self.iamgeBtu4.userInteractionEnabled=YES;
            self.iamgeBtu5.userInteractionEnabled=YES;
            self.iamgeBtu6.userInteractionEnabled=YES;
            self.iamgeBtu7.userInteractionEnabled=YES;
            self.iamgeBtu8.userInteractionEnabled=YES;

        }
            break;
        case 8:
        {
            [self.image1 setHidden:NO];
            [self.image2 setHidden:NO];
            [self.iamgeBtu3 setHidden:NO];
            [self.iamgeBtu4 setHidden:NO];
            [self.iamgeBtu5 setHidden:NO];
            [self.iamgeBtu6 setHidden:NO];
            [self.iamgeBtu7 setHidden:NO];
            [self.iamgeBtu8 setHidden:NO];
            [self.iamgeBtu9 setHidden:NO];

            self.image1.userInteractionEnabled=YES;
            self.image2.userInteractionEnabled=YES;
            self.iamgeBtu3.userInteractionEnabled=YES;
            self.iamgeBtu4.userInteractionEnabled=YES;
            self.iamgeBtu5.userInteractionEnabled=YES;
            self.iamgeBtu6.userInteractionEnabled=YES;
            self.iamgeBtu7.userInteractionEnabled=YES;
            self.iamgeBtu8.userInteractionEnabled=YES;
            self.iamgeBtu9.userInteractionEnabled=YES;

        }
            break;
        case 9:
        {
            [self.image1 setHidden:NO];
            [self.image2 setHidden:NO];
            [self.iamgeBtu3 setHidden:NO];
            [self.iamgeBtu4 setHidden:NO];
            [self.iamgeBtu5 setHidden:NO];
            [self.iamgeBtu6 setHidden:NO];
            [self.iamgeBtu7 setHidden:NO];
            [self.iamgeBtu8 setHidden:NO];
            [self.iamgeBtu9 setHidden:NO];
            self.image1.userInteractionEnabled=YES;
            self.image2.userInteractionEnabled=YES;
            self.iamgeBtu3.userInteractionEnabled=YES;
            self.iamgeBtu4.userInteractionEnabled=YES;
            self.iamgeBtu5.userInteractionEnabled=YES;
            self.iamgeBtu6.userInteractionEnabled=YES;
            self.iamgeBtu7.userInteractionEnabled=YES;
            self.iamgeBtu8.userInteractionEnabled=YES;
            self.iamgeBtu9.userInteractionEnabled=YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark -按钮事件
///获取图片
- (IBAction)getImageAction:(UIButton *)sender {

    [self.delegate clickImageBtu:sender];
}


@end
