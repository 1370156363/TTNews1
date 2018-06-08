//
//  ChatListViewController.h
//  TTNews
//
//  Created by 薛立强 on 2018/3/9.
//  Copyright © 2018年 瑞文戴尔. All rights reserved.
//

#import "EaseUsersListViewController.h"

@interface ChatListViewController : EaseConversationListViewController<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
