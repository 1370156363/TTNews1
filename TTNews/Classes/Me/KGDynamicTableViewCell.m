//
//  KGDynamicTableViewCell.m
//  TTNews
//
//  Created by 薛立强 on 2017/10/27.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "KGDynamicTableViewCell.h"

@interface KGDynamicTableViewCell(){
    UIImageView * _imgHeaderView;//图像
    UILabel     * _labUserNickname;//昵称
    UILabel     * _labTime;//时间
    UILabel     * _labCaption;//标题
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
    _imgHeaderView.layer.cornerRadius = 30;
    _imgHeaderView.contentMode = UIViewContentModeScaleAspectFit;
    _imgHeaderView.clipsToBounds = YES;
    
    _labUserNickname = [UILabel new];
    _labUserNickname.font = [UIFont systemFontOfSize:15];
    _labUserNickname.numberOfLines = 0;
    _labUserNickname.textColor = [UIColor blackColor];
    
    _labTime = [UILabel new];
    _labTime.font = [UIFont systemFontOfSize:15];
    _labTime.numberOfLines = 0;
    _labTime.textColor = [UIColor lightGrayColor];
    
    _labCaption = [UILabel new];
    _labCaption.font = [UIFont systemFontOfSize:15];
    _labCaption.numberOfLines = 0;
    _labCaption.textColor = [UIColor blackColor];
    
    _labContent = [UILabel new];
    _labContent.numberOfLines = 0;
    _labContent.font = [UIFont systemFontOfSize:15];
    _labContent.textColor = [UIColor lightGrayColor];
    
    
    
    // 2.1 创建一个流水布局photosView(默认为流水布局)
    _flowPhotosView = [PYPhotosView photosView];

    
    [self.contentView addSubview:_imgHeaderView];
    [self.contentView addSubview:_labUserNickname];
    [self.contentView addSubview:_labTime];
    [self.contentView addSubview:_labCaption];
    [self.contentView addSubview:_labContent];
    
    _imgHeaderView.sd_layout
    .topSpaceToView(self.contentView, 5)
    .leftSpaceToView(self.contentView, 10)
    .heightIs(60)
    .widthIs(60);
    
    _labTime.sd_layout
    .topSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .widthIs(150)
    .heightIs(25);
    
    _labUserNickname.sd_layout
    .leftSpaceToView(_imgHeaderView, 5)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(_labTime, 10);
    [_labUserNickname setMaxNumberOfLinesToShow:2];
    
    _labCaption.sd_layout
    .leftSpaceToView(_imgHeaderView, 5)
    .topSpaceToView(_labUserNickname, 10)
    .rightSpaceToView(self.contentView, 5);
    [_labCaption setMaxNumberOfLinesToShow:2];
    
    _labContent.sd_layout
    .leftSpaceToView(_imgHeaderView, 5)
    .topSpaceToView(_labCaption, 5)
    .rightSpaceToView(self.contentView, 5);
    [_labContent setMaxNumberOfLinesToShow:3];
    
    [self setupAutoHeightWithBottomView:_labContent bottomMargin:10];
}

-(void)setModel:(DymamicModel *)model{
    
    _model = model;
    _imgHeaderView.image = [UIImage imageNamed:@"21416661_1369810244934"];
    _labUserNickname.text = @"用户昵称";
    _labTime.text = model.create_time?model.create_time:@"";
    _labCaption.text = model.title?model.title:@"";
    _labContent.text = model.description?model.description:@"";
    if (model.fengmian) {

        [self.contentView addSubview:_flowPhotosView];
        
        _flowPhotosView.sd_layout
        .leftSpaceToView(_imgHeaderView,10)
        .topSpaceToView(_labContent,10);
        _flowPhotosView.py_y = _labContent.origin.y+_labContent.size.height+10;
        _flowPhotosView.photoWidth = SCREEN_WIDTH/2;
        _flowPhotosView.photoHeight = SCREEN_WIDTH/2;
        _flowPhotosView.photosState = PYPhotosViewStateDidCompose;

        NSMutableArray *thumbnailImageUrls = [NSMutableArray arrayWithArray:@[model.fengmian]];
        // 添加图片(缩略图)链接
        // 1.2 创建图片原图链接数组
        NSMutableArray *originalImageUrls = [NSMutableArray arrayWithArray:@[model.fengmian]];
        // 添加图片(原图)链接
        
        // 设置缩略图数组
        _flowPhotosView.thumbnailUrls = thumbnailImageUrls;
        // 设置原图地址
        _flowPhotosView.originalUrls = originalImageUrls;
        
        
        [self setupAutoHeightWithBottomView:_flowPhotosView bottomMargin:10];
    }
}

@end
