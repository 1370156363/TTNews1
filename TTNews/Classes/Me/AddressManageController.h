//
//  AddressManageController.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressManageController : UIViewController
//地址选择时的回调
@property (nonatomic, copy) void (^AddressSelectBlock)(NSDictionary *model);
@property (nonatomic,assign) BOOL isSelectAddress;

@end
