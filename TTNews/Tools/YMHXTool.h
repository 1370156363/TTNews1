//
//  YMHXTool.h
//  TTNews
//
//  Created by 薛立强 on 2018/3/7.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMHXTool : NSObject
//排序
+(NSArray *)sortByLocalTime:(NSArray *)conversationArr;

+ (NSString *)timeByMessageTime:(NSString *)dateString;

@end
