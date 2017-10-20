//
//  VideoDetailModel.h
//  TTNews
//
//  Created by 王迪 on 2017/10/6.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface infoModel : NSObject

@property (nonatomic, copy) NSString *category_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *cover_id;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *down;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *is_top;
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *pinglunnum;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *up;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *videotime;
@property (nonatomic, copy) NSString *view;

@end


@interface VideoDetailModel : NSObject
@property (nonatomic, strong)infoModel    *info;
@property (nonatomic, copy) NSString *articleid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *model_id;
@property (nonatomic, copy) NSString *nicheng;
@property (nonatomic, copy) NSString *puid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *view;

@end

