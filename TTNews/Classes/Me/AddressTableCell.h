//
//  AddressTableCell.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressTableBlock)(NSInteger index);

@interface AddressTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *labAddress;

@property (nonatomic, copy) AddressTableBlock block;

-(void)AddressTableReturn:(AddressTableBlock)block;

@end
