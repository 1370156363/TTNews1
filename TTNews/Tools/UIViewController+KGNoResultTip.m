//
//  UIViewController+KGNoResultTip.m
//  kindergarten
//
//  Created by 王小军 on 15/3/20.
//  Copyright (c) 2015年 wxj. All rights reserved.
//

#import "UIViewController+KGNoResultTip.h"
#import <objc/runtime.h>

static char keyMessageLab;
static char keyImageView;

@implementation UIViewController (KGNoResultTip)

- (void)kg_hidden:(BOOL)hidden{

    UIImageView *imageView = [self kg_imageView];
    UILabel *labMessage = [self kg_labMessage];

    labMessage.hidden = hidden;
    imageView.hidden = hidden;
    
    if (!hidden) {
        [self.view bringSubviewToFront:imageView];
        [self.view bringSubviewToFront:labMessage];
    }
}

- (void)kg_setMessage:(NSString *)message{

    UIImageView *imageView = [self kg_imageView];
    [self kg_setMessage:message withImage:imageView.image];
}

- (void)kg_setImage:(UIImage *)image{

    UILabel *labMessage = [self kg_labMessage];
    [self kg_setMessage:labMessage.text withImage:image];
}

- (void)kg_setMessage:(NSString *)message withImage:(UIImage *)image{

    UILabel *labMessage = [self kg_labMessage];
    labMessage.text = message;
    
    UIImageView *imageView = [self kg_imageView];
    imageView.image = image;
    
    [self kg_layout];
    [self kg_hidden:YES];
}

- (void)kg_layout{

    UIImageView *imageView = [self kg_imageView];
    UILabel *labMessage = [self kg_labMessage];
    [imageView sizeToFit];
    [labMessage sizeToFit];
    imageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    labMessage.frame = CGRectMake(20, CGRectGetMaxY(imageView.frame) + 20, CGRectGetWidth(self.view.bounds)  - 40, CGRectGetHeight(labMessage.bounds));
}

- (UILabel *)kg_labMessage{

    UILabel *labMessage = objc_getAssociatedObject(self, &keyMessageLab);
    if (!labMessage) {
        labMessage = [[UILabel alloc] init];
        labMessage.textAlignment = NSTextAlignmentCenter;
        labMessage.textColor = [UIColor colorWithHexString:@"#ff9000"];
        labMessage.font = [UIFont systemFontOfSize:20.0f];
        labMessage.numberOfLines = 0;
        labMessage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:labMessage];

        objc_setAssociatedObject(self, &keyMessageLab, labMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return labMessage;
}

- (UIImageView *)kg_imageView{

    UIImageView *imageView = objc_getAssociatedObject(self, &keyImageView);
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:imageView];
        
        objc_setAssociatedObject(self, &keyImageView, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageView;
}

@end
