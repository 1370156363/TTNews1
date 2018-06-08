//
//  NewsTableViewCell.h
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTVideo.h"
#import "MyCollectionModel.h"

@interface NewsTableViewCell : UITableViewCell

// 该Model对应的Cell高度
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic,strong)TTVideo *model;
@property (nonatomic, strong)MyCollectionModel *collectionModel;

@end
