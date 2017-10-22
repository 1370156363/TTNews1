//
//  tiwenController.h
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TiWenType)
{
    /*
     问答模式
     */
    WenDaType,
    /*
     动态模式
     */
    DongTaiType
    
};

@interface tiwenController : UIViewController

///判断自己的类型
@property(nonatomic,assign)TiWenType type;

@end
