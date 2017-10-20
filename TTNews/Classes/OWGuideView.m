//
//  OWGuideView.m
//  SmartPartyBuilding
//
//  Created by 王卫华 on 2017/6/26.
//  Copyright © 2017年 王卫华. All rights reserved.
//

#import "OWGuideView.h"
#import "GLBannerView.h"
@implementation OWGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImage* img0 = [UIImage imageNamed:@"welcome_1.jpg"];
        UIImage* img1 = [UIImage imageNamed:@"welcome_2.jpg"];
        UIImage* img2 = [UIImage imageNamed:@"welcome_3.jpg"];
        NSArray *imgs=[NSArray arrayWithObjects:img0,img1,img2, nil];
        GLBannerView* bannerView = [[GLBannerView alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height) andImages:imgs];
        [self addSubview:bannerView];
        weakSelf(ws);
        bannerView.enterBlock=^()
        {
            [UIView animateWithDuration:1 animations:^{
            
                  CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1.0);
                  ws.layer.transform = transform;
                  ws.alpha = 0.0;
            
              } completion:^(BOOL finished) {
                  [ws removeFromSuperview];
                  [[OWTool Instance] SaveStateofInstall:@"1"];
              }];
            };        
    }
    return self;
}


+ (void)push
{
    if ([[[OWTool Instance] getStateofInstall] intValue]!=1)
    {
        UIWindow *window = [UIApplication sharedApplication].windows[0];
        window.hidden=NO;
        OWGuideView *guideView = [[OWGuideView alloc] init];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        [window bringSubviewToFront:guideView];
    }
}

@end
