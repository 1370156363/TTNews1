//
//  MyShopCollectController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyShopCollectController.h"

@interface MyShopCollectController ()

@end

@implementation MyShopCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
    
    // Do any additional setup after loading the view from its nib.
}


@end
