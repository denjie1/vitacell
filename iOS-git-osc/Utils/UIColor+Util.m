//
//  UIColor+Util.m
//  Git@OSC
//
//  Created by 李萍 on 15/11/23.
//  Copyright © 2015年 chenhaoxiang. All rights reserved.
//

#import "UIColor+Util.h"
#import <YYKit.h>

@implementation UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}


#pragma mark - theme colors

+ (UIColor *)navigationbarColor
{
    return [UIColor colorWithHex:0x0a5090];
}

+ (UIColor *)uniformColor
{
    return [self colorWithLight:@"#f6f6f6" dark:@"#2f2f2f"];
}

+ (UIColor *)textMainColor {
    return [self colorWithLight:@"#111111" dark:@"#ffffff"];
}

+ (UIColor *)textSecondaryColor {
    return [self colorWithLight:@"#9d9d9d" dark:@"#FFFFFF66"];
}

+ (UIColor *)toolbarBackground {
    return [self colorWithLight:@"#ffffff" dark:@"#2C2C2C"];
}

+ (UIColor *)placeHolder {
    return [self colorWithLight:@"#9d9d9d" dark:@"#ffffff66"];
}

+ (UIColor *)contentBackground {
    return [self colorWithLight:@"#f6f6f6" dark:@"#2F2F2F"];
}

+ (UIColor *)colorWithLight:(NSString *)lightString dark:(NSString *)darkString {
    if (@available(iOS 13.0,*)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor colorWithHexString:lightString];
            } else {
                return [UIColor colorWithHexString:darkString];
            }
        }];
    } else {
        return [UIColor colorWithHexString:lightString];
    }
}

+ (UIColor *)cellSelected {
    return [self colorWithLight:@"#f6f6f6" dark:@"#2f2f2f"];
}

@end
