//
//  YMHXTool.m
//  TTNews
//
//  Created by 薛立强 on 2018/3/7.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "YMHXTool.h"

@implementation YMHXTool

+(NSArray *)sortByLocalTime:(NSArray *)conversationArr
{
    return  [conversationArr sortedArrayUsingComparator:^NSComparisonResult(EMConversation*  _Nonnull obj1, EMConversation *  _Nonnull obj2) {
        
        //这里根据客户端接收到该消息的时间来进行排序
        return [@([obj2 latestMessage].localTime) compare:@([obj1 latestMessage].localTime)];
        //降序
    }];
}

+ (NSString *)timeByMessageTime:(NSString *)dateString
{
    
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSDate * nowDate = [NSDate date];
        
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  // 1分钟以内的
            
            dateStr = @"刚刚";
        }else if(time<=60*60){  //  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){   // 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                // 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
                NSLog(@"%@", dateStr);
            }else{
                //  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
}

@end
