//
//  BTChapter.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/2.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import "BTChapter.h"
@interface BTChapter()

@end

@implementation BTChapter
+ (instancetype)modelWithTitle:(NSString *)title
                    titleRange:(NSRange )titleRange
               allContentRange:(NSRange )allContentRange
{
    
    BTChapter *model = [[BTChapter alloc]init];
    
    model.title = title ;
    model.titleRange = titleRange ;
    model.allContentRange = allContentRange ;
    model.contentRange = NSMakeRange(titleRange.location + titleRange.length,
                                     allContentRange.length - titleRange.length);
    
    return model;
}
@end
