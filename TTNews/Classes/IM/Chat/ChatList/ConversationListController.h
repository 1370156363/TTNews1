//
//  ConversationListController.h
//  TTNews
//
//  Created by mac on 2017/11/5.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <EaseUI/EaseUI.h>

@interface ConversationListController : EaseConversationListViewController

@property (strong, nonatomic) NSMutableArray *conversationsArray;

- (void)refresh;
- (void)refreshDataSource;

- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
