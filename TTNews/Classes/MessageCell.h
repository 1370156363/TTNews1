//
//  MessageCell.h
//  Aerospace
//
//  Created by 王迪 on 2017/2/9.
//  Copyright © 2017年 王迪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WendaModel;
@interface MessageCell : UITableViewCell

-(void)updateUIwithdic:(WendaModel *)data;

@property(nonatomic,copy)void (^ImgTapBlock)(UIImageView *imgView,MessageCell *cell);
@end
