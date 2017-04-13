//
//  BookBrowser+CoreDataProperties.m
//  Binder
//
//  Created by 钟奇龙 on 17/4/8.
//  Copyright © 2017年 com.developer.jaccob. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BookBrowser+CoreDataProperties.h"

@implementation BookBrowser (CoreDataProperties)

@dynamic chapters;
@dynamic currentChapterIndex;
@dynamic fontSize;
@dynamic bookFullName;
@dynamic bookContentString;
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.chapters forKey:@"chapters"];
    [aCoder encodeObject:self.currentChapterIndex forKey:@"currentChapterIndex"];
    [aCoder encodeObject:self.fontSize forKey:@"fontSize"];
    [aCoder encodeObject:self.bookFullName forKey:@"bookFullName"];
    [aCoder encodeObject:self.bookContentString forKey:@"bookContentString"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.chapters = [aDecoder decodeObjectForKey:@"chapters"];
        self.currentChapterIndex = [aDecoder decodeObjectForKey:@"currentChapterIndex"];
        self.fontSize = [aDecoder decodeObjectForKey:@"fontSize"];
        self.bookFullName = [aDecoder decodeObjectForKey:@"bookFullName"];
        self.bookContentString = [aDecoder decodeObjectForKey:@"bookContentString"];
    }
    return self;
}
@end
