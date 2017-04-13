//
//  Chapter.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//

#import "Chapter.h"

@implementation Chapter


// Insert code here to add functionality to your managed object subclass
+ (instancetype)modelWithTitle:(NSString *)title
                    titleRange:(NSRange )titleRange
               allContentRange:(NSRange )allContentRange
{
    
    Chapter *model = [[Chapter alloc] init];
    
    model.title = title ;
    model.titleRange = titleRange ;
    model.allContentRange = allContentRange ;
    model.contentRange = NSMakeRange(titleRange.location + titleRange.length,
                                     allContentRange.length - titleRange.length);
    
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:NSStringFromRange(self.contentRange) forKey:@"contentRange"];
    [aCoder encodeObject:NSStringFromRange(self.allContentRange) forKey:@"allContentRange"];
    [aCoder encodeObject:NSStringFromRange(self.titleRange) forKey:@"titleRange"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.contentRange = NSRangeFromString([aDecoder decodeObjectForKey:@"contentRange"]);
        self.allContentRange = NSRangeFromString([aDecoder decodeObjectForKey:@"allContentRange"]);
        self.titleRange = NSRangeFromString([aDecoder decodeObjectForKey:@"titleRange"]);
        
    }
    return self;
}
@end
