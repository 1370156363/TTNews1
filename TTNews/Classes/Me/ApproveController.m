//
//  ApproveController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/5.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "ApproveController.h"
#import "NoApproveView.h"
#import "ApplyApproveController.h"

@interface ApproveController ()

@property (nonatomic, strong) NoApproveView *noApproveView;

@end

@implementation ApproveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGB(220, 220, 220)];
    self.title=@"用户认证";
    [self requestUserApproveState];
    
    // Do any additional setup after loading the view.
}

-(void)requestUserApproveState{
    weakSelf(ws)
    NSMutableDictionary *prms=[@{
                                 @"uid":[[OWTool Instance] getUid] 
                                 }mutableCopy];
    
    [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KNetworkMyApprove withUserInfo:prms success:^(NSDictionary *message)
     {
         if ([message[@"status"] intValue] == -2) {
             //未认证
             [ws.view addSubview:ws.noApproveView];
             ws.noApproveView.isApplyDone = NO;
             [ws.noApproveView setupSubviews];
         }
         else if ([message[@"status"] intValue] == 1){
             //认证完成
         }
         else if ([message[@"status"] intValue] == 0){
             //认证中
             [ws.view addSubview:ws.noApproveView];
             ws.noApproveView.isApplyDone = YES;
             [ws.noApproveView setupSubviews];
         }
         else{
             [SVProgressHUD showSuccessWithStatus:message[@"msg"]];
             [SVProgressHUD dismissWithDelay:2];
             [self popViewController];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

-(void)setupviews{
    
}

-(NoApproveView *)noApproveView{
    if (!_noApproveView) {
        _noApproveView = [[NoApproveView alloc] init];
        [_noApproveView setFrame:self.view.bounds];
        weakSelf(ws)
        _noApproveView.block = ^{
            [ws.navigationController pushViewController:[ApplyApproveController new] animated:YES];
        };
    }
    return _noApproveView;
}
@end
