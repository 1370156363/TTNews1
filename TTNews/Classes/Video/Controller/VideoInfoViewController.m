//
//  VideoInfoViewController.m
//  TTNews
//
//  Created by mac on 2017/10/23.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "VideoInfoViewController.h"

@interface VideoInfoViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;


@end

@implementation VideoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.url=@"http://xinwen.52jszhai.com/index/news/detail/id/6/model_id/6";

    
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
