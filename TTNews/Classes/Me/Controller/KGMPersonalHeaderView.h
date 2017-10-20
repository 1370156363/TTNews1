//
//  KGMPersonalHeaderView.h
//  Aerospace
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KGMPersonalHeaderView : UIView

@property (nonatomic,copy)void(^KGPersonalCheckBlock)(NSInteger tag);

-(void)reloadHeaderUI:(NSDictionary *)dic;
@end
