//
//  NewsInfoViewController.h
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTVideo.h"



@interface NewsInfoViewController : UIViewController

@property(nonatomic,strong)NSString *url;

@property(nonatomic,strong)TTVideo *vedio;

@end
