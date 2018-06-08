//
//  DymamicModel.h
//  TTNews
//
//  Created by 薛立强 on 2017/10/27.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DymamicModel : NSObject

/**@brief */
@property (nonatomic , copy) NSNumber              * status;
/**@brief 用户uid*/
@property (nonatomic , copy) NSNumber              * uid;
/**@brief 是否置顶*/
@property (nonatomic , copy) NSNumber              * is_top;
/**@brief */
@property (nonatomic , copy) NSNumber              * ID;
/**@brief 更新时间*/
@property (nonatomic , copy) NSNumber              * update_time;

/**@brief 动态标题*/
@property (nonatomic , copy) NSString                * title;
/**@brief 浏览量*/
@property (nonatomic , copy) NSNumber              * view;
/**@brief 封面id*/
@property (nonatomic , copy) NSString                * cover_id;
/**@brief 动态标题*/
@property (nonatomic , copy) NSString                * create_time;
/**@brief 描述*/
@property (nonatomic , copy) NSString                * description1;

/**@brief 描述*/
@property (nonatomic , copy) NSString                * desc;
/**@brief 发布时间*/
@property (nonatomic , copy) NSString                * fengmian;

@end
