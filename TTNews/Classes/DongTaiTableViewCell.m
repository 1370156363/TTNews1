//
//  DongTaiTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "DongTaiTableViewCell.h"

@implementation DongTaiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

///填入数据
-(void)setComment:(DongtaiModel *)comment{
    //头像
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,comment.avatar]]];
//    self.iconImg.layer.cornerRadius=self.iconImg.wh_height/2;
//    self.iconImg.layer.cornerRadius=5;

    self.nickNameLab.text=comment.nicheng;
    self.jieshaoLab.text=comment.title;
    self.timeLab.text=[self getTimeFromCurrentTime:comment.create_time];
    ///文字自适应
    CGSize constraint = CGSizeMake(winsize.width-93, 20000.0f);
    NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:comment.desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    CGRect rect=[attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(rect.size.height);
     }];
    self.contentLab.text=comment.desc;

    //图片
    NSArray *imagesArr=[comment.fengmian componentsSeparatedByString:@","];

    if (imagesArr.count!=0) {
        ///封面图片最多显示9个
        CGFloat jianGe=15;
        CGFloat width =(winsize.width-88-5-2*jianGe)/3;

        CGFloat totlHight=[self getImgaeViewHight:imagesArr.count jianGe:jianGe width:width];
        [self.imagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(totlHight);
            [self.imagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

            NSInteger num=0;
            for (NSString *url in imagesArr) {
                NSString *imageUrl=[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,url];
                CGFloat image_x=[self getImageWithX:num jianGe:jianGe width:width];
                CGFloat image_y=[self getImageWithY:num jianGe:jianGe hight:width];

                UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(image_x, image_y, width, width)];
                [image sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                ///
                [self.imagView addSubview:image];
                num++;
            }
        }];
//        [self.imagView setBackgroundColor:[UIColor redColor]];
    }

}

///根据排列位置计算出相应的y点
-(CGFloat)getImageWithY:(NSInteger)num jianGe:(CGFloat)jiange hight:(CGFloat)hight
{
    switch (num/3) {
        case 0:
        {
            return jiange;
        }
            break;
        case 1:
        {
            return jiange+hight+jiange;
        }
            break;
        case 2:
        {
            return 3*jiange+2*hight;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

///根据排列位置计算出相应的x点
-(CGFloat)getImageWithX:(NSInteger )num jianGe:(CGFloat)jiange width:(CGFloat)width
{

    switch (num%3) {
        case 0:
        {
            return 0;
        }
            break;
        case 1:
        {
            return 0+width+jiange;
        }
            break;
        case 2:
        {
            return 0+2*width+2*jiange;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }

}

///计算imageView的总高
-(CGFloat )getImgaeViewHight:(NSInteger )count jianGe:(CGFloat)jiange width:(CGFloat)width{
    CGFloat hight=0;
    if (count<=3) {
        hight=width+2*jiange;
    }
    else if(count>3 && count<=6)
    {
        hight=2*width+3*jiange;
    }
    else{
        hight=3*width+4*jiange;
    }

    return hight;
}

///计算时间
-(NSString *)getTimeFromCurrentTime:(NSString *)createdTimeStr
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:createdTimeStr];
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if((temp = timeInterval/3600) > 1 && (temp = timeInterval/3600) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if ((temp = timeInterval/3600) > 24 && (temp = timeInterval/3600) < 48){
        result = [NSString stringWithFormat:@"昨天"];
    }else if ((temp = timeInterval/3600) > 48 && (temp = timeInterval/3600) < 72){
        result = [NSString stringWithFormat:@"前天"];
    }else{
        result = [NSString stringWithFormat:@"更久"];
    }
    return result;
}
@end
