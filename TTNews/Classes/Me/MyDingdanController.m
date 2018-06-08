//
//  MyDingdanController.m
//  TTNews
//
//  Created by 薛立强 on 2017/11/7.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "MyDingdanController.h"

#import "MyDetailDingdanController.h"


@interface MyDingdanController ()
@property (weak, nonatomic) IBOutlet UIButton *btnDaifukuan;
@property (weak, nonatomic) IBOutlet UIButton *btnDaifahuo;
@property (weak, nonatomic) IBOutlet UIButton *btnDaishouhuo;
@property (weak, nonatomic) IBOutlet UIButton *btnTuikuan;

@end

@implementation MyDingdanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupviews];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupviews{
    
    [_btnDaifukuan setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 0)];
    [_btnDaifukuan setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 30, 0)];
    
    [_btnDaifahuo setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 0)];
    [_btnDaifahuo setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 30, 0)];
    
    [_btnDaishouhuo setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 0)];
    [_btnDaishouhuo setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 30, 0)];
    
    [_btnTuikuan setTitleEdgeInsets:UIEdgeInsetsMake(30, -30, 0, 0)];
    [_btnTuikuan setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 30, 0)];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithRGB(0xf0f0f0, 0x000000, 0xfafafa);
    
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(MainColor,0x444444,MainColor);
}



- (IBAction)btnClick:(UIButton *)sender {
    MyDetailDingdanController *col = [[MyDetailDingdanController alloc] init];
    if(sender.tag == 100){
        col.state = Dingdan_No_Pay;
    }
    else if (sender.tag == 200){
        col.state = Dingdan_No_Fahuo;
    }
    else if (sender.tag == 300){
        col.state = Dingdan_No_Receive;
    }
    else{
        col.state = Dingdan_Back_Pay;
    }
    [self.navigationController pushViewController:col animated:YES];
}


@end
