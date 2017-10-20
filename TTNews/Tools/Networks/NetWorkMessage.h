//
//  NetWorkMessage.h
//  kindergarten
//
//  Created by Jun on 14-3-19.
//  Copyright (c) 2014年 WXJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkMessage : NSObject

@property(nonatomic,copy) NSString *message;
@property(nonatomic,assign) NetWorkStatuCode statusCode;

@end
