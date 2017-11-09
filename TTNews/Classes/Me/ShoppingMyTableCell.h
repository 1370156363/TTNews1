//
//  ShoppingMyTableCell.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/6.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShoppingTableBlock)(NSInteger index);

@interface ShoppingMyTableCell : UITableViewCell

@property (nonatomic, copy) ShoppingTableBlock block;

-(void)ShoppingTableReturn:(ShoppingTableBlock)block;

@end
