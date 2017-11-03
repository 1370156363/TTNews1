//
//  UserModel.m
//  TTNews
//
//  Created by mac on 2017/10/22.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"uid":@"dtnum",
             };
}
@end
