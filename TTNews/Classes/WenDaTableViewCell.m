//
//  WenDaTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "WenDaTableViewCell.h"

@interface WenDaTableViewCell()
@property (strong, nonatomic) UILabel *nickNameLab;///标题
@property (strong, nonatomic) UILabel *timeLab;///时间
@property (strong, nonatomic) UILabel *contentLab;///详情
@property (strong, nonatomic) PYPhotosView *flowPhotosView;///图片数组
@property (strong, nonatomic) UILabel * labCommentCount;

@end

@implementation WenDaTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel * nickNameLab = [[UILabel alloc] init];
    nickNameLab.textColor = [UIColor blackColor];
    nickNameLab.font = [UIFont systemFontOfSize:17];
    _nickNameLab = nickNameLab;
    
    PYPhotosView *flowPhotosView = [PYPhotosView photosView];
    flowPhotosView.photoMargin = 10;
    flowPhotosView.photosMaxCol = 3;
    flowPhotosView.photosState = PYPhotosViewStateDidCompose;
    flowPhotosView.pageType = PYPhotosViewPageTypeLabel;
    flowPhotosView.photoHeight = (SCREEN_WIDTH-50)/3;
    flowPhotosView.photoWidth = (SCREEN_WIDTH-50)/3;
    _flowPhotosView = flowPhotosView;
    
    UILabel * labCommentCount = [[UILabel alloc] init];
    labCommentCount.textColor = [UIColor lightGrayColor];
    labCommentCount.font = [UIFont systemFontOfSize:14];
    _labCommentCount = labCommentCount;
    
    UILabel * timeLab = [[UILabel alloc] init];
    timeLab.textColor = [UIColor lightGrayColor];
    timeLab.font = [UIFont systemFontOfSize:14];
    _timeLab = timeLab;
    
    UILabel * contentLab = [[UILabel alloc] init];
    contentLab.textColor = [UIColor lightGrayColor];
    contentLab.font = [UIFont systemFontOfSize:14];
    _contentLab = contentLab;
    
    [self.contentView sd_addSubviews:@[_nickNameLab,_timeLab,_contentLab,_flowPhotosView,_labCommentCount]];
    
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
    
    _timeLab.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(_nickNameLab)
    .topSpaceToView(self.contentView, 10);
    [_timeLab setSingleLineAutoResizeWithMaxWidth:100];
    
    _nickNameLab.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(_timeLab, margin)
    .autoHeightRatio(0);
    _nickNameLab.numberOfLines = 1;
    
    _contentLab.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .topSpaceToView(_nickNameLab, margin)
    .rightSpaceToView(self.contentView, margin)
    .autoHeightRatio(0);
    [_contentLab setMaxNumberOfLinesToShow:3];
    
    _flowPhotosView.sd_layout
    .leftSpaceToView(self.contentView, 10);
    
    _labCommentCount.sd_layout
    .leftSpaceToView(self.contentView,5)
    .topSpaceToView(_flowPhotosView, 5)
    .widthRatioToView(self.contentView, 5)
    .autoHeightRatio(0);
    [self setupAutoHeightWithBottomView:_labCommentCount bottomMargin:10];
    
}

-(void)setWendaModel:(WendaModel *)wendaModel{
    _wendaModel = wendaModel;
    //头像
    //[_iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,wendaModel.avatar]]];
    
    _nickNameLab.text=wendaModel.title;
    _timeLab.text=[self getTimeFromCurrentTime:wendaModel.create_time];
    
    _contentLab.text=wendaModel.des;
    _labCommentCount.text = [NSString stringWithFormat:@"已有%@个问答",wendaModel.answernum];
    
    [_contentLab updateLayout];
    _flowPhotosView.sd_layout.topSpaceToView(_contentLab, 5);
    
    //图片
    NSArray *imagesArr=[wendaModel.fengmian componentsSeparatedByString:@","];
    if(imagesArr && imagesArr.count ==1 && [((NSString*)imagesArr[0]) containsString:@"default"]){
        _flowPhotosView.originalUrls = nil;
        
        _flowPhotosView.sd_layout.heightIs(0);
        _flowPhotosView.sd_layout.widthIs(0);
    }
    else if (imagesArr && imagesArr.count>0) {
        NSMutableArray *arrayList = [NSMutableArray new];
        
        [imagesArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayList addObject:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,obj]];
        }];
        // 设置原图地址
        _flowPhotosView.originalUrls = arrayList;
        _flowPhotosView.fixedHeight = nil;
        _flowPhotosView.fixedWidth = nil;
        //_flowPhotosView.sd_layout.widthIs(_flowPhotosView.frame.size.width);
        float  height = 0 ;
        float  width = 0 ;
        if (arrayList.count <4) {
            height = _flowPhotosView.photoHeight;
            width = arrayList.count * _flowPhotosView.photoWidth + (arrayList.count-1) % 3 *10;
        }
        else if (arrayList.count <5)
        {
            height = 2 * _flowPhotosView.photoHeight+10;
            width = 2 * _flowPhotosView.photoWidth + 10;
        }
        else {
            height = arrayList.count/3 * (_flowPhotosView.photoHeight + 10) ;
            width =  3 * _flowPhotosView.photoWidth +  20;
        }
        _flowPhotosView.sd_layout.heightIs(height);
        _flowPhotosView.sd_layout.widthIs(width);
        
    }
    else{
        _flowPhotosView.originalUrls = nil;
        _flowPhotosView.sd_layout.heightIs(0);
        _flowPhotosView.sd_layout.widthIs(0);
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
