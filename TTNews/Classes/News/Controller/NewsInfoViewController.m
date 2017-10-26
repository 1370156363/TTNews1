//
//  NewsInfoViewController.m
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "NewsInfoViewController.h"

@interface NewsInfoViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

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


@end
