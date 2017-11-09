//
//  ChatViewController.h
//  TTNews
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import <EaseUI/EaseUI.h>

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface ChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>


- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
