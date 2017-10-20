//
//  forGetpassTwpController.m
//  TTNews
//
//  Created by 王迪 on 2017/9/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "forGetpassTwpController.h"

@interface forGetpassTwpController ()
{
    IBOutlet UILabel            *phoneNum;
    IBOutlet UITextField        *yzmField;
    IBOutlet UITextField        *passField;
    IBOutlet UIView             *backView1;
    IBOutlet UIView             *backView2;
}
@end

@implementation forGetpassTwpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"找回密码";
    backView1.layer.cornerRadius=10;
    backView1.layer.borderWidth=1;
    backView1.layer.borderColor=RGB(220, 220, 220).CGColor;
    
    backView2.layer.cornerRadius=10;
    backView2.layer.borderWidth=1;
    backView2.layer.borderColor=RGB(220, 220, 220).CGColor;
}


-(IBAction)getYzm:(id)sender
{

}

-(IBAction)passWordCansee:(id)sender
{

}

-(IBAction)Subbmit:(id)sender
{

}

@end
