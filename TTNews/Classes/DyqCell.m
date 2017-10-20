//
//  DyqCell.m
//  meiguan
//
//  Created by 王迪 on 2017/7/18.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import "DyqCell.h"
#import "DongtaiModel.h"
#define kPicDiv 4.0f


@interface DyqCell ()
@property(nonatomic,weak)IBOutlet UIImageView *img;
@property(nonatomic,weak)IBOutlet UILabel     *nameLab;
@property(nonatomic,weak)IBOutlet UILabel     *timeLab;
@property(nonatomic,weak)IBOutlet UILabel     *contentLab;
@property(nonatomic,weak)IBOutlet UIView      *imgBackview;
@property(nonatomic,weak)IBOutlet UILabel     *zanCount;
@property(nonatomic,weak)IBOutlet UILabel     *eyeCount;
@property(nonatomic,weak)IBOutlet UILabel     *comuCount;
@property(nonatomic,strong)    NSMutableArray *imgViewArray;
@end

@implementation DyqCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self=[[NSBundle mainBundle] loadNibNamed:@"DyqCell" owner:self options:nil][0];
        self.img.layer.masksToBounds=YES;
        self.img.layer.cornerRadius=self.img.wh_height/2;
        self.imgViewArray=[NSMutableArray array];
    }
    return self;
}

-(void)setUI:(DongtaiModel *)dict
{
    [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,dict.avatar]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLab.text=dict.nicheng;
    self.timeLab.text=dict.create_time;
    self.timeLab.text=dict.title;
    self.contentLab.text=dict.desc;
    CGFloat bodyViewWidth = winsize.width - 48 - 10;
    NSArray *imgArr=[dict.fengmian componentsSeparatedByString:@","];
    
    for (UIImageView *im in _imgViewArray)
    {
        [im removeFromSuperview];
    }
    [_imgViewArray removeAllObjects];
    if (imgArr.count>0)
    {
        CGFloat imgWidth = (bodyViewWidth - 2 * kPicDiv)/3;
        for (int i=0; i<[imgArr count]; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%3)*(imgWidth+kPicDiv), (i/3)*(imgWidth+kPicDiv), imgWidth, imgWidth)];
            
            NSString *imgDic=imgArr[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,imgDic]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
            
            imageView.tag = i;
            [_imgViewArray addObject:imageView];
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPressImage:)];
            [imageView addGestureRecognizer:tapGesture];
        }
        
        for (UIImageView *im in _imgViewArray)
        {
            [self.imgBackview addSubview:im];
        }
        
        CGFloat height=0;
        if (imgArr.count<4)
        {
            height=imgWidth;
        }
        else if (imgArr.count<7)
        {
            height=imgWidth*2+kPicDiv;
        }
        else if (imgArr.count<10)
        {
            height=imgWidth*3+2*kPicDiv;
        }
        [self.imgBackview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
}

- (void)onPressImage:(UITapGestureRecognizer *)sender
{
    UIImageView *imageview = (UIImageView *)sender.view;
    self.imageTapBlock(imageview,self);
}

-(IBAction)dianzanAction:(id)sender
{
    self.zanBlock();
}

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
        result = createdTimeStr;
    }
    return result;
}

@end
