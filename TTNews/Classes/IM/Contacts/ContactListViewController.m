//
//  ContactListViewController.m
//  TTNews
//
//  Created by mac on 2017/11/5.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ContactListViewController.h"

#import "ChatViewController.h"

//#import "ChatroomListViewController.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"

#import "RealtimeSearchUtil.h"

#import "UIViewController+SearchController.h"
#import "BaseTableViewCell.h"


@implementation NSString (search)

//根据用户昵称进行搜索
- (NSString*)showName
{
    return [UserCacheManager getNickName:self];
}

@end


@interface ContactListViewController ()<UISearchBarDelegate, UIActionSheetDelegate, EaseUserCellDelegate, EMSearchControllerDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;

@property (nonatomic) NSInteger unapplyCount;

@property (nonatomic) NSIndexPath *indexPath;

@end

@implementation ContactListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;

    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];

//    [self setupSearchController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self reloadApplyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - public

- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];

    NSArray *buddyList = [[EMClient sharedClient].contactManager getContacts];

    for (NSString *buddy in buddyList) {
        [self.contactsSource addObject:buddy];
    }
//    [self _sortDataArray:self.contactsSource];

    [self.tableView reloadData];
}

- (void)reloadApplyView
{
//    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
//    self.unapplyCount = count;
    [self.tableView reloadData];
}

- (void)reloadGroupView
{
    [self reloadApplyView];

//    if (_groupController) {
//        [_groupController tableViewDidTriggerHeaderRefresh];
//    }
}

- (void)addFriendAction
{
//    AddFriendViewController *addController = [[AddFriendViewController alloc] init];
//    [self.navigationController pushViewController:addController animated:YES];
}

@end
