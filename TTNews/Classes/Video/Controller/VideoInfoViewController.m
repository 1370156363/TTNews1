//
//  VideoInfoViewController.m
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "MyCommentViewController.h"
#import "LoginController.h"

@interface VideoInfoViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

- (IBAction)zanAction:(UIButton *)sender;
- (IBAction)shoucangAction:(UIButton *)sender;
- (IBAction)dashangAction:(UIButton *)sender;
- (IBAction)pinglunAction:(UIButton *)sender;
- (IBAction)zhuanfaAction:(UIButton *)sender;

@end

@implementation VideoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"详情";
    self.url=[NSString stringWithFormat:@"%@/index/news/detail/id/%@/model_id/6",kNewWordBaseURLString,self.url];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

-(void)setupBasic {

    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zanAction:(UIButton *)sender{
    [self AddUserAction:sender];
}

- (IBAction)shoucangAction:(UIButton *)sender{
     [self AddCollect:sender];
}
//- (IBAction)dashangAction:(UIButton *)sender{
//    sender.selected=!sender.selected;
//
//}
- (IBAction)pinglunAction:(UIButton *)sender{
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
        
    }
    else{
        MyCommentViewController *MyCommentViewControlle=[[MyCommentViewController alloc] initWithNibName:@"MyCommentViewController" bundle:nil];
        MyCommentViewControlle.video=self.video;
        
        [self.navigationController pushViewController:MyCommentViewControlle animated:YES];
    }
}

- (IBAction)zhuanfaAction:(UIButton *)sender{
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }else{
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            [self shareWebPageToPlatformType:platformType];
        }];
    }
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = [NSString stringWithFormat:@"%@/index/news/detail/id/%@/model_id/6",kNewWordBaseURLString,self.url];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"新闻分享" descr:_video.title thumImage:[UIImage imageNamed:@"shareIcon.png"]];
    //设置网页地址
    shareObject.webpageUrl = thumbURL;//@"http://mobile.umeng.com/social";
    //图片url
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_userDetailInfo.icon]];
        dispatch_async(dispatch_get_main_queue(), ^{
            //shareObject.thumbImage = [UIImage imageWithData:data];
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self  completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
            }];
        });
    });
    
}
#pragma mark 添加事件
///添加收藏
-(void)AddCollect:(UIButton *)sender{
    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
    else{
        NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.video.ID,@"id",[[OWTool Instance] getUid],@"uid",self.video.model_id,@"model_id",nil];
        
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KnetworkAddcollect withUserInfo:dict success:^(id message) {
            [SVProgressHUD dismiss];
            NSNumber *num=message[@"status"];
            if ([num integerValue]==1) {
                sender.selected=!sender.selected;
            }
            else{
                [SVProgressHUD showErrorWithStatus:message[@"data"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        } visibleHUD:YES];
    }

    
}

///添加点赞
-(void)AddUserAction:(UIButton *)sender{

    if([[OWTool Instance] getUid] == nil || [[[OWTool Instance] getUid] isEqualToString:@""]){
        LoginController* login = [[LoginController alloc] init];
        [self.navigationController pushViewController:login animated:NO];
    }
    else{
        NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.video.ID,@"id",[[OWTool Instance] getUid],@"uid",self.video.model_id,@"model_id",nil];
        [[KGNetworkManager sharedInstance] invokeNetWorkAPIWith:KnetworkAdduserAction withUserInfo:dict success:^(id message) {
            [SVProgressHUD dismiss];
            NSNumber *num=message[@"status"];
            if ([num integerValue]==1) {
                sender.selected=!sender.selected;
            }
            else{
                [SVProgressHUD showErrorWithStatus:message[@"data"]];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        } visibleHUD:YES];
    }
}

@end
