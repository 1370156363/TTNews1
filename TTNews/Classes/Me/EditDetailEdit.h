//
//  EditDetailEdit.h
//  Upeer
//
//  Created by Mac on 2016/12/19.
//  Copyright © 2016年 www.kc.com. All rights reserved.
//

#import "KGTableviewCellModel.h"

@interface EditDetailEdit : UITableViewCell
/** @brief 名称*/
@property (nonatomic, weak) UILabel     * labelName;
/** @brief 细节*/
@property (nonatomic, weak) UITextView  * labelDetail;
/** @brief 默认内容*/
@property (nonatomic, weak) UILabel     * labPlacehold;

@property (nonatomic, weak) UIView*lineView;
@property (nonatomic, strong) KGTableviewCellModel *model;

@end
