//
//  TiWenTableViewCell.h
//  TTNews
//
//  Created by mac on 2017/10/22.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TiWenTableViewCellDelegate<NSObject>

-(void)clickImageBtu:(UIButton *)sender;

@optional


@end


@interface TiWenTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TiWenTableViewCellDelegate> delegate;


@property (strong, nonatomic) IBOutlet UITextField *messageTxt;

@property (strong, nonatomic) IBOutlet UITextView *contextTxt;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;


@property (weak, nonatomic) IBOutlet UIButton *image1;
@property (weak, nonatomic) IBOutlet UIButton *image2;
@property (weak, nonatomic) IBOutlet UIButton *iamgeBtu3;
@property (weak, nonatomic) IBOutlet UIButton *iamgeBtu4;
@property (weak, nonatomic) IBOutlet UIButton *iamgeBtu5;
@property (weak, nonatomic) IBOutlet UIButton *iamgeBtu6;
@property (weak, nonatomic) IBOutlet UIButton *iamgeBtu7;
@property (weak, nonatomic) IBOutlet UIButton *iamgeBtu8;
@property (weak, nonatomic) IBOutlet UIButton *iamgeBtu9;

@property(nonatomic,strong)NSString *Title;
@property(nonatomic,strong) NSString *Content;
@property(nonatomic,strong)NSMutableArray *images;

@end
