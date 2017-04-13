//
//  Chapter+CoreDataProperties.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chapter+CoreDataProperties.h"

@implementation Chapter (CoreDataProperties)

@dynamic allContentRange;
@dynamic contentRange;
@dynamic title;
@dynamic titleRange;
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.contentRange forKey:@"contentRange"];
    [aCoder encodeObject:self.allContentRange forKey:@"allContentRange"];
    [aCoder encodeObject:self.titleRange forKey:@"titleRange"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.contentRange = [aDecoder decodeObjectForKey:@"contentRange"];
        self.allContentRange = [aDecoder decodeObjectForKey:@"allContentRange"];
        self.titleRange = [aDecoder decodeObjectForKey:@"titleRange"];

    }
    return self;
}
@end
