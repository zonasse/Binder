//
//  NSString+BTOverRange.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import "NSString+BTOverRange.h"

@implementation NSString (BTOverRange)
//防止越界
- (NSString *)overRange_substringWithRange:(NSRange)range{
    
    if (self.length >= range.location + range.length) {
        return [self substringWithRange:range];
    }
    return @"";
}

- (NSString *)trimmed{
    NSCharacterSet* whiteSpaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:whiteSpaceSet];
}
@end
