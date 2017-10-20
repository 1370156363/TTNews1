//
//  TTVideo.h
//  TTNews
//
//  Created by 瑞文戴尔 on 16/4/2.
//  Copyright © 2016年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTVideoComment;

@interface TTVideo : NSObject<NSCoding>
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *cover_id;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *is_top;
@property (nonatomic, copy) NSString *view;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *video_http;
@property (nonatomic, copy) NSString *up;
@property (nonatomic, copy) NSString *down;
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *pinglunnum;
@property (nonatomic, copy) NSString *videotime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *nicheng;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *fengmian;
@property (nonatomic, copy) NSString *videourl;
@end