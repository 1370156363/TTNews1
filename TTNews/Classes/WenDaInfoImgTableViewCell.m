//
//  WenDaInfoImgTableViewCell.m
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "WenDaInfoImgTableViewCell.h"
//#import "XHWebImageAutoSize.h/"


@implementation WenDaInfoImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setImage:(UIImage *)Image{
    
    CGImageRef imageRef = [(UIImage*)Image CGImage];
    NSUInteger width=CGImageGetWidth(imageRef);
    NSUInteger hight=CGImageGetHeight(imageRef);

    CGFloat imagefloat = (CGFloat)hight/(CGFloat)width;
    CGFloat imageShowHight=(SCREEN_WIDTH-30)*imagefloat;
    [self.mainImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(imageShowHight);
    }];
    [self.mainImageView setImage:Image];

}

-(void)setUrl:(NSString *)url{

    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGImageRef imageRef = [(UIImage*)image CGImage];
        NSUInteger width=CGImageGetWidth(imageRef);
        NSUInteger hight=CGImageGetHeight(imageRef);

        CGFloat imagefloat = (CGFloat)hight/(CGFloat)width;
        CGFloat imageShowHight=(SCREEN_WIDTH-30)*imagefloat;
        [self.mainImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageShowHight);
        }];

    }];
}

@end
