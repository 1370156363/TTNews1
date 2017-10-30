//
//  NewsInfoViewController.m
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "MyCommentViewController.h"


@interface NewsInfoViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;


@property (weak, nonatomic) IBOutlet UIButton *zanAction;

///点赞
- (IBAction)ZanAction:(UIButton *)sender;
///sh
- (IBAction)ShouCangAction:(UIButton *)sender;
- (IBAction)dashangAction:(UIButton *)sender;
- (IBAction)commentAction:(UIButton *)sender;
- (IBAction)FenXiangAction:(UIButton *)sender;


@end

@implementation NewsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详情";
    self.url=[NSString stringWithFormat:@"%@/index/news/detail/id/%@/model_id/4",kNewWordBaseURLString,self.url];
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark -界面跳转
///点赞
- (IBAction)ZanAction:(UIButton *)sender {
    sender.selected=!sender.selected;
}

- (IBAction)ShouCangAction:(UIButton *)sender {
    sender.selected=!sender.selected;
}

- (IBAction)dashangAction:(UIButton *)sender {

}

- (IBAction)commentAction:(UIButton *)sender {
    MyCommentViewController *commnet=[[MyCommentViewController alloc] initWithNibName:@"MyCommentViewController" bundle:nil];
    commnet.video=self.vedio;
    [self.navigationController pushViewController:commnet animated:YES];
    
}

- (IBAction)FenXiangAction:(UIButton *)sender {
    
}
@end
