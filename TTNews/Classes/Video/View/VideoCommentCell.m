//
//  VideoCommentCell.m
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import "VideoCommentCell.h"
#import "VideoDetailModel.h"
#import "TTVideoUser.h"
#import <DKNightVersion.h>
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>

@interface VideoCommentCell()<SDWebImageManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@end

@implementation VideoCommentCell

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    self.contentLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.usernameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.likeCountLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    [SDWebImageManager sharedManager].delegate = self;

//    self.profileImageView.layer.cornerRadius = self.profileImageView.width * 0.5;
//    self.profileImageView.layer.masksToBounds = YES;
}

- (void)setComment:(VideoDetailModel *)comment
{
    _comment = comment;
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewWordBaseURLString,comment.avatar]] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:SDWebImageTransformAnimatedImage];
    
    self.contentLabel.text = comment.title;
    CGSize constraint = CGSizeMake(winsize.width-55, 20000.0f);
    CGSize size = [comment.title sizeWithFont:[UIFont systemFontOfSize:15]
                      constrainedToSize:constraint
                          lineBreakMode:1];
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(size.height);
     }];

    self.usernameLabel.text = comment.nicheng;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@", comment.articleid];
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

-(IBAction)ZanAction:(id)sender
{
    self.ZanBlock();
}
@end
