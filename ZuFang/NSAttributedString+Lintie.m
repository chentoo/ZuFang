//
//  NSAttributedString+Lintie.m
//  dsl
//
//  Created by xiazhidi on 14-5-14.
//  Copyright (c) 2014年 baixing. All rights reserved.
//

#import "NSAttributedString+Lintie.h"

@implementation NSAttributedString (Lintie)


+ (NSAttributedString *)attributedStringWithText:(NSString *)test fontSize:(CGFloat)size
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowBlurRadius = 5;
    shadow.shadowColor = [UIColor blackColor];
    NSDictionary *attrs= @{
                           NSFontAttributeName: [UIFont systemFontOfSize:size],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           NSShadowAttributeName: shadow,
                           };
    
    return [[NSAttributedString alloc] initWithString:test attributes:attrs];
}
@end
