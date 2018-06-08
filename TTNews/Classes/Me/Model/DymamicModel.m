//
//  DymamicModel.m
//  TTNews
//
//  Created by 薛立强 on 2017/10/27.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "DymamicModel.h"

@implementation DymamicModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"desc":@"description",
             @"description1":@"description",
             @"ID":@"id"
             };
}
@end
