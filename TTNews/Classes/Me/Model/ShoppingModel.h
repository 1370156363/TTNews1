//
//  ShoppingModel.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/6.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingModel : NSObject

/**@brief */
@property (nonatomic , copy) NSString              * ID;
/**@brief 商品名称*/
@property (nonatomic , copy) NSString              * title;
/**@brief 栏目id*/
@property (nonatomic , copy) NSNumber              * category_id;
/**@brief */
@property (nonatomic , copy) NSNumber              * uid;
/**@brief 封面id*/
@property (nonatomic , copy) NSNumber              * cover_id;
/**@brief 商品内容*/
@property (nonatomic , copy) NSString                * content;
/**@brief 0为上架，1为下架*/
@property (nonatomic , copy) NSNumber              * status;
/**@brief 是否置顶*/
@property (nonatomic , copy) NSString                * is_top;
/**@brief 浏览量*/
@property (nonatomic , copy) NSString              * view;
/**@brief */
@property (nonatomic , copy) NSNumber              * update_time;
/**@brief 发布时间*/
@property (nonatomic , copy) NSString              * create_time;
/**@brief 价格*/
@property (nonatomic , copy) NSString                * price;
/**@brief 相册id*/
@property (nonatomic , copy) NSString              * albums;
/**@brief 封面*/
@property (nonatomic , copy) NSString                * fengmian;


@end
