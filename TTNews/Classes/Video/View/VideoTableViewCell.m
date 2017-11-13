//
//  VideoTableViewCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "TTVideo.h"
#import "TTVideoComment.h"
#import "TTVideoUser.h"
#import "VideoPlayView.h"
#import <DKNightVersion.h>
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>

@interface VideoTableViewCell()<VideoPlayViewDelegate,SDWebImageManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIView *VideoContianerView;

@end
@implementation VideoTableViewCell


+(instancetype)cell {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);

    self.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    self.nameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.createdTimeLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.timelabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);

    self.nameLabel.textColor = [UIColor colorWithRed:243/255.0 green:75/255.0 blue:80/255.0 alpha:1.0];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = imageView;
    [SDWebImageManager sharedManager].delegate = self;
}

- (void)setVideo:(TTVideo *)video {
    _video = video;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,video.avatar]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:SDWebImageTransformAnimatedImage];
    self.nameLabel.text = video.nicheng;
    self.createdTimeLabel.text = video.create_time;
    
    self.contentLabel.text = video.title;
    self.vipImageView.hidden = [video.is_top intValue]==1?YES:NO;
    NSInteger count = video.view.integerValue;
    if (count>10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%ld万播放",count/10000];
    } else {
        self.playCountLabel.text = [NSString stringWithFormat:@"%ld播放",(long)count];
    }
    NSInteger time = video.view.integerValue;
    self.timelabel.text = [NSString stringWithFormat:@"%02ld%02ld",time/60,time%60];
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,video.fengmian]]];
    [self setupButton:self.loveButton WithTittle:video.up];
    
    //踩的次数
    [self setupButton:self.repostButton WithTittle:video.down];
    [self setupButton:self.commentButton WithTittle:video.pinglunnum];
//
//    
//    TTVideoComment *comment = video.top_cmt;
//    if(comment) {
//        self.topCommentLabel.text = [NSString stringWithFormat:@"%@ : %@",comment.user.username, comment.content];
//        self.topCommentTopLabel.text = @"最热评论";
//    } else {
//        self.topCommentLabel.text = @"";
//        self.topCommentTopLabel.text = @"";
//    }
    
    
}

- (void)setupButton:(UIButton *)button WithTittle:(NSString *)tittle {
    double number = tittle.doubleValue;
    if (number > 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万",number/10000] forState:UIControlStateNormal];
        return;
    }
    [button setTitle:tittle forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)playVideo:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickVideoButton:)]) {
        [self.delegate clickVideoButton:self.indexPath];
    }
}

- (void)setFrame:(CGRect)frame {
    static CGFloat margin = 10;

    frame.size.width = [UIScreen mainScreen].bounds.size.width;
//    frame.size.height = self.video.cellHeight - margin;
    [super setFrame:frame];
}

- (IBAction)love:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}
//
//- (IBAction)hate:(id)sender {
////    UIButton *button = (UIButton *)sender;
////    button.selected = !button.selected;
//}
//
- (IBAction)repost:(id)sender {

}

- (IBAction)comment:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickCommentButton:)]) {
        [self.delegate clickCommentButton:self.indexPath];
    }
}

//- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL {
//
//    // NO代表透明
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
//
//    // 获得上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    // 添加一个圆
//    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
//    CGContextAddEllipseInRect(context, rect);
//
//    // 裁剪
//    CGContextClip(context);
//
//    // 将图片画上去
//    [image drawInRect:rect];
//
//    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return resultImage;
//}



@end
