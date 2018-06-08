//
//  DongTaiTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "DongTaiTableViewCell.h"
@interface DongTaiTableViewCell()

@property (strong, nonatomic) UIImageView *iconImg;///图像
@property (strong, nonatomic) UILabel *nickNameLab;///昵称
@property (strong, nonatomic) UILabel *timeLab;///时间
@property (strong, nonatomic) UILabel *contentLab;///详情
@property (strong, nonatomic) PYPhotosView *flowPhotosView;///图片数组

@end

@implementation DongTaiTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg = imgView;
    
    UILabel * nickNameLab = [[UILabel alloc] init];
    nickNameLab.textColor = [UIColor blackColor];
    nickNameLab.font = [UIFont systemFontOfSize:17];
    _nickNameLab = nickNameLab;
    
    UILabel * timeLab = [[UILabel alloc] init];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.font = [UIFont systemFontOfSize:14];
    _timeLab = timeLab;
   
    UILabel * contentLab = [[UILabel alloc] init];
    contentLab.textColor = [UIColor lightGrayColor];
    contentLab.font = [UIFont systemFontOfSize:14];
    _contentLab = contentLab;
    
    [self.contentView sd_addSubviews:@[_iconImg,_nickNameLab,_timeLab,_contentLab]];
    
    //日间夜间切换
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    _nickNameLab.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    float margin = 5;
    
    
    _iconImg.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, margin)
    .heightIs(40).widthIs(40);
    _iconImg.layer.cornerRadius = 20;
    
    _timeLab.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(_nickNameLab)
    .topSpaceToView(self.contentView, 10);
    [_timeLab setSingleLineAutoResizeWithMaxWidth:100];
    
    _nickNameLab.sd_layout
    .leftSpaceToView(_iconImg, margin)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(_timeLab, margin)
    .autoHeightRatio(0);
    _nickNameLab.numberOfLines = 1;
    
    _contentLab.sd_layout
    .leftSpaceToView(_iconImg, margin)
    .topSpaceToView(_nickNameLab, margin)
    .rightSpaceToView(_timeLab, margin)
    .autoHeightRatio(0);
    [_contentLab setMaxNumberOfLinesToShow:3];
}

///填入数据
-(void)setModel:(DongtaiModel *)model{
    _model = model;
    //头像
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,model.avatar]]];

    _nickNameLab.text=model.nicheng;
    _timeLab.text=[self getTimeFromCurrentTime:model.create_time];
   
    _contentLab.text=model.desc;
    
    [_flowPhotosView removeFromSuperview];
    //图片
    NSArray *imagesArr=[model.fengmian componentsSeparatedByString:@","];
    if(imagesArr && imagesArr.count ==1 && [((NSString*)imagesArr[0]) containsString:@"default"]){
        [self setupAutoHeightWithBottomView:_contentLab bottomMargin:10];
    }
    else if (imagesArr && imagesArr.count>0) {
        NSMutableArray *arrayList = [NSMutableArray new];
        
        [imagesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayList addObject:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,obj]];
        }];
         [_contentLab updateLayout];
        
        // 2.1 创建一个流水布局photosView(默认为流水布局)
        _flowPhotosView = [PYPhotosView photosView];
        // 设置原图地址
        _flowPhotosView.originalUrls = arrayList;
        
        _flowPhotosView.py_y = _contentLab.origin.y+_contentLab.size.height+10;
        _flowPhotosView.py_x = _iconImg.origin.x+_iconImg.size.width + 10;
        _flowPhotosView.photoMargin = 10;
        _flowPhotosView.photosMaxCol = 3;
        _flowPhotosView.photosState = PYPhotosViewStateDidCompose;
        _flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
        _flowPhotosView.photoHeight = (SCREEN_WIDTH-_iconImg.origin.x-_iconImg.size.width-40)/3;
        _flowPhotosView.photoWidth = (SCREEN_WIDTH-_iconImg.origin.x-_iconImg.size.width-40)/3;
        
        [self.contentView addSubview:_flowPhotosView];

       [self setupAutoHeightWithBottomView:_flowPhotosView bottomMargin:10];
    }
    else{
        [self setupAutoHeightWithBottomView:_contentLab bottomMargin:10];
    }
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
