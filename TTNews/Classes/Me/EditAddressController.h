//
//  EditAddressController.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddressController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSNumber *ID;
///省市区
@property (nonatomic, strong) NSString * addressName;
///详细地址
@property (nonatomic, strong) NSString * ditailAddress;
///收件人
@property (nonatomic, strong) NSString * receiveName;
///电话
@property (nonatomic, strong) NSString * phoneNum;

@property (nonatomic, copy) void(^EditDoneReturnBlock)();

@end
