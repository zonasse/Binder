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

@dynamic string_allContentRange;
@dynamic string_contentRange;
@dynamic string_title;
@dynamic string_titleRange;
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:self.string_title forKey:@"sub_string_title"];
    [aCoder encodeObject:self.string_contentRange forKey:@"sub_string_contentRange"];
    [aCoder encodeObject:self.string_allContentRange forKey:@"sub_string_allContentRange"];
    [aCoder encodeObject:self.string_titleRange forKey:@"sub_string_titleRange"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.string_title = [aDecoder decodeObjectForKey:@"sub_string_title"];
        self.string_contentRange = [aDecoder decodeObjectForKey:@"sub_string_contentRange"];
        self.string_allContentRange = [aDecoder decodeObjectForKey:@"sub_string_allContentRange"];
        self.string_titleRange = [aDecoder decodeObjectForKey:@"sub_string_titleRange"];

    }
    return self;
}
@end
