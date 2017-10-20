//
//  VideoCommentCell.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoDetailModel;

@interface VideoCommentCell : UITableViewCell

@property (nonatomic, copy) void(^ZanBlock)();
/** 评论 */
@property (nonatomic, strong) VideoDetailModel *comment;

@end
