//
//  VideoTableViewCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayView.h"
@class VideoPlayView;
@class TTVideo;

@protocol  VideoTableViewCellDelegate<NSObject>

@optional

-(void)clickVideoButton:(NSIndexPath *)indexPath;
-(void)clickCommentButton:(NSIndexPath *)indexPath;
-(void)clickShareButton:(NSIndexPath *)indexPath;

@end

@interface VideoTableViewCell : UITableViewCell

+(instancetype)cell;

@property (nonatomic, strong) TTVideo *video;
@property (nonatomic, weak) id<VideoTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) VideoPlayView *playView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@end
