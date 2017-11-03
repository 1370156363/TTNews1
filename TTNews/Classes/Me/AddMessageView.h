//
//  AddMessageView.h
//  QuestionEveryday
//
//  Created by 薛立强 on 2017/6/20.
//  Copyright © 2017年 薛立强. All rights reserved.
//

typedef void(^addMorePhotoBlock)();

@interface AddMessageView : UIView

@property (nonatomic, strong)  NSMutableArray *selectedPhotos;
@property (nonatomic, strong)  NSMutableArray *selectedAssets;

/** 输入框*/
@property (nonatomic, strong) UITextView    * textContentView;
/** 输入框*/
@property (nonatomic, strong) UITextView    * textTitleView;

/** 即将发布的图片存储的photosView */
@property (nonatomic, weak) PYPhotosView *publishPhotosView;

@property (nonatomic, copy)    addMorePhotoBlock block;

-(void)returnAddMorePhotoBlock:(addMorePhotoBlock)block;

@end
