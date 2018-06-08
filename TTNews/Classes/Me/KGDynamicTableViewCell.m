//
//  KGDynamicTableViewCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/10/27.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "KGDynamicTableViewCell.h"

@interface KGDynamicTableViewCell(){
    UILabel     * _labUserNickname;//昵称
    UILabel     * _labTime;//时间
    UILabel     * _labContent;//内容
    PYPhotosView *_flowPhotosView;//图片展示
}
@end

@implementation KGDynamicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self setup];
    }
    return self;
}

-(void)setup{
    
    _imgHeaderView = [UIImageView new];
    _imgHeaderView.layer.cornerRadius = 20;
    _imgHeaderView.contentMode = UIViewContentModeScaleAspectFit;
    _imgHeaderView.clipsToBounds = YES;
    
    _labUserNickname = [UILabel new];
    _labUserNickname.font = [UIFont systemFontOfSize:17];
    _labUserNickname.numberOfLines = 0;
    _labUserNickname.textColor = [UIColor blackColor];
    
    _labTime = [UILabel new];
    _labTime.font = [UIFont systemFontOfSize:14];
    _labTime.numberOfLines = 0;
    _labTime.textColor = [UIColor lightGrayColor];
    
    _labContent = [UILabel new];
    _labContent.numberOfLines = 0;
    _labContent.font = [UIFont systemFontOfSize:14];
    _labContent.textColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:_imgHeaderView];
    [self.contentView addSubview:_labUserNickname];
    [self.contentView addSubview:_labTime];
    [self.contentView addSubview:_flowPhotosView];
    [self.contentView addSubview:_labContent];
    
    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    _labUserNickname.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
    _imgHeaderView.sd_layout
    .topSpaceToView(self.contentView, 5)
    .leftSpaceToView(self.contentView, 10)
    .heightIs(40)
    .widthIs(40);
    
    _labTime.sd_layout
    .topSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(20);
    [_labTime setSingleLineAutoResizeWithMaxWidth:150];
    
    _labUserNickname.sd_layout
    .leftSpaceToView(_imgHeaderView, 5)
    .topEqualToView(_labTime)
    .rightSpaceToView(_labTime, 5)
    .autoHeightRatio(0);
    [_labUserNickname setMaxNumberOfLinesToShow:2];
    
    _labContent.sd_layout
    .leftSpaceToView(_imgHeaderView, 5)
    .topSpaceToView(_labUserNickname, 5)
    .rightSpaceToView(self.contentView, 5)
    .autoHeightRatio(0);
    [_labContent setMaxNumberOfLinesToShow:3];
}

-(void)setModel:(DymamicModel *)model{
    
    _model = model;
    
    _labUserNickname.text = @"用户昵称";
    _labTime.text = model.create_time?model.create_time:@"";
    _labContent.text = model.description1?model.description1:@"";
    //先移除在增加
    [_flowPhotosView removeFromSuperview];
    if (model.fengmian) {
        [_labContent updateLayout];
        // 2.1 创建一个流水布局photosView(默认为流水布局)
        _flowPhotosView = [PYPhotosView photosView];
        
        NSMutableArray *thumbnailImageUrls = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,model.fengmian]]];
        if(thumbnailImageUrls && thumbnailImageUrls.count ==1 && [((NSString*)thumbnailImageUrls[0]) containsString:@"default"]){
            [self setupAutoHeightWithBottomView:_labContent bottomMargin:10];
        }
        else{
            _flowPhotosView.thumbnailUrls = thumbnailImageUrls;
            
            _flowPhotosView.py_y = _labContent.origin.y+_labContent.size.height+10;
            _flowPhotosView.py_x = _imgHeaderView.origin.x +_imgHeaderView.size.width + 10;
            _flowPhotosView.photosState = PYPhotosViewStateDidCompose;
            
            [self.contentView addSubview:_flowPhotosView];
            [self setupAutoHeightWithBottomView:_flowPhotosView bottomMargin:10];
        }
        
    }
    else{
        [self setupAutoHeightWithBottomView:_labContent bottomMargin:10];
    }
}


@end
