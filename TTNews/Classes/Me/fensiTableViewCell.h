//
//  fensiTableViewCell.h
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFensiModel.h"
#import "AddUserInfoModel.h"

typedef void(^ImageClickBlock)();

typedef NS_ENUM(NSUInteger, NewTableViewCellType) {
    NewTableViewCellType_Focus = 1,//我的关注
    NewTableViewCellType_AddFocus = 2,//添加关注
    NewTableViewCellType_Invit = 3,//邀请问答
};

@interface fensiTableViewCell : UITableViewCell

@property (nonatomic, strong)  MyFensiModel *model;//我的关注
@property (nonatomic, strong) AddUserInfoModel* model1;//添加关注
@property (nonatomic, strong) AddUserInfoModel* model2;//邀请问答
@property (nonatomic,assign) NSString       *answerID;//问题ID,邀请问答时用
@property (nonatomic, strong) IBOutlet UIImageView *imgHeaderView;
@property (nonatomic, strong) IBOutlet UILabel *labNickname;
@property (nonatomic, strong) IBOutlet UILabel *labSignature;
@property (nonatomic, strong) IBOutlet UIButton *btnAttention;
///用户ID
@property (nonatomic, strong) NSNumber          * userID;

///图像点击回调事件
@property (nonatomic, copy) ImageClickBlock ImageBlock;
@property (nonatomic,assign) NewTableViewCellType type;

@end
