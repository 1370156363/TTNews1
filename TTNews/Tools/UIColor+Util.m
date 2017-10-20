//
//  UIColor+Util.m
//  Sesame
//
//  Created by tenkey on 14-4-18.
//  Copyright (c) 2014年 lc.org. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

UIColor *ColorRGBAFor255(CGFloat r, CGFloat g, CGFloat b){

    return [UIColor colorWithRed: r/255.0f green: g/255.0f blue: b/255.0f alpha: 1.0f];
}

UIColor *ColorRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a){

    return [UIColor colorWithRed: r green: g blue: b alpha: a];
}

UIColor *ColorHex(NSString *hexString){

    return [UIColor colorWithHexString:hexString];
}

UIColor *ColorClear(){

    return [UIColor clearColor];
}

UIColor *ColorRandom(){

    return [UIColor randomColor];
}

+ (UIColor *)randomColor{

    double rr = arc4random() / ((double) (((u_int64_t)2<<31) -1));
    double rg = arc4random() / ((double) (((u_int64_t)2<<31) -1));
    double rb = arc4random() / ((double) (((u_int64_t)2<<31) -1));
    UIColor *color = [UIColor colorWithRed:rr green:rg blue:rb alpha:1.0];
    return color;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString{

    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float r = ((baseValue >> 24) & 0xFF)/255.0f;
    float g = ((baseValue >> 16) & 0xFF)/255.0f;
    float b = ((baseValue >> 8) & 0xFF)/255.0f;
    float a = ((baseValue >> 0) & 0xFF)/255.0f;
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:a];
    return color;
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue{

    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue{

    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)whiteColorWithAlpha:(CGFloat)alphaValue{

    return [UIColor colorWithHex:0xffffff alpha:alphaValue];
}

+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue{

    return [UIColor colorWithHex:0x000000 alpha:alphaValue];
}



- (NSDictionary *)dictionaryComponentsRGB{

    CGFloat r, g, b, a;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) return nil;
    NSDictionary *dict = @{ @"red": @(r), @"green": @(g), @"blue": @(b), @"alpha": @(a) };
    return dict;
}

- (NSDictionary *)dictionaryComponentsHSB{

    CGFloat h, s, b, a;
    if (![self getHue:&h saturation:&s brightness:&b alpha:&a]) return nil;
    NSDictionary *dict = @{ @"hue": @(h), @"saturation": @(s), @"brightness": @(b), @"alpha": @(a) };
    return dict;
}

- (NSArray *)arrayComponentsRGB{

    CGFloat r, g, b, a;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) return nil;
    NSArray *array = @[ @(r), @(g), @(b), @(a) ];
    return array;
}

- (NSArray *)arrayComponentsHSB{

    CGFloat h, s, b, a;
    if (![self getHue:&h saturation:&s brightness:&b alpha:&a]) return nil;
    NSArray *array = @[ @(h), @(s), @(b), @(a) ];
    return array;
}


@end
