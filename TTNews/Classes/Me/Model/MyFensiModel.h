//
//  MyFensiModel.h
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFensiModel : NSObject

/**@brief 粉丝id*/
@property (nonatomic , copy) NSNumber              * user_id;
/**@brief 用户id*/
@property (nonatomic , copy) NSNumber              * friend_id;
/**@brief 粉丝签名*/
@property (nonatomic , copy) NSString              * sign;
/**@brief */
@property (nonatomic , copy) NSNumber              * ID;
/**@brief 粉丝昵称*/
@property (nonatomic , copy) NSString              * nicheng;

/**@brief 粉丝头像*/
@property (nonatomic , copy) NSString                * avatar;
/**@brief 用户名称*/
@property (nonatomic , copy) NSString              * username;
/**@brief 添加时间*/
@property (nonatomic , copy) NSString                * create_time;

@end
