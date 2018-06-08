//
//  NewDongTaiViewController.h
//  TTNews
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactListViewController.h"
#import "ChatListViewController.h"

@interface NewDongTaiViewController : UIViewController

@property (strong, nonatomic)ChatListViewController     * chatListCol;
@property (strong, nonatomic)ContactListViewController  * contactListCol;

@property (weak, nonatomic) IBOutlet UIButton *BtnChat;

@property (nonatomic, strong) RKNotificationHub * badgeView;



@end
