//
//  UIView+extension.m
//  Bullet
//
//  Created by 钟奇龙 on 16/8/27.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "UIView+extension.h"

@implementation UIView (extension)

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
    
}
- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
    
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
    
}

- (CGFloat)x
{
    return self.frame.origin.x;
}
-(CGFloat)y
{
    return self.frame.origin.y;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
@end
