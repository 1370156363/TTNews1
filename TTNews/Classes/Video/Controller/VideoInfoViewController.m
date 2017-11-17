//
//  VideoInfoViewController.m
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "MyCommentViewController.h"


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
- (IBAction)dashangAction:(UIButton *)sender{
    sender.selected=!sender.selected;

}
- (IBAction)pinglunAction:(UIButton *)sender{

    MyCommentViewController *MyCommentViewControlle=[[MyCommentViewController alloc] initWithNibName:@"MyCommentViewController" bundle:nil];
    MyCommentViewControlle.video=self.video;
    
    [self.navigationController pushViewController:MyCommentViewControlle animated:YES];

}

- (IBAction)zhuanfaAction:(UIButton *)sender{
    sender.selected=!sender.selected;

}

#pragma mark 添加事件
///添加收藏
-(void)AddCollect:(UIButton *)sender{

    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.video.id,@"id",[[OWTool Instance] getUid],@"uid",self.video.model_id,@"model_id",nil];

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

///添加点赞
-(void)AddUserAction:(UIButton *)sender{

    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:self.video.id,@"id",[[OWTool Instance] getUid],@"uid",self.video.model_id,@"model_id",nil];
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

@end
