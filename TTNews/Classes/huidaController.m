//
//  huidaController.m
//  TTNews
//
//  Created by 西安云美 on 2017/7/26.
//  Copyright © 2017年 瑞文戴尔. All rights reserved.
//

#import "huidaController.h"

@interface huidaController ()

@end

@implementation huidaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"撰写回答";
    [self setDoneBarButtonWithSelector:@selector(nextStep) andTitle:@"发布"];
}

-(void)nextStep
{

}
@end
