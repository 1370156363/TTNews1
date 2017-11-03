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
@property(nonatomic,weak)IBOutlet UIImageView  *headImageView;
@property(nonatomic,weak)IBOutlet UIImageView  *headerImg;
@property(nonatomic,weak)IBOutlet UILabel      *name;
@property(nonatomic,weak)IBOutlet UILabel      *contenttext;
@property(nonatomic,weak)IBOutlet UILabel      *dongtai;
@property(nonatomic,weak)IBOutlet UILabel      *fensi;
@property(nonatomic,weak)IBOutlet UILabel      *jifen;
@property(nonatomic,weak)IBOutlet UILabel      *fangwen;
@property(nonatomic,weak)IBOutlet UIView       *backView;
/**  更新子视图*/
-(void) updateSubView;

@end
