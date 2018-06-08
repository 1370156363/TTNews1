//
//  forGetpassoneController.m
//  TTNews
//
//  Created by 王迪 on 2017/9/30.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "forGetpassoneController.h"
#import "forGetpassTwpController.h"

@interface forGetpassoneController ()
{
    IBOutlet UITextField    *field1;
    IBOutlet UITextField    *field2;
    IBOutlet UIView         *backView;
}
@end

@implementation forGetpassoneController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"找回密码";
    backView.layer.cornerRadius=10;
    backView.layer.borderWidth=1;
    backView.layer.borderColor=RGB(220, 220, 220).CGColor;
}

-(IBAction)nextStep:(id)sender
{
    forGetpassTwpController*col = [[forGetpassTwpController alloc] init];
    col.phoneStr = field2.text;
    [self.navigationController pushViewController:col animated:YES];
}
@end
