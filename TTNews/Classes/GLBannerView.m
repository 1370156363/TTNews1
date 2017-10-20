//
//  KGLogController.h
//  Aerospace
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#import "GLBannerView.h"

@implementation GLBannerView
{
    UIScrollView* scrollViews;
    NSMutableArray* imageArray;
    
    UIImageView* imgV0;
    UIImageView* imgV1;
    UIImageView* imgV2;
    CGRect imgFrame;
}

- (id)initWithFrame:(CGRect)frame andImages:(NSArray *)imgs
{
    self = [super initWithFrame:frame];
    if (self) {
        
        imgFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);

        imageArray = [NSMutableArray arrayWithArray:imgs];
        scrollViews = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, imgFrame.size.width, imgFrame.size.height)];
        scrollViews.delegate=self;
        scrollViews.contentSize = CGSizeMake(imgs.count* imgFrame.size.width, imgFrame.size.height);
        scrollViews.contentOffset = CGPointMake(0, 0);
        scrollViews.pagingEnabled = YES;
        scrollViews.bounces = NO;
        scrollViews.showsHorizontalScrollIndicator = NO;
        
        [self addImgViews];
        [self addSubview:scrollViews];
    }
    return self;
}

- (void)addImgViews
{
    imgV0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgFrame.size.width, imgFrame.size.height)];
    imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(imgFrame.size.width, 0, imgFrame.size.width, imgFrame.size.height)];
    imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(2*imgFrame.size.width, 0, imgFrame.size.width, imgFrame.size.height)];
    
    imgV0.image = imageArray[0];
    imgV1.image = imageArray[1];
    imgV2.image = imageArray[2];
    [scrollViews addSubview:imgV0];
    [scrollViews addSubview:imgV1];
    [scrollViews addSubview:imgV2];
    imgV2.userInteractionEnabled=YES;
    [imgV2 wh_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        self.enterBlock();
    }];
}

@end
