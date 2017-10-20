//
//  EditController.h
//  meiguan
//
//  Created by 西安云美 on 2017/9/5.
//  Copyright © 2017年 王迪. All rights reserved.
//


@interface EditController : UIViewController
@property(nonatomic,copy)NSString               *titleStr;
@property(nonatomic,weak)IBOutlet UITextField   *field;
@property(nonatomic,weak)IBOutlet UILabel       *descLab;
@property(nonatomic,copy)void (^SendTextBlock)(NSString *str);

@end
