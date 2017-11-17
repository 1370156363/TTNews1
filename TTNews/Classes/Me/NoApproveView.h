//
//  NoApproveView.h
//  TTNews
//
//  Created by 薛立强 on 2017/11/5.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ApproveBtnClick)();

@interface NoApproveView : UIView

@property (nonatomic, assign) BOOL isApplyDone;
    
-(void)setupSubviews;
@property (nonatomic, copy) ApproveBtnClick block;

-(void)ApproveReturnBlock:(ApproveBtnClick)block;

@end
