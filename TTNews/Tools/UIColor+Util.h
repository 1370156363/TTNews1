//
//  UIColor+Util.h
//  Sesame
//
//  Created by tenkey on 14-4-18.
//  Copyright (c) 2014年 lc.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

UIColor *ColorRGBAFor255(CGFloat r, CGFloat g, CGFloat b);

UIColor *ColorRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a);

UIColor *ColorHex(NSString *hexString);

UIColor *ColorClear();

UIColor *ColorRandom();

+ (UIColor *)randomColor;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor*)colorWithHex:(NSInteger)hexValue;

- (NSDictionary *)dictionaryComponentsRGB;

- (NSDictionary *)dictionaryComponentsHSB;

- (NSArray *)arrayComponentsRGB;

- (NSArray *)arrayComponentsHSB;

@end
