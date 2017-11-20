//
//  PhoneVerifyController.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/15.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneVerifyController : UIViewController{
    
}
///请求接口数据
@property (nonatomic, strong) NSMutableDictionary *prms;
///手机号
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
///验证码
@property (weak, nonatomic) IBOutlet UITextField *textVerity;
    
@end
