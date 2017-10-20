//
//  WendaModel.m
//  TTNews
//
//  Created by 王迪 on 2017/10/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "WendaModel.h"

@implementation WendaModel

-(instancetype)init
{
    if (self=[super init])
    {
        [WendaModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"des" : @"description"
                     };
        }];
    }
    return self;
}

@end
