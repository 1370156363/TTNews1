//
//  KGMPersonalHeaderView.m
//  Aerospace
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import "KGMPersonalHeaderView.h"
#import "UserModel.h"

@interface KGMPersonalHeaderView ()


@end

@implementation KGMPersonalHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame])
    {
        self=[[NSBundle mainBundle] loadNibNamed:@"KGMPersonalHeaderView" owner:self options:nil][0];
        self.frame=frame;
        weakSelf(ws)
        [_headImageView wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            ws.KGPersonalCheckBlock(50);
        }];
        [_headerImg wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            ws.KGPersonalCheckBlock(60);
        }];
        [_contenttext wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            ws.KGPersonalCheckBlock(70);
        }];
        [self updateSubView];
    }
    return self;
}

-(void) updateSubView{
    //先移除再添加
    for (UIGestureRecognizer *ges in _headImageView.gestureRecognizers) {
        [_headImageView removeGestureRecognizer:ges];
    }
    for (UIGestureRecognizer *ges in _headerImg.gestureRecognizers) {
        [_headerImg removeGestureRecognizer:ges];
    }
    for (UIGestureRecognizer *ges in _contenttext.gestureRecognizers) {
        [_contenttext removeGestureRecognizer:ges];
    }
    weakSelf(ws)
    if ([[OWTool Instance] getUid] == nil || [[OWTool Instance] getUid].length == 0) {
        [_headImageView wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            ws.KGPersonalCheckBlock(50);
        }];
        [self updateSubViewData];
    }
    else{
        _headImageView.userInteractionEnabled = NO;
        _headerImg.userInteractionEnabled = YES;
        _contenttext.userInteractionEnabled = YES;
        [self requestURL];
        
        [_headerImg wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            ws.KGPersonalCheckBlock(60);
        }];
        [_contenttext wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            ws.KGPersonalCheckBlock(70);
        }];
    }
    
}

-(void)requestURL{
    NSMutableDictionary *prms=[@{
                                 @"uid":[[OWTool Instance] getUid]
                                 }mutableCopy];
    weakSelf(ws)
    [[KGNetworkManager sharedInstance] GetInvokeNetWorkAPIWith:KNetworGetUserINfo withUserInfo:prms success:^(NSDictionary *message)
     {
         if ([message[@"status"] intValue]==1)
         {
             [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
             UserModel *userModel = [UserModel mj_objectWithKeyValues:message[@"data"]];
             [[OWTool Instance] setUserInfo:[userModel mj_keyValues]];
             [ws updateSubViewData];
         }
         else
         {
             [SVProgressHUD showImage:nil status:message[@"message"]];
             [SVProgressHUD dismissWithDelay:2];
         }
     } failure:^(NSError *error) {
         
     } visibleHUD:NO];
}

-(void)updateSubViewData{
    if ([[OWTool Instance] getUid] == nil || [[OWTool Instance] getUid].length == 0) {
        _headerImg.image = UIImageNamed(@"geren") ;
        _name.text = @"暂未登录";
        _contenttext.text = @"";
        _dongtai.text = @"0";
        _fensi.text = @"0";
        _jifen.text = @"0";
        _fangwen.text = @"0";
    }else{
        UserModel *userModel = [UserModel mj_objectWithKeyValues:[[OWTool Instance] getUserInfo]];
        [_headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://xinwen.52jszhai.com",userModel.avatar]]];
        _name.text = userModel.nickname;
        _contenttext.text = userModel.signature?userModel.signature:@"这个家伙很懒，什么都没有留下！";
        _dongtai.text = userModel.dtnum;
        _fensi.text = userModel.fensinum;
        _jifen.text = userModel.score;
        _fangwen.text = userModel.fangwennum;
    }
    
    
}
    
-(void)reloadHeaderUI:(NSDictionary *)dic
{

}

-(IBAction)btnSelect:(UIButton *)sender
{
    self.KGPersonalCheckBlock(sender.tag);
}
@end




