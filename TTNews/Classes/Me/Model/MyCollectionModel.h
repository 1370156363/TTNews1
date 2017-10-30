//
//  MyCollectionModel.h
//  TTNews
//
//  Created by 薛立强 on 2017/10/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollectionModel : NSObject

/**@brief */
@property (nonatomic , copy) NSNumber              * ID;
/**@brief 用户id*/
@property (nonatomic , copy) NSNumber              * uid;
/**@brief 模型*/
@property (nonatomic , copy) NSNumber              * model_id;
/**@brief 收藏的文章id*/
@property (nonatomic , copy) NSNumber              * article_id;
/**@brief 阅读时间*/
@property (nonatomic , copy) NSString              * create_time;

/**@brief 用户昵称*/
@property (nonatomic , copy) NSString                * nicheng;
/**@brief 用户头像*/
@property (nonatomic , copy) NSString              * avatar;
/**@brief 文章封面*/
@property (nonatomic , copy) NSString                * fengmian;

/**@brief 文章标题*/
@property (nonatomic , copy) NSString              * title;
/**@brief 文章详细信息*/
@property (nonatomic , copy) NSString                * info;

@end
