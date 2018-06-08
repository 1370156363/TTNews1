//
//  KGDynamicsController.h
//  Aerospace
//
//  Created by 王迪 on 2017/2/22.
//  Copyright © 2017年 王迪. All rights reserved.
//


@interface KGDynamicsController : UIViewController<UITableViewDelegate,UITableViewDataSource>

///当传递时查看的是别人的个人动态
@property (nonatomic, strong) NSString* userID;

@end
