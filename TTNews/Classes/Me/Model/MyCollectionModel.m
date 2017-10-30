//
//  MyCollectionModel.m
//  TTNews
//
//  Created by 薛立强 on 2017/10/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyCollectionModel.h"

@implementation MyCollectionModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",
             };
}

@end
