//
//  WebViewController.m
//  CircleOfFriendsDisplay
//
//  Created by liyunxiang on 16/12/6.
//  Copyright © 2016年 李云祥. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height)];
    webView.backgroundColor = [UIColor cyanColor];
    NSURLRequest* request = [NSURLRequest requestWithURL:self.url];//创建NSURLRequest
    [webView loadRequest:request];//加载
    
    [self.view addSubview:webView];
    
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
