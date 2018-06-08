//
//  MyFensiController.h
//  TTNews
//
//  Created by 薛立强 on 2017/10/28.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFensiController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
/** @brief 关注按钮是否显示*/
@property (nonatomic, assign) BOOL isShowBtnAttention;
/** @brief 邀请别人回答问题按钮是否显示*/
@property (nonatomic,assign) BOOL   isShowBtnInvite;
@property (nonatomic,assign) NSString *answerID;

@end
