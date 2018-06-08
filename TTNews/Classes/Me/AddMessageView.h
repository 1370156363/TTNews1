//
//  AddMessageView.h
//  QuestionEveryday
//
//  Created by 薛立强 on 2017/6/20.
//  Copyright © 2017年 薛立强. All rights reserved.
//

typedef void(^addMorePhotoBlock)();

@interface AddMessageView : UIView


/** 输入框*/
@property (nonatomic, strong) UITextView    * textContentView;
/** 输入框*/
@property (nonatomic, strong) UITextView    * textTitleView;

-(instancetype)initWithState:(BOOL)state;




@end
