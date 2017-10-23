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

@end
