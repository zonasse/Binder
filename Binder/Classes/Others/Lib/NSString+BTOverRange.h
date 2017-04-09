//
//  NSString+BTOverRange.h
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BTOverRange)
- (NSString *)overRange_substringWithRange:(NSRange)range;
- (NSString *)trimmed;
@end
