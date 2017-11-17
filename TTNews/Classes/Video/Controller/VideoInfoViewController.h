//
//  VideoInfoViewController.h
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTVideo.h"

@interface VideoInfoViewController : UIViewController

@property(nonatomic,strong)TTVideo *video;

@property(nonatomic,strong)NSString *url;


@end
