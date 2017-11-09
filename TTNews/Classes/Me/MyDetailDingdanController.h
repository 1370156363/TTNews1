//
//  MyDetailDingdanController.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _DingDanState{
    Dingdan_No_Pay=0,   //未付款
    Dingdan_No_Fahuo,   //未发货
    Dingdan_No_Receive, //为收货
    Dingdan_Back_Pay=4,  //退款
}DINGDANSTATE;

@interface MyDetailDingdanController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) DINGDANSTATE state;

@end
